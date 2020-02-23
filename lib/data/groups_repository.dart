import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'model/group.dart';

abstract class GroupsRepository {
  Future<List<Group>> fetchGroups(String groupName);
}

class SyktsuGroupsRepository implements GroupsRepository {
  static final _searchURL = 'https://campus.syktsu.ru/schedule/group/';
  static final _searchHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  List<Group> _processResponse(http.Response response) {
    return parse(response.body)
        .querySelectorAll('button[name=\'group\']')
        .map((item) => Group(id: item.attributes['value'], title: item.text))
        .toList();
  }

  @override
  Future<List<Group>> fetchGroups(String groupName) {
    final body = {'num_group': groupName};
    return http
        .post(_searchURL, headers: _searchHeaders, body: body)
        .then(_processResponse);
  }
}
