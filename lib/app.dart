//app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/navigation/navigator_key.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

import 'features/Splash/presentation/providers/splash_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/register_provider.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/lots/presentation/providers/lot_provider.dart';
import 'features/monitoring/presentation/providers/monitoring_provider.dart';
import 'features/qr/presentation/providers/qr_provider.dart';
import 'features/predictions/presentation/providers/prediction_provider.dart';
import 'features/realtime/presentation/providers/realtime_provider.dart';
import 'features/history/presentation/providers/history_provider.dart';
import 'features/alerts/presentation/providers/alerts_provider.dart';
import 'features/reports/presentation/providers/report_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/sensors/presentation/providers/sensor_provider.dart';

class KajveApp extends StatelessWidget {
  const KajveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => LotProvider()),
        ChangeNotifierProvider(create: (_) => MonitoringProvider()),
        ChangeNotifierProvider(create: (_) => QrProvider()),
        ChangeNotifierProvider(create: (_) => PredictionProvider()),
        ChangeNotifierProvider(create: (_) => RealtimeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => AlertsProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KAJVE',
            navigatorKey: navigatorKey,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppPages.routes,
          );
        },
      ),
    );
  }
}
