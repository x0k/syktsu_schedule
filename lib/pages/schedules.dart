import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants.dart';
import '../bloc/schedules/index.dart';

class SchedulesPage extends StatelessWidget {
  void onSelected(BuildContext context, int selected) {
    final bloc = context.bloc<SchedulesBloc>();
    final state = bloc.state;
    if (state is SchedulesLoaded) {
      bloc.add(LoadSchedule(
          type: state.type,
          paramsList: state.paramsList,
          searchPhrase: state.searchPhrase,
          selected: selected));
    }
  }

  Widget buildInitial() {
    return Container();
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(SchedulesLoaded state) {
    final list = state.paramsList;
    return list.length > 0
        ? ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: list.length,
            itemBuilder: (context, i) => ListTile(
                onTap: () => onSelected(context, i),
                title: Text(list[i].title)))
        : Text('Расписания не найдены');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Поиск расписания'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                })
          ],
        ),
        body: Column(children: <Widget>[
          SearchPhraseInput(),
          ScheduleTypeInput(),
          Expanded(
              child: BlocConsumer<SchedulesBloc, SchedulesState>(
            listener: (context, state) {
              if (state is SchedulesSelectedParams) {
                Navigator.pushNamed(
                  context,
                  '/schedule',
                  arguments: state.params,
                );
              } else if (state is SchedulesSelectedSchedule) {
                Navigator.pushNamed(
                  context,
                  '/schedule',
                  arguments: state.schedule,
                );
              } else if (state is SchedulesError) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                ));
              }
            },
            builder: (context, state) {
              if (state is SchedulesLoading) {
                return buildLoading();
              }
              if (state is SchedulesLoaded) {
                return buildLoaded(state);
              }
              return buildInitial();
            },
          )),
        ]));
  }
}

class SearchPhraseInput extends StatefulWidget {
  @override
  _SearchPhraseInputState createState() => _SearchPhraseInputState();
}

class _SearchPhraseInputState extends State<SearchPhraseInput> {
  TextEditingController _controller;

  @override
  void didChangeDependencies() {
    final bloc = context.bloc<SchedulesBloc>();
    final state = bloc.state;
    _controller = TextEditingController(
        text: state is SchedulesLoaded ? state.searchPhrase : '');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
          controller: _controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Введите текст поиска'),
          onSubmitted: (value) => onSubmitted(context, value),
          onChanged: (value) => onChanged(context, value)),
    );
  }

  void onChanged(BuildContext context, String value) {
    if (value != null) {
      final bloc = context.bloc<SchedulesBloc>();
      final state = bloc.state;
      if (state is SchedulesInitial) {
        bloc.add(
            GetLocalScheduleParamsList(type: state.type, searchPhrase: value));
      }
    }
  }

  void onSubmitted(BuildContext context, String value) {
    final bloc = context.bloc<SchedulesBloc>();
    final state = bloc.state;
    if (state is SchedulesInitial) {
      bloc.add(
          GetRemoteScheduleParamsList(type: state.type, searchPhrase: value));
    }
  }
}

class ScheduleTypeInput extends StatefulWidget {
  @override
  _ScheduleTypeInputState createState() => _ScheduleTypeInputState();
}

class _ScheduleTypeInputState extends State<ScheduleTypeInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4)),
            child: BlocBuilder<SchedulesBloc, SchedulesState>(
                builder: (context, state) => state is SchedulesInitial
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: ScheduleType.values
                            .map((type) => ScheduleTypeInputButton(
                                  text: scheduleTypeTitles[type],
                                  selected: type == state.type,
                                  tapHandler: () {
                                    final bloc = context.bloc<SchedulesBloc>();
                                    bloc.add(GetRemoteScheduleParamsList(
                                        type: type,
                                        searchPhrase: state.searchPhrase));
                                  },
                                ))
                            .toList(),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Text('Загрузка')))));
  }
}

class ScheduleTypeInputButton extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function() tapHandler;

  ScheduleTypeInputButton({this.text, this.tapHandler, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.caption;
    return Expanded(
        child: GestureDetector(
            onTap: tapHandler,
            child: Container(
              alignment: Alignment.center,
              height: 32,
              decoration: BoxDecoration(
                  color: selected ? Colors.black38 : Colors.transparent),
              child: Text(text,
                  style: selected
                      ? textStyle.copyWith(color: Colors.white)
                      : textStyle),
            )));
  }
}
