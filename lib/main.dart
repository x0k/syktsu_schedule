import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:preferences/preferences.dart';

import 'bloc/schedules/block.dart';
import 'bloc/schedule/bloc.dart';
import 'data/syktsu_schedule_params_list_repository.dart';
import 'data/syktsu_schedule_repository.dart';
import 'data_sources/syktsu_schedule_params_list_remote_data_source.dart';
import 'data_sources/syktsu_schedule_remote_data_source.dart';
import 'data_sources/syktsu_schedule_params_list_local_data_source.dart';
import 'data_sources/syktsu_schedule_local_data_source.dart';
import 'services/items_maker_impl.dart';
import 'services/network_info_impl.dart';
import 'services/syktsu_document_parser.dart';
import 'services/syktsu_query_service.dart';
import 'services/syktsu_database_provider.dart';
import 'pages/schedules.dart';
import 'pages/schedule.dart';
import 'pages/settings.dart';

void main() async {
  initializeDateFormatting('ru', null);
  Intl.defaultLocale = 'ru';
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final parser = SyktsuDocumentParser();
    final networkInfo = SyktsuNetworkInfo(DataConnectionChecker());
    final queryService = SyktsuQueryService(SyktsuDatabaseProvider.instance);
    final paramsListRepository = SyktsuScheduleParamsListRepository(
        remote: SyktsuScheduleParamsListRemoteDatasource(parser),
        local: SyktsuScheduleParamsListLocalDataSource(queryService),
        network: networkInfo);
    final scheduleRepository = SyktsuScheduleRepository(
        remote: SyktsuScheduleRemoteDataSource(parser),
        local: SyktsuScheduleLocalDataSource(queryService),
        network: networkInfo);
    final maker = ItemsMakerImpl();
    return MaterialApp(
      title: 'Syktsu schedule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/schedules',
      routes: <String, WidgetBuilder>{
        '/schedules': (context) => BlocProvider(
              create: (context) => SchedulesBloc(paramsListRepository),
              child: SchedulesPage(),
            ),
        '/schedule': (context) => BlocProvider(
            create: (context) =>
                ScheduleBloc(scheduleRepository, paramsListRepository, maker),
            child: SchedulePage()),
        '/settings': (context) => SettingsPage()
      },
    );
  }
}
