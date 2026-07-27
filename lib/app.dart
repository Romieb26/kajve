//app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/navigation/navigator_key.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class KajveApp extends StatelessWidget {
  const KajveApp({super.key});

  @override
  Widget build(BuildContext context) {
    // designSize ~ tamaño de referencia con el que se diseñaron las
    // pantallas (gama media, ej. Pixel/Galaxy estándar). Todo lo que use
    // .w/.h/.sp/.r escala proporcional a partir de este tamaño base.
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            final themeMode = ref.watch(themeModeControllerProvider);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'KAJVE',
              navigatorKey: navigatorKey,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              initialRoute: AppRoutes.splash,
              routes: AppPages.routes,
            );
          },
        );
      },
    );
  }
}
