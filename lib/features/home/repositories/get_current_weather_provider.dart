import 'package:craft_silicon/common/helpers/interceptors/dio_logging.dart';
import 'package:craft_silicon/common/keys/keys_env.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/url.dart';
import 'package:craft_silicon/features/home/model/current_weather.dart';
import 'package:craft_silicon/features/home/repositories/current_location_provider.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_weather_provider.g.dart';

@Riverpod(keepAlive: true)
class GetCurrentWeatherData extends _$GetCurrentWeatherData {
  FutureOr<CurrentWeatherDataModel> getCurrentWeather() async {
    // Get current location from the location provider
    final position = ref.watch(currentLocationStateProvider);

    var url =
        '${AppLicationUrls.baseUrl}weather?lat=${position.phonePosition!.latitude}&lon=${position.phonePosition!.longitude}&appid=${EnvKeys.apiKey}&units=metric';

    CurrentWeatherDataModel weatherData = CurrentWeatherDataModel();

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

      weatherData = CurrentWeatherDataModel.fromJson(res.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        // okotaPayLocator<NavigationService>()
        //     .showSnackBar(message: 'Request timed out.');

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

    return weatherData;
  }

  @override
  FutureOr<CurrentWeatherDataModel> build() async {
    return getCurrentWeather();
  }
}
