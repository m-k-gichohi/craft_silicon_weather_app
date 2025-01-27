import 'package:craft_silicon/common/helpers/interceptors/dio_logging.dart';
import 'package:craft_silicon/common/helpers/offline/weather_db_helper.dart';
import 'package:craft_silicon/common/keys/keys_env.dart';
import 'package:craft_silicon/common/service/connectivity_service.dart';
import 'package:craft_silicon/common/service/weather_service.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/url.dart';
import 'package:craft_silicon/features/home/model/current_weather.dart';
import 'package:craft_silicon/features/home/repositories/current_location_provider.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_weather_provider.g.dart';

final savedWeatherTimeProvider = StateProvider((ref) => 0);

@Riverpod(keepAlive: true)
class GetCurrentWeatherData extends _$GetCurrentWeatherData {
  FutureOr<CurrentWeatherDataModel> getCurrentWeather() async {
    CurrentWeatherDataModel weatherData = CurrentWeatherDataModel();

    if (await ConnectivityService.hasInternetConnection()) {
      final position = ref.watch(currentLocationStateProvider);
      final locationLoadings = ref.watch(currentLoaderProvider);

      if (!locationLoadings) {
        var url =
            '${AppLicationUrls.baseUrl}weather?lat=${position.latitude}&lon=${position.longitude}&appid=${EnvKeys.apiKey}&units=metric';

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

          await WeatherService.saveCurrentWeather(res.data);

          weatherData = CurrentWeatherDataModel.fromJson(res.data);
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
      }

      return weatherData;
    } else {
      final savedData = await WeatherDbHelper.getWeatherData("current_weather");

      final savedDataTime =
          await WeatherDbHelper.getSavedTime("current_weather");

      ref.read(savedWeatherTimeProvider.notifier).state = savedDataTime;

      weatherData = CurrentWeatherDataModel.fromJson(savedData!);
      ref.read(currentLoaderProvider.notifier).state = false;

      return weatherData;
    }
  }

  updateData() async {
    state = AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return getCurrentWeather();
    });
  }

  @override
  FutureOr<CurrentWeatherDataModel> build() async {
    return getCurrentWeather();
  }
}
