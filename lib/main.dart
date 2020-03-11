import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/groups_repository.dart';
import 'data/schedule_repository.dart';
import 'bloc/groups/block.dart';
import 'bloc/schedule/bloc.dart';
import 'pages/groups.dart';
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
      initialRoute: '/groups',
      routes: <String, WidgetBuilder>{
        '/groups': (context) => BlocProvider(
              create: (context) => GroupsBloc(SyktsuGroupsRepository()),
              child: GroupsPage(),
            ),
        '/schedule': (context) => BlocProvider(
            create: (context) => ScheduleBloc(SyktsuScheduleRepository()),
            child: SchedulePage())
      },
    );
  }
}
