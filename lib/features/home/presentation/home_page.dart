import 'package:craft_silicon/common/helpers/sizes.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/textstyle.dart';
import 'package:craft_silicon/features/home/repositories/current_location_provider.dart';
import 'package:craft_silicon/features/home/repositories/get_current_weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(getCurrentWeatherDataProvider);
    final currentLocation = ref.watch(currentLocationStateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(MdiIcons.magnify),
        ),
        centerTitle: true,
        title: Text(
          "Weather App",
          style: fontSize14400,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.appCustomSize(8.0),
          AppSizes.appCustomSize(8.0),
          AppSizes.appCustomSize(8.0),
          0,
        ),
        child: currentWeather.when(
            data: (weather) => ListView(
                  physics: ClampingScrollPhysics(),
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentLocation.userAddress!,
                          style: fontSize30600,
                        ),
                        Text(
                          "Today",
                          style: fontSize16400.copyWith(
                            color: CRAFTCOLORGREY,
                          ),
                        ),
                        Text(
                          "${weather.main?.temp?.toStringAsFixed(1) ?? '0'} °C",
                          style: fontSize40600,
                        ),
                        Divider(),
                        Text(
                          weather.weather?.first.description ??
                              'No description',
                          style: fontSize16400.copyWith(
                            color: CRAFTCOLORGREY,
                          ),
                        ),
                        Gap(AppSizes.appHeight(10)),
                        Text(
                          "${weather.main?.tempMin?.toStringAsFixed(1) ?? '0'} °c / ${weather.main?.tempMax?.toStringAsFixed(1) ?? '0'} °C",
                          style: fontSize16400.copyWith(
                            color: CRAFTCOLORCONFLOWERBLUE,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) {
              return Center(
                child: Text(
                  'Error Getting the current location',
                ),
              );
            }),
      ),
    );
  }
}
