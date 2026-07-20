//lib/core/network/app_pages.dart
import 'package:flutter/material.dart';

import '../../features/Splash/presentation/screens/splash_page.dart';

import '../../features/auth/presentation/screens/login_page.dart';
import '../../features/dashboard/presentation/screens/dashboard_page.dart';

import '../../features/lots/presentation/screens/lots_page.dart';
import '../../features/lots/presentation/screens/create_lot_page.dart';

import '../../features/monitoring/presentation/screens/lot_detail_page.dart';

import '../../features/qr/presentation/screens/scan_qr_page.dart';

import '../../features/predictions/presentation/screens/prediction_page.dart';

import '../../features/realtime/presentation/screens/realtime_page.dart';

import '../../features/history/presentation/screens/history_page.dart';

import '../../features/alerts/presentation/screens/alerts_page.dart';

import '../../features/reports/presentation/screens/reports_page.dart';


import '../../features/profile/presentation/screens/profile_page.dart';

import '../../features/auth/presentation/screens/register_page.dart';

import '../../features/sensors/presentation/pages/sensors_page.dart';

import '../../features/sensors/presentation/pages/create_sensor_page.dart';

import '../routes/app_routes.dart';


class AppPages {
  AppPages._();

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (_) => const SplashPage(),

    AppRoutes.login: (_) => const LoginPage(),

    AppRoutes.dashboard: (_) => const DashboardPage(),

    AppRoutes.lots: (_) => const LotsPage(),

    AppRoutes.createLot: (_) => const CreateLotPage(),

    AppRoutes.lotDetail: (_) => const LotDetailPage(),

    AppRoutes.qr: (_) => const ScanQrPage(),

    AppRoutes.prediction: (_) => const PredictionPage(),

    AppRoutes.realtime: (_) => const RealtimePage(),

    AppRoutes.history: (_) => const HistoryPage(),

    AppRoutes.alerts: (_) => const AlertsPage(),

    AppRoutes.reports: (_) => const ReportsPage(),

    AppRoutes.profile: (_) => const ProfilePage(),

    AppRoutes.register: (_) => const RegisterPage(),

    AppRoutes.sensors: (_) => const SensorsPage(),

    AppRoutes.createSensor: (_) => const CreateSensorPage(),

  };
}