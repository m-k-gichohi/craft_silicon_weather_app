import 'package:craft_silicon/common/common_widgets.dart';
import 'package:craft_silicon/common/helpers/date_time_helpers.dart';
import 'package:craft_silicon/common/helpers/helpers.dart';
import 'package:craft_silicon/common/helpers/sizes.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/textstyle.dart';
import 'package:craft_silicon/features/home/model/five_day_weather_data.dart';
import 'package:craft_silicon/features/home/model/group_weather_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FiveDaysDetailsPage extends HookConsumerWidget {
  const FiveDaysDetailsPage({
    super.key,
    required this.weatherData,
    this.city,
  });
  final GroupedWeatherData weatherData;
  final City? city;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState<int>(0);

    // Update the currentPage state as the user scrolls
    useEffect(() {
      pageController.addListener(() {
        final page = pageController.page?.round() ?? 0;
        if (page != currentPage.value) {
          currentPage.value = page;
        }
      });
      return null;
    }, [pageController]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: Icon(MdiIcons.magnify),
        // ),
        centerTitle: true,
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
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.appCustomSize(8.0),
              AppSizes.appCustomSize(100.0),
              AppSizes.appCustomSize(8.0),
              0,
            ),
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: [
                for (int i = 0; i < weatherData.entries.length; i++)
                  Column(
                    children: [
                      Text(
                        DateTimeHelpers.extractTimeWithAmPm(
                          weatherData.entries[i].dt!,
                        ),
                        style: fontSize30600.copyWith(
                          color: CRAFTCOLORWHITE,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int a = 0;
                              a < weatherData.entries[i].weather!.length;
                              a++)
                            Column(
                              children: [
                                SizedBox(
                                  height: AppSizes.appHeight(200),
                                  child: Image.asset(
                                    Helpers.getWeatherImage(
                                      weatherData.entries[i].weather![a].main!,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Gap(
                                  AppSizes.appHeight(
                                    20,
                                  ),
                                ),
                                Text(
                                  weatherData
                                      .entries[i].weather![a].description!
                                      // weather.weather!.first.description!
                                      .toUpperCase(),
                                  style: fontSize16400.copyWith(
                                    color: CRAFTCOLORBLACK,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                      Gap(
                        AppSizes.appHeight(
                          20,
                        ),
                      ),
                      Text(
                        "${weatherData.entries[i].main?.temp?.toStringAsFixed(1) ?? '0'} °C",
                        style: fontSize40600.copyWith(
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
                              subTitle: DateTimeHelpers.extractTimeWithAmPm(
                                city!.sunrise!,
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
                              subTitle: DateTimeHelpers.extractTimeWithAmPm(
                                  city!.sunset!),
                            ),
                          )
                        ],
                      ),
                      Gap(
                        AppSizes.appHeight(20),
                      ),
                      weatherData.entries[i].wind == null
                          ? SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: icon2ColumnData(
                                    icon: MdiIcons.weatherWindy,
                                    title: "Wind Speed",
                                    subTitle: Helpers
                                            .convertMetersPerSecondToKilometersPerHour(
                                                weatherData
                                                    .entries[i].wind!.speed!)
                                        .toString(),
                                  ),
                                ),
                                weatherData.entries[i].wind == null
                                    ? SizedBox.shrink()
                                    : Gap(
                                        AppSizes.appHeight(20),
                                      ),
                                weatherData.entries[i].wind == null
                                    ? SizedBox.shrink()
                                    : Expanded(
                                        flex: 1,
                                        child: icon2ColumnData(
                                          icon: MdiIcons.windsock,
                                          title: "Wind Direction",
                                          subTitle:
                                              "${weatherData.entries[i].wind!.deg} °",
                                        )),
                              ],
                            ),
                      Gap(
                        AppSizes.appHeight(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          weatherData.entries[i].clouds == null
                              ? SizedBox.shrink()
                              : Expanded(
                                  flex: 1,
                                  child: icon2ColumnData(
                                    icon: MdiIcons.weatherWindy,
                                    title: "Clouds",
                                    subTitle:
                                        "${weatherData.entries[i].clouds!.all}%"
                                            .toString(),
                                  ),
                                ),
                          weatherData.entries[i].rain == null
                              ? SizedBox.shrink()
                              : Gap(
                                  AppSizes.appHeight(20),
                                ),
                          weatherData.entries[i].rain == null
                              ? SizedBox.shrink()
                              : Expanded(
                                  flex: 1,
                                  child: icon2ColumnData(
                                    icon: MdiIcons.windsock,
                                    title: "Rain",
                                    subTitle:
                                        "${weatherData.entries[i].rain!.the3H} mm/3hr",
                                  ),
                                ),
                        ],
                      ),
                      Gap(
                        AppSizes.appHeight(20),
                      ),
                      buildPageIndicators(
                        currentPage: currentPage.value,
                        length: weatherData.entries.length,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageIndicators({
    required int currentPage,
    required int length,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 8),
            height: 10,
            width: currentPage == index
                ? 20
                : 10, // Larger indicator for active page
            decoration: BoxDecoration(
              color: currentPage == index ? CRAFTCOLORWHITE : CRAFTCOLORGREY,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }
}
