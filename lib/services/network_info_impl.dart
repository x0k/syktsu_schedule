import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:preferences/preferences.dart';

import '../constants.dart';
import '../data/services/network_info.dart';

class SyktsuNetworkInfo implements NetworkInfo {
  final DataConnectionChecker checker;

  SyktsuNetworkInfo(this.checker);

  @override
  Future<bool> get isConnected => PrefService.getBool(OFFLINE_MODE) ?? false
      ? Future.value(false)
      : checker.hasConnection;
}
