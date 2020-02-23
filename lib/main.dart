import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/groups/block.dart';
import 'data/groups_repository.dart';
import 'pages/groups.dart';

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
      routes: <String, WidgetBuilder> {
        '/groups': (BuildContext context) => BlocProvider(
          create: (context) => GroupsBloc(SyktsuGroupsRepository()),
          child: GroupsPage(),
        )
      },
    );
  }
}
