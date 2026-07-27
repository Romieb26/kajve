// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kajve/core/di/app_module.dart' as _i892;
import 'package:kajve/core/messaging/fcm_service.dart' as _i675;
import 'package:kajve/core/network/api_client.dart' as _i954;
import 'package:kajve/core/storage/secure_storage.dart' as _i665;
import 'package:kajve/features/alerts/data/datasources/alerts_remote_datasource.dart'
    as _i129;
import 'package:kajve/features/alerts/data/repositories/alerts_repository_impl.dart'
    as _i1029;
import 'package:kajve/features/alerts/domain/repositories/alerts_repository.dart'
    as _i767;
import 'package:kajve/features/alerts/domain/usecases/atender_alerta_usecase.dart'
    as _i440;
import 'package:kajve/features/alerts/domain/usecases/get_alertas_usecase.dart'
    as _i103;
import 'package:kajve/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i376;
import 'package:kajve/features/auth/data/repositories/auth_repository_impl.dart'
    as _i37;
import 'package:kajve/features/auth/domain/repositories/auth_repository.dart'
    as _i1052;
import 'package:kajve/features/auth/domain/usecases/login_usecase.dart'
    as _i166;
import 'package:kajve/features/auth/domain/usecases/logout_usecase.dart'
    as _i1001;
import 'package:kajve/features/auth/domain/usecases/refresh_token_usecase.dart'
    as _i1012;
import 'package:kajve/features/auth/domain/usecases/register_usecase.dart'
    as _i418;
import 'package:kajve/features/dashboard/data/datasources/dashboard_remote_datasource.dart'
    as _i718;
import 'package:kajve/features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i697;
import 'package:kajve/features/dashboard/domain/get_dashboard_usecase.dart'
    as _i1070;
import 'package:kajve/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i310;
import 'package:kajve/features/history/data/datasources/history_remote_datasource.dart'
    as _i242;
import 'package:kajve/features/history/data/repositories/history_repository_impl.dart'
    as _i671;
import 'package:kajve/features/history/domain/repositories/history_repository.dart'
    as _i238;
import 'package:kajve/features/history/domain/usecases/get_historial_usecase.dart'
    as _i842;
import 'package:kajve/features/lots/data/datasources/lot_remote_datasource.dart'
    as _i417;
import 'package:kajve/features/lots/data/datasources/lote_reclamo_remote_datasource.dart'
    as _i156;
import 'package:kajve/features/lots/data/datasources/lots_remote_datasource.dart'
    as _i719;
import 'package:kajve/features/lots/data/repositories/lot_repository_impl.dart'
    as _i767;
import 'package:kajve/features/lots/data/repositories/lote_reclamo_repository_impl.dart'
    as _i166;
import 'package:kajve/features/lots/data/repositories/lots_repository_impl.dart'
    as _i825;
import 'package:kajve/features/lots/domain/create_lote_usecase.dart' as _i570;
import 'package:kajve/features/lots/domain/repositories/lot_repository.dart'
    as _i339;
import 'package:kajve/features/lots/domain/repositories/lote_reclamo_repository.dart'
    as _i331;
import 'package:kajve/features/lots/domain/repositories/lots_repository.dart'
    as _i100;
import 'package:kajve/features/lots/domain/usecases/get_lots.dart' as _i106;
import 'package:kajve/features/lots/domain/usecases/reclamar_lote_usecase.dart'
    as _i826;
import 'package:kajve/features/monitoring/data/datasources/monitoring_remote_datasource.dart'
    as _i57;
import 'package:kajve/features/monitoring/data/datasources/resumen_lote_remote_datasource.dart'
    as _i522;
import 'package:kajve/features/monitoring/data/repositories/monitoring_repository_impl.dart'
    as _i554;
import 'package:kajve/features/monitoring/domain/repositories/monitoring_repository.dart'
    as _i83;
import 'package:kajve/features/monitoring/domain/usecases/get_estadisticas_usecase.dart'
    as _i4;
import 'package:kajve/features/monitoring/domain/usecases/get_lecturas_usecase.dart'
    as _i782;
import 'package:kajve/features/monitoring/domain/usecases/get_resumen_lote_usecase.dart'
    as _i984;
import 'package:kajve/features/predictions/data/datasources/predictions_remote_datasource.dart'
    as _i43;
import 'package:kajve/features/predictions/data/repositories/predictions_repository_impl.dart'
    as _i4;
import 'package:kajve/features/predictions/domain/repositories/predictions_repository.dart'
    as _i548;
import 'package:kajve/features/predictions/domain/usecases/get_predicciones_usecase.dart'
    as _i315;
import 'package:kajve/features/predictions/domain/usecases/get_recomendaciones_usecase.dart'
    as _i658;
import 'package:kajve/features/profile/data/datasources/profile_remote_datasource.dart'
    as _i354;
