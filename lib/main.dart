import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/schedules/block.dart';
import 'bloc/schedule/bloc.dart';
import 'data/syktsu_schedule_params_list_repository.dart';
import 'data/syktsu_schedule_repository.dart';
import 'datasources/syktsu_schedule_params_list_remote_datasource.dart';
import 'datasources/syktsu_schedule_remote_datasource.dart';
import 'pages/schedules.dart';
import 'pages/schedule.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syktsu schedule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/schedules',
      routes: <String, WidgetBuilder>{
        '/schedules': (context) => BlocProvider(
              create: (context) => SchedulesBloc(
                  SyktsuScheduleParamsListRepository(
                      remoteDataSource:
                          SyktsuScheduleParamsListRemoteDatasource())),
              child: SchedulesPage(),
            ),
        '/schedule': (context) => BlocProvider(
            create: (context) => ScheduleBloc(SyktsuScheduleRepository(
                remoteDataSource: SyktsuScheduleRemoteDataSource())),
            child: SchedulePage())
      },
    );
  }
}
