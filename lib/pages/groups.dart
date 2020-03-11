import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:syktsu_schedule/bloc/groups/index.dart';

class GroupsPage extends StatelessWidget {
  Widget buildInitial() {
    return Center(child: GroupInputField(''));
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildLoaded(GroupsLoaded state) {
    return Column(children: <Widget>[
      GroupInputField(state.groupName),
      Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.groups.length,
            itemBuilder: (context, i) => ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/schedule',
                    arguments: state.groups[i],
                  );
                },
                title: Text(state.groups[i].title))),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group search'),
        ),
        body: BlocConsumer<GroupsBloc, GroupsState>(
          listener: (context, state) {
            if (state is GroupsError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          builder: (context, state) {
            if (state is GroupsLoading) {
              return buildLoading();
            }
            if (state is GroupsLoaded) {
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
    final bloc = BlocProvider.of<GroupsBloc>(context);
    bloc.add(GetGroups(value));
  }
}
