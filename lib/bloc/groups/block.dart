import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:syktsu_schedule/data/groups_repository.dart';

import 'event.dart';
import 'state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupsRepository repository;

  GroupsBloc(this.repository);

  @override
  GroupsState get initialState => GroupsInitial();

  @override
  Stream<GroupsState> mapEventToState(GroupsEvent event) async* {
    yield GroupsLoading();
    if (event is GetGroups) {
      try {
        final groups = await repository.fetchGroups(event.groupName);
        yield GroupsLoaded(event.groupName, groups);
      } on Error {
        yield GroupsError("Couldn't fetch groups.");
      }
    }
  }

}