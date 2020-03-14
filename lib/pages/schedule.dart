import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/entities/schedule_params.dart';
import '../core/entities/week.dart';
import '../core/entities/event.dart';
import '../core/entities/schedule.dart';
import '../bloc/schedule/index.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScrollController _scrollController = ScrollController();

  void _loadWeek(ScheduleBloc bloc,
      {Schedule schedule, List<dynamic> events, int week}) {
    bloc.add(LoadWeek(schedule: schedule, events: events, week: week + 1));
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildEvent(dynamic event) {
    if (event is Week) {
      return ListTile(title: Text(event.title));
    }
    if (event is Event) {
      return ListTile(title: Text(event.subject));
    }
    return null;
  }

  Widget buildEvents(ScheduleEvents state) {
    final events = state.events;
    final loading = state.loading;
    return Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: events.length + 1,
        itemBuilder: (context, i) => i == events.length
            ? loading
                ? Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator())
                : FlatButton(
                    child: Text('Показать больше'),
                    onPressed: () {
                      final bloc = BlocProvider.of<ScheduleBloc>(context);
                      _loadWeek(bloc,
                        schedule: state.schedule,
                        events: state.events,
                        week: state.week + 1);
                    },
                  )
            : buildEvent(events[i]),
      ))
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<ScheduleBloc>(context);
    final state = bloc.state;
    if (state is ScheduleInitial) {
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
            if (state is ScheduleLoaded) {
              _scrollController.addListener(() {
                print(_scrollController.position.extentAfter);
                final bloc = BlocProvider.of<ScheduleBloc>(context);
                final state = bloc.state;
                if (_scrollController.position.extentAfter < 300 &&
                    (state is ScheduleEvents)) {
                  if (!state.loading &&
                      state.week < state.schedule.weeks.length - 1) {
                    _loadWeek(bloc,
                        schedule: state.schedule,
                        events: state.events,
                        week: state.week + 1);
                  }
                }
              });
              final bloc = BlocProvider.of<ScheduleBloc>(context);
              final now = DateTime.now();
              final week = state.schedule.weeks
                  .lastIndexWhere((week) => week.startTime.isBefore(now));
              bloc.add(
                  LoadWeek(schedule: state.schedule, events: [], week: week));
            } else if (state is ScheduleError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            } else if (state is ScheduleEvents && !state.loading) {
              print('after loading');
              print(_scrollController.offset);
              print(_scrollController.position.maxScrollExtent);
              print(_scrollController.position.outOfRange);
              print(_scrollController.position);
              if (_scrollController.offset >=
                      _scrollController.position.maxScrollExtent &&
                  !_scrollController.position.outOfRange) {
                print('reach the bottom');
              }
            }
          },
          builder: (context, state) {
            if (state is ScheduleEvents) {
              return buildEvents(state);
            }
            return buildLoading();
          },
        ));
  }
}
