import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/entities/list_items.dart';
import '../bloc/schedule/index.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScrollController _scrollController = ScrollController();

  ScheduleBloc _getBloc(BuildContext context) =>
      BlocProvider.of<ScheduleBloc>(context);

  bool _canLoadMore(ScheduleLoaded state) {
    return state.week + 1 >= 0 && state.week + 2 < state.schedule.weeks.length;
  }

  void _loadNextWeek(ScheduleBloc bloc, Schedule schedule, List<ListItem> items,
      int week, int version) {
    bloc.add(LoadWeek(
        schedule: schedule, items: items, week: week + 1, version: version));
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildItem(BuildContext context, ListItem item) {
    final event = item.data;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    if (item is DayListItem) {
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(item.data.name, style: textTheme.headline6));
    }
    if (item is EventListItem) {
      return Card(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              event.numberName,
                              style: textTheme.overline,
                            )),
                        if (event.subGroup != null)
                          Text(
                            event.subGroup,
                            style: textTheme.overline,
                          ),
                      ],
                    ),
                  ),
                  Text(event.place, style: textTheme.caption)
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(event.subject),
              ),
              Text(event.teacher, style: textTheme.caption)
            ]),
      ));
    }
    return null;
  }

  Widget buildLoaded(ScheduleLoaded state) {
    final items = state.items;
    final loading = state.loading;
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length + (_canLoadMore(state) ? 1 : 0),
      itemBuilder: (context, i) => i == items.length
          ? loading
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator()))
              : FlatButton(
                  child: Text('Показать больше'),
                  onPressed: () {
                    final bloc = _getBloc(context);
                    _loadNextWeek(
                        bloc, state.schedule, state.items, state.week + 1, 0);
                  },
                )
          : buildItem(context, items[i]),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = _getBloc(context);
    final state = bloc.state;
    if (state is ScheduleInitial) {
      _scrollController.addListener(() {
        final bloc = _getBloc(context);
        final state = bloc.state;
        if (_scrollController.position.extentAfter < 500 &&
            (state is ScheduleLoaded) &&
            !state.loading &&
            _canLoadMore(state)) {
          _loadNextWeek(bloc, state.schedule, state.items, state.week + 1, 0);
        }
      });
      final Object arg = ModalRoute.of(context).settings.arguments;
      if (arg is Schedule) {
        final now = DateTime.now();
        final week = arg.weeks
            .lastIndexWhere((week) => week.startDateTime.isBefore(now));
        _loadNextWeek(bloc, arg, [], week - 1, 0);
      } else if (arg is ScheduleParams) {
        bloc.add(LoadSchedule(params: arg));
      }
    }
  }

  Widget buildBody(ScheduleState state) {
    if (state is ScheduleLoaded) {
      return buildLoaded(state);
    }
    return buildLoading();
  }

  @override
  Widget build(BuildContext context) {
    final ScheduleParams params = ModalRoute.of(context).settings.arguments;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: Column(children: [
                    if (state is ScheduleLoaded) ...[
                      Text('Расписание ${state.schedule.params.title}',
                          style: textTheme.subtitle1
                              .copyWith(color: Colors.white)),
                      GestureDetector(
                        child: Text(
                            'Обновлено ${state.schedule.versions[state.version].dateTimeName}',
                            style: textTheme.caption
                                .copyWith(color: Colors.white60)),
                        onTap: () {},
                      )
                    ] else
                      Text('Расписание ${params.title}'),
                  ])),
              body: buildBody(state),
            ));
  }
}
