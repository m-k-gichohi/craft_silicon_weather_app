import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:craft_silicon/common/helpers/date_time_helpers.dart';
import 'package:craft_silicon/common/helpers/helpers.dart';
import 'package:craft_silicon/common/helpers/sizes.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/textstyle.dart';
import 'package:craft_silicon/features/home/presentation/five_days_page.dart';
import 'package:craft_silicon/features/home/repositories/current_location_provider.dart';
import 'package:craft_silicon/features/home/repositories/get_current_weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(getCurrentWeatherDataProvider);

    final currentLoader = ref.watch(currentLoaderProvider);


    final currentPageDescription = useState("");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[200]!, Colors.blue[700]!],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.appCustomSize(8.0),
                AppSizes.appCustomSize(8.0),
                AppSizes.appCustomSize(8.0),
                0,
              ),
              child: Column(
                children: [
                  if (!currentLoader)
                    currentWeather.when(
                        data: (weather) {
                          currentPageDescription.value =
                              weather.weather!.first.description!;

                          return ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              Text(
                                weather.name!,
                                style: fontSize30600,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  weather.weather!.length > 1
                                      ? CarouselSlider.builder(
                                          options: CarouselOptions(
                                              disableCenter: false,
                                              viewportFraction: 1,
                                              aspectRatio: 16 / 9,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  Duration(milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: true,
                                              enlargeFactor: 0.3,
                                              onPageChanged: (index, reason) {
                                                currentPageDescription.value =
                                                    weather.weather![index]
                                                        .description!;

                                                log(currentPageDescription
                                                    .value);
                                              }),
                                          itemCount: weather.weather!.length,
                                          itemBuilder: (BuildContext context,
                                              int itemIndex,
                                              int pageViewIndex) {
                                            log(currentPageDescription.value);

                                            return SizedBox(
                                              height: AppSizes.appHeight(200),
                                              // width: AppSizes.appWidth(200),
                                              child: Image.asset(
                                                Helpers.getWeatherImage(
                                                  weather.weather![itemIndex]
                                                      .main!,
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          })
                                      : SizedBox(
                                          height: AppSizes.appHeight(200),
                                          // width: AppSizes.appWidth(200),
                                          child: Image.asset(
                                            Helpers.getWeatherImage(
                                              weather.weather![0].main!,
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                  Gap(
                                    AppSizes.appHeight(20),
                                  ),
                                  Text(
                                    "${weather.main?.temp?.toStringAsFixed(1) ?? '0'} °C",
                                    style: fontSize40600.copyWith(
                                      color: CRAFTCOLORWHITE,
                                    ),
                                  ),
                                  Gap(
                                    AppSizes.appHeight(20),
                                  ),
                                  Text(
                                    currentPageDescription.value
                                        // weather.weather!.first.description!
                                        .toUpperCase(),
                                    style: fontSize16400.copyWith(
                                      color: CRAFTCOLORBLACK,
                                    ),
                                  ),
                                  Gap(
                                    AppSizes.appHeight(20),
                                  ),
                                  Text(
                                    DateTimeHelpers.formatTimestamp(
                                        weather.dt!),
                                    style: fontSize16400.copyWith(
                                      color: CRAFTCOLORWHITE,
                                    ),
                                  ),
                                  Gap(
                                    AppSizes.appHeight(20),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: icon2ColumnData(
                                          icon: MdiIcons.weatherSunny,
                                          title: "Sunrise",
                                          subTitle: DateTimeHelpers
                                              .extractTimeWithAmPm(
                                            weather.sys!.sunrise!,
                                          ),
                                        ),
                                      ),
                                      Gap(
                                        AppSizes.appHeight(20),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: icon2ColumnData(
                                          icon: MdiIcons.weatherSunset,
                                          title: "Sunset",
                                          subTitle: DateTimeHelpers
                                              .extractTimeWithAmPm(
                                                  weather.sys!.sunset!),
                                        ),
                                      )
                                    ],
                                  ),
                                  Gap(
                                    AppSizes.appHeight(20),
                                  ),
                                  weather.wind == null
                                      ? SizedBox.shrink()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: icon2ColumnData(
                                                icon: MdiIcons.weatherWindy,
                                                title: "Wind Speed",
                                                subTitle: Helpers
                                                        .convertMetersPerSecondToKilometersPerHour(
                                                            weather
                                                                .wind!.speed!)
                                                    .toString(),
                                              ),
                                            ),
                                            weather.wind == null
                                                ? SizedBox.shrink()
                                                : Gap(
                                                    AppSizes.appHeight(20),
                                                  ),
                                            weather.wind == null
                                                ? SizedBox.shrink()
                                                : Expanded(
                                                    flex: 1,
                                                    child: icon2ColumnData(
                                                      icon: MdiIcons.windsock,
                                                      title: "Wind Direction",
                                                      subTitle:
                                                          "${weather.wind!.deg} °",
                                                    )),
                                          ],
                                        ),
                                  Gap(
                                    AppSizes.appHeight(20),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      weather.clouds == null
                                          ? SizedBox.shrink()
                                          : Expanded(
                                              flex: 1,
                                              child: icon2ColumnData(
                                                icon: MdiIcons.weatherWindy,
                                                title: "Clouds",
                                                subTitle:
                                                    "${weather.clouds!.all}%"
                                                        .toString(),
                                              ),
                                            ),
                                      weather.rain == null
                                          ? SizedBox.shrink()
                                          : Gap(
                                              AppSizes.appHeight(20),
                                            ),
                                      weather.rain == null
                                          ? SizedBox.shrink()
                                          : Expanded(
                                              flex: 1,
                                              child: icon2ColumnData(
                                                icon: MdiIcons.windsock,
                                                title: "Rain",
                                                subTitle:
                                                    "${weather.rain!.the1H} mm/hr",
                                              ),
                                            ),
                                    ],
                                  ),
                                  Gap(
                                    AppSizes.appHeight(20),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "View 5 days of weather",
                                      style: fontSize14400,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ViewFiveDaysWeatherPage()),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                        error: (error, stack) {
                          return Center(
                            child: Text(
                              'Error Getting the current location',
                            ),
                          );
                        }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

icon2ColumnData(
    {required IconData icon, required String title, required String subTitle}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(20.0),
      ),
      color: CRAFTCOLORWHITE,
      boxShadow: [
        BoxShadow(
          color: CRAFTCOLORSUCCESS.withValues(alpha: 0.5),
          spreadRadius: 2,
          blurRadius: 2,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.appHeight(
          20,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Gap(
            AppSizes.appWidth(
              10,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: fontSize10400,
              ),
              Text(
                subTitle,
                style: fontSize14400.copyWith(
                  color: CRAFTCOLORSUCCESS,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
