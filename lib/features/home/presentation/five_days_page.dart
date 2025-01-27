import 'package:craft_silicon/common/helpers/create_complex_json.dart';
import 'package:craft_silicon/common/helpers/sizes.dart';
import 'package:craft_silicon/common/utils/colors.dart';
import 'package:craft_silicon/common/utils/textstyle.dart';
import 'package:craft_silicon/features/home/presentation/five_day_details_page.dart';
import 'package:craft_silicon/features/home/repositories/get_5_day_weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewFiveDaysWeatherPage extends HookConsumerWidget {
  const ViewFiveDaysWeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fiveDaysWeather = ref.watch(getFiveDaysWeatherDataProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Five Days Weather",
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
                AppSizes.appCustomSize(100.0),
                AppSizes.appCustomSize(8.0),
                0,
              ),
              child: Column(
                children: [
                  fiveDaysWeather.when(
                      data: (fiveDay) {
                        var groupedWeather = groupWeatherData(fiveDay.list!);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < groupedWeather.length; i++)
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FiveDaysDetailsPage(
                                      weatherData: groupedWeather[i],
                                      city: fiveDay.city,
                                    ),
                                  ));
                                },
                                leading: Image(
                                  image: AssetImage(
                                    "assets/icons/timetable.png",
                                  ),
                                  height: AppSizes.appHeight(30),
                                ),
                                title: Text(
                                  groupedWeather[i].date,
                                  style: fontSize16400,
                                ),
                                subtitle: Text("Click to view more",
                                    style: fontSize10400),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                      color: CRAFTCOLORERROR,
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      groupedWeather[i]
                                          .entries
                                          .length
                                          .toString(),
                                      style: fontSize10400.copyWith(
                                        color: CRAFTCOLORWHITE,
                                      ),
                                    ),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                              ),
                          ],
                        );
                      },
                      loading: () => Center(child: CircularProgressIndicator()),
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
