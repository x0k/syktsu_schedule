abstract class GroupsEvent {
  const GroupsEvent();
}

class GetGroups extends GroupsEvent {
  final String groupName;

  GetGroups(this.groupName);
}
