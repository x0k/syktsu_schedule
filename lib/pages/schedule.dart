import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/entities/schedule_params.dart';
import '../bloc/schedule/index.dart';

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
    final weeks = state.schedule.weeks;
    return Column(children: <Widget>[
      Text(state.schedule.id),
      Text(state.schedule.updateTime.toString()),
      Text(weeks.length.toString()),
      Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: weeks.length,
            itemBuilder: (context, i) => ListTile(title: Text(weeks[i].title))),
      )
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<ScheduleBloc>(context);
    if (bloc.state is ScheduleInitial) {
      final ScheduleParams params = ModalRoute.of(context).settings.arguments;
      bloc.add(GetSchedule(params: params));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScheduleParams params = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(title: Text('Schedule of ${params.title}')),
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
