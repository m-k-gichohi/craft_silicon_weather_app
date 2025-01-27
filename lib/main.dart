import 'package:craft_silicon/common/helpers/scroll_behaviour.dart';
import 'package:craft_silicon/features/home/presentation/splash_screen.dart';
import 'package:craft_silicon/features/home/repositories/current_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    requestPermissions(
      ref: ref,
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ScreenUtilInit(
          designSize: Size(
            width,
            height,
          ),
          builder: (context, child) {
            return MaterialApp(
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    scrolledUnderElevation: 0.0,
                    elevation: 0,
                  ),
                  fontFamily: 'Raleway'),
              scrollBehavior: MyCustomScrollBehavior(),
              debugShowCheckedModeBanner: false,
              title: 'Weather App',
              home: SplashScreen(),
            );
          }),
    );
  }
}

Future<void> requestPermissions({required WidgetRef ref}) async {
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  } else {
    ref.watch(currentLocationStateProvider);
  }
}
