import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'model/group.dart';

abstract class GroupsRepository {
  Future<List<Group>> fetchGroups(String groupName);
}

class SyktsuGroupsRepository implements GroupsRepository {
  static const _searchURL = 'https://campus.syktsu.ru/schedule/group/';

  static const _groupsSelector = 'button[name=\'group\']';

  static List<Group> _extractGroups(String data) {
    return parse(data)
        .querySelectorAll(_groupsSelector)
        .map((item) => Group(id: item.attributes['value'], title: item.text))
        .toList();
  }

  @override
  Future<List<Group>> fetchGroups(String groupName) {
    return http.post(_searchURL, body: {'num_group': groupName}).then(
        (response) => compute(_extractGroups, response.body));
  }
}
