import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants.dart';
import '../bloc/schedules/index.dart';

class SchedulesPage extends StatelessWidget {
  void onSelected(BuildContext context, int selected) {
    final bloc = BlocProvider.of<SchedulesBloc>(context);
    final state = bloc.state;
    if (state is SchedulesLoaded) {
      bloc.add(SelectSchedule(
          type: state.type,
          paramsList: state.paramsList,
          searchPhrase: state.searchPhrase,
          selected: selected));
    }
  }

  Widget buildInitial() {
    return Center(child: GroupInputField(''));
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(SchedulesLoaded state) {
    final list = state.paramsList.list;
    return Column(children: <Widget>[
      GroupInputField(state.searchPhrase),
      Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: list.length,
            itemBuilder: (context, i) => ListTile(
                onTap: () => onSelected(context, i),
                title: Text(list[i].title))),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group search'),
        ),
        body: BlocConsumer<SchedulesBloc, SchedulesState>(
          listener: (context, state) {
            if (state is SchedulesSelected) {
              Navigator.pushNamed(
                context,
                '/schedule',
                arguments: state.paramsList.list[state.selected],
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
        ));
  }
}

class GroupInputField extends StatelessWidget {
  final String _initialSearchValue;

  GroupInputField(this._initialSearchValue);

  initialValue(String value) {
    return TextEditingController(text: value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
          controller: initialValue(_initialSearchValue),
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input group number'),
          onSubmitted: (value) => onSubmitted(context, value)),
    );
  }

  void onSubmitted(BuildContext context, String value) {
    final bloc = BlocProvider.of<SchedulesBloc>(context);
    bloc.add(GetSchedules(type: ScheduleType.group, searchPhrase: value));
  }
}