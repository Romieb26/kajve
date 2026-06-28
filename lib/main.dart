import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/ app_routes.dart';

// Providers
import 'features/Splash/ presentation/ providers/splash_provider.dart';

import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';

import 'features/lots/presentation/providers/lot_provider.dart';

import 'features/monitoring/presentation/providers/monitoring_provider.dart';

import 'features/qr/presentation/providers/qr_provider.dart';

import 'features/predictions/presentation/providers/prediction_provider.dart';

import 'features/realtime/presentation/providers/realtime_provider.dart';

import 'features/ history/presentation/providers/ history_provider.dart';

import 'features/alerts/presentation/providers/alerts_provider.dart';

import 'features/reports/ presentation/providers/ report_provider.dart';

import 'features/profile/presentation/ providers/profile_provider.dart';


void main() {
  runApp(const KajveApp());
}

class KajveApp extends StatelessWidget {
  const KajveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Splash
        ChangeNotifierProvider(
          create: (_) => SplashProvider(),
        ),

        /// Login
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        /// Dashboard
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),

        /// Lotes
        ChangeNotifierProvider(
          create: (_) => LotProvider(),
        ),

        /// Monitoreo
        ChangeNotifierProvider(
          create: (_) => MonitoringProvider(),
        ),

        /// QR
        ChangeNotifierProvider(
          create: (_) => QrProvider(),
        ),

        /// Predicciones
        ChangeNotifierProvider(
          create: (_) => PredictionProvider(),
        ),

        /// Tiempo Real
        ChangeNotifierProvider(
          create: (_) => RealtimeProvider(),
        ),

        /// Historial
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(),
        ),

        /// Alertas
        ChangeNotifierProvider(
          create: (_) => AlertsProvider(),
        ),

        /// Reportes
        ChangeNotifierProvider(
          create: (_) => ReportProvider(),
        ),

        /// Perfil
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'KAJVE',

        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,

        // Rutas
        initialRoute: AppRoutes.splash,

        routes: AppPages.routes,
      ),
    );
  }
}