import 'package:kajve/features/profile/data/repositories/profile_repository_impl.dart'
    as _i158;
import 'package:kajve/features/profile/domain/repositories/profile_repository.dart'
    as _i964;
import 'package:kajve/features/profile/domain/usecases/change_password_usecase.dart'
    as _i853;
import 'package:kajve/features/profile/domain/usecases/get_perfil_usecase.dart'
    as _i869;
import 'package:kajve/features/profile/domain/usecases/update_perfil_usecase.dart'
    as _i94;
import 'package:kajve/features/realtime/data/datasources/realtime_ws_datasource.dart'
    as _i202;
import 'package:kajve/features/reports/data/datasources/reports_remote_datasource.dart'
    as _i516;
import 'package:kajve/features/reports/data/repositories/reports_repository_impl.dart'
    as _i646;
import 'package:kajve/features/reports/domain/repositories/reports_repository.dart'
    as _i535;
import 'package:kajve/features/reports/domain/usecases/descargar_reporte_usecase.dart'
    as _i825;
import 'package:kajve/features/reports/domain/usecases/get_reportes_usecase.dart'
    as _i721;
import 'package:kajve/features/reports/domain/usecases/obtener_reporte_narrativo_usecase.dart'
    as _i99;
import 'package:kajve/features/reports/domain/usecases/solicitar_reporte_usecase.dart'
    as _i444;
import 'package:kajve/features/sensors/data/datasources/sensor_status_remote_datasource.dart'
    as _i279;
import 'package:kajve/features/sensors/data/repositories/sensors_repository_impl.dart'
    as _i510;
import 'package:kajve/features/sensors/domain/repositories/sensors_repository.dart'
    as _i88;
