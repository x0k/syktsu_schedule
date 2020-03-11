import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:syktsu_schedule/data/enums/schedule_type.dart';
import 'package:syktsu_schedule/data/schedule_params.dart';
import 'package:syktsu_schedule/data/model/group.dart';
import 'package:syktsu_schedule/bloc/schedule/index.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(ScheduleLoaded state) {
    return Column(children: <Widget>[
      Text(state.schedule.id),
      Text(state.schedule.updateTime.toString()),
      Text(state.weeks.length.toString()),
      Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.weeks.length,
            itemBuilder: (context, i) => ListTile(
                title: Text(state.weeks[i].title))),
      )
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<ScheduleBloc>(context);
    if (bloc.state is ScheduleInitial) {
      final Group group = ModalRoute.of(context).settings.arguments;
      bloc.add(GetSchedule(ScheduleParams(ScheduleType.group, group.id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Group group = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(title: Text('Schedule of ${group.title}')),
        body: BlocConsumer<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          builder: (context, state) {
            if (state is ScheduleLoaded) {
              return buildLoaded(state);
            }
            return buildLoading();
          },
        ));
  }
}
