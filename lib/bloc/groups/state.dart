import 'package:syktsu_schedule/data/model/group.dart';

abstract class GroupsState {
  const GroupsState();
}

class GroupsInitial extends GroupsState {
  const GroupsInitial();
}

class GroupsLoading extends GroupsState {
  const GroupsLoading();
}

class GroupsLoaded extends GroupsState {
  final String groupName;
  final List<Group> groups;
  
  const GroupsLoaded(this.groupName, this.groups);
}

class GroupsError extends GroupsState {
  final String message;
  const GroupsError(this.message);
}