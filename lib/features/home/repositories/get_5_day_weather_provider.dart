import 'package:craft_silicon/common/helpers/interceptors/dio_logging.dart';
import 'package:craft_silicon/common/helpers/offline/weather_db_helper.dart';
import 'package:craft_silicon/common/keys/keys_env.dart';
import 'package:craft_silicon/common/service/connectivity_service.dart';
import 'package:craft_silicon/common/service/weather_service.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/url.dart';
import 'package:craft_silicon/features/home/model/five_day_weather_data.dart';
import 'package:craft_silicon/features/home/repositories/current_location_provider.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_5_day_weather_provider.g.dart';

final savedForecastTimeProvider = StateProvider((ref) => 0);

@Riverpod(keepAlive: true)
class GetFiveDaysWeatherData extends _$GetFiveDaysWeatherData {
  FutureOr<FiveDayWeatherDataModel> getWeather() async {
    FiveDayWeatherDataModel weathertData = FiveDayWeatherDataModel();

    if (await ConnectivityService.hasInternetConnection()) {
            ref.read(savedForecastTimeProvider.notifier).state = 0;

      final position = ref.watch(currentLocationStateProvider);

      var url =
          '${AppLicationUrls.baseUrl}forecast?lat=${position.latitude}&lon=${position.longitude}&appid=${EnvKeys.apiKey}&units=metric';

      final dio = Dio();
      dio.interceptors.add(Logging());
      dio.interceptors.add(RetryInterceptor(
        dio: dio,
        retries: 10,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ));
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
      Response? res;

      try {
        res = await dio.get(
          url,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        await WeatherService.saveForecast(res.data);

        weathertData = FiveDayWeatherDataModel.fromJson(res.data);
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout) {
          Fluttertoast.showToast(
            msg: "Request timed out.",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: CRAFTCOLORERROR,
            textColor: CRAFTCOLORWHITE,
          );
        }
        if (e.type == DioExceptionType.badResponse) {
          final errorResponse = e.response;

          debugPrint("da $errorResponse");
          if (errorResponse != null && errorResponse.data != null) {
            final errorMessage = errorResponse.data['error'];
            if (errorMessage != null) {
              Fluttertoast.showToast(
                msg: "Error while processing request. Please try again",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: CRAFTCOLORERROR,
                textColor: CRAFTCOLORWHITE,
              );
            }
          }
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error while processing request. Please try again",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: CRAFTCOLORERROR,
          textColor: CRAFTCOLORWHITE,
        );
      }

      return weathertData;
    } else {
      final savedData =
          await WeatherDbHelper.getWeatherData("forecast_weather");

      final savedDataTime =
          await WeatherDbHelper.getSavedTime("forecast_weather");

      ref.read(savedForecastTimeProvider.notifier).state = savedDataTime;

      weathertData = FiveDayWeatherDataModel.fromJson(savedData!);
      ref.read(currentLoaderProvider.notifier).state = false;

      return weathertData;
    }
  }

  @override
  FutureOr<FiveDayWeatherDataModel> build() async {
    return getWeather();
  }
}
