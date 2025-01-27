
import 'package:craft_silicon/common/keys/keys_env.dart';
import 'package:craft_silicon/common/utils/url.dart';
import 'package:craft_silicon/features/home/model/cities_models.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final searchLocationLoaderProvider = StateProvider((ref) => false);


final searchLocationStateProvider = StateNotifierProvider<SearchLocationState,
    List<CitiesDataModel>>((ref) => SearchLocationState(ref));

class SearchLocationState
    extends StateNotifier<List<CitiesDataModel>> {
  final Ref ref;

  SearchLocationState(this.ref) : super([]);

  /// Get the current phone position using geolocator
  getSuggestions({required String text}) async {
    ref.read(searchLocationLoaderProvider.notifier).state = true;
    List<CitiesDataModel> suggestions = [];

    final dio = Dio();
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

        var url =
        '${AppLicationUrls.mainUrl}geo/1.0/direct?q=$text&appid=${EnvKeys.apiKey}&limit=5';


    final res = await dio.get(
      url,
    
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ),
    );

    if (res.statusCode != 200) {
      ref.read(searchLocationLoaderProvider.notifier).state = false;

      throw Exception('http.get error: statusCode= ${res.statusCode}');
    }
    if (res.statusCode == 200) {
      if (res.data != null) {
        ref.read(searchLocationLoaderProvider.notifier).state = false;

        suggestions = (res.data as List)
            .map((x) => CitiesDataModel.fromJson(x))
            .toList();

        state = suggestions;
      }
    }
  }
}