import 'package:kajve/features/sensors/domain/usecases/get_estado_sensores_usecase.dart'
    as _i279;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i202.RealtimeWsDataSource>(() => _i202.RealtimeWsDataSource());
    gh.lazySingleton<_i519.Client>(() => appModule.httpClient);
    gh.lazySingleton<_i675.FcmService>(() => _i675.FcmService());
    gh.lazySingleton<_i665.SecureStorage>(() => _i665.SecureStorage());
    gh.lazySingleton<_i522.ResumenLoteRemoteDataSource>(
      () => _i522.ResumenLoteRemoteDataSourceImpl(
        gh<_i519.Client>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i279.SensorStatusDataSource>(
      () => _i279.SensorStatusRemoteDataSource(
        client: gh<_i519.Client>(),
        secureStorage: gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i954.ApiClient>(
      () => _i954.ApiClient(client: gh<_i519.Client>()),
    );
    gh.lazySingleton<_i57.MonitoringRemoteDataSource>(
      () => _i57.MonitoringRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i719.LotsRemoteDataSource>(
      () => _i719.LotsRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i129.AlertsRemoteDataSource>(
      () => _i129.AlertsRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i242.HistoryRemoteDataSource>(
      () => _i242.HistoryRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i767.AlertsRepository>(
      () => _i1029.AlertsRepositoryImpl(gh<_i129.AlertsRemoteDataSource>()),
    );
    gh.lazySingleton<_i238.HistoryRepository>(
      () => _i671.HistoryRepositoryImpl(gh<_i242.HistoryRemoteDataSource>()),
    );
    gh.lazySingleton<_i718.DashboardRemoteDataSource>(
      () => _i718.DashboardRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i310.DashboardRepository>(
      () =>
          _i697.DashboardRepositoryImpl(gh<_i718.DashboardRemoteDataSource>()),
    );
    gh.lazySingleton<_i156.LoteReclamoRemoteDataSource>(
      () => _i156.LoteReclamoRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i43.PredictionsRemoteDataSource>(
      () => _i43.PredictionsRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i354.ProfileRemoteDataSource>(
      () => _i354.ProfileRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.factory<_i842.GetHistorialUseCase>(
      () => _i842.GetHistorialUseCase(gh<_i238.HistoryRepository>()),
    );
    gh.lazySingleton<_i516.ReportsRemoteDataSource>(
      () => _i516.ReportsRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i548.PredictionsRepository>(
      () =>
          _i4.PredictionsRepositoryImpl(gh<_i43.PredictionsRemoteDataSource>()),
    );
    gh.factory<_i440.AtenderAlertaUseCase>(
      () => _i440.AtenderAlertaUseCase(gh<_i767.AlertsRepository>()),
    );
    gh.factory<_i103.GetAlertasUseCase>(
      () => _i103.GetAlertasUseCase(gh<_i767.AlertsRepository>()),
    );
    gh.lazySingleton<_i88.SensorsRepository>(
      () => _i510.SensorsRepositoryImpl(gh<_i279.SensorStatusDataSource>()),
    );
    gh.lazySingleton<_i535.ReportsRepository>(
      () => _i646.ReportsRepositoryImpl(gh<_i516.ReportsRemoteDataSource>()),
    );
    gh.lazySingleton<_i376.AuthRemoteDataSource>(
      () => _i376.AuthRemoteDataSourceImpl(gh<_i954.ApiClient>()),
    );
    gh.factory<_i825.DescargarReporteUseCase>(
      () => _i825.DescargarReporteUseCase(gh<_i535.ReportsRepository>()),
    );
    gh.factory<_i721.GetReportesUseCase>(
      () => _i721.GetReportesUseCase(gh<_i535.ReportsRepository>()),
    );
    gh.factory<_i99.ObtenerReporteNarrativoUseCase>(
      () => _i99.ObtenerReporteNarrativoUseCase(gh<_i535.ReportsRepository>()),
    );
    gh.factory<_i444.SolicitarReporteUseCase>(
      () => _i444.SolicitarReporteUseCase(gh<_i535.ReportsRepository>()),
    );
    gh.lazySingleton<_i83.MonitoringRepository>(
      () => _i554.MonitoringRepositoryImpl(
        gh<_i57.MonitoringRemoteDataSource>(),
        gh<_i522.ResumenLoteRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i100.LotsRepository>(
      () => _i825.LotsRepositoryImpl(gh<_i719.LotsRemoteDataSource>()),
    );
    gh.lazySingleton<_i417.LotRemoteDataSource>(
      () => _i417.LotRemoteDataSourceImpl(
        gh<_i954.ApiClient>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.factory<_i1070.GetDashboardUseCase>(
      () => _i1070.GetDashboardUseCase(gh<_i310.DashboardRepository>()),
    );
    gh.lazySingleton<_i964.ProfileRepository>(
      () => _i158.ProfileRepositoryImpl(gh<_i354.ProfileRemoteDataSource>()),
    );
    gh.factory<_i279.GetEstadoSensoresUseCase>(
      () => _i279.GetEstadoSensoresUseCase(gh<_i88.SensorsRepository>()),
    );
    gh.lazySingleton<_i331.LoteReclamoRepository>(
      () => _i166.LoteReclamoRepositoryImpl(
        gh<_i156.LoteReclamoRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i339.LotRepository>(
      () => _i767.LotRepositoryImpl(gh<_i417.LotRemoteDataSource>()),
    );
    gh.factory<_i315.GetPrediccionesUseCase>(
      () => _i315.GetPrediccionesUseCase(gh<_i548.PredictionsRepository>()),
    );
    gh.factory<_i658.GetRecomendacionesUseCase>(
      () => _i658.GetRecomendacionesUseCase(gh<_i548.PredictionsRepository>()),
    );
    gh.lazySingleton<_i1052.AuthRepository>(
      () => _i37.AuthRepositoryImpl(
        gh<_i376.AuthRemoteDataSource>(),
        gh<_i665.SecureStorage>(),
      ),
    );
    gh.factory<_i570.CreateLoteUseCase>(
      () => _i570.CreateLoteUseCase(gh<_i100.LotsRepository>()),
    );
    gh.factory<_i166.LoginUseCase>(
      () => _i166.LoginUseCase(gh<_i1052.AuthRepository>()),
    );
    gh.factory<_i1001.LogoutUseCase>(
      () => _i1001.LogoutUseCase(gh<_i1052.AuthRepository>()),
    );
    gh.factory<_i1012.RefreshTokenUseCase>(
      () => _i1012.RefreshTokenUseCase(gh<_i1052.AuthRepository>()),
    );
    gh.factory<_i418.RegisterUseCase>(
      () => _i418.RegisterUseCase(gh<_i1052.AuthRepository>()),
    );
    gh.factory<_i106.GetLotsUseCase>(
      () => _i106.GetLotsUseCase(gh<_i339.LotRepository>()),
    );
    gh.factory<_i4.GetEstadisticasUseCase>(
      () => _i4.GetEstadisticasUseCase(gh<_i83.MonitoringRepository>()),
    );
    gh.factory<_i782.GetLecturasUseCase>(
      () => _i782.GetLecturasUseCase(gh<_i83.MonitoringRepository>()),
    );
    gh.factory<_i984.GetResumenLoteUseCase>(
      () => _i984.GetResumenLoteUseCase(gh<_i83.MonitoringRepository>()),
    );
    gh.factory<_i826.ReclamarLoteUseCase>(
      () => _i826.ReclamarLoteUseCase(gh<_i331.LoteReclamoRepository>()),
    );
    gh.factory<_i853.ChangePasswordUseCase>(
      () => _i853.ChangePasswordUseCase(gh<_i964.ProfileRepository>()),
    );
    gh.factory<_i869.GetPerfilUseCase>(
      () => _i869.GetPerfilUseCase(gh<_i964.ProfileRepository>()),
    );
    gh.factory<_i94.UpdatePerfilUseCase>(
      () => _i94.UpdatePerfilUseCase(gh<_i964.ProfileRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i892.AppModule {}
