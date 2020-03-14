import 'package:data_connection_checker/data_connection_checker.dart';

import '../core/services/network_info.dart';

class SyktsuNetworkInfo implements NetworkInfo {
  final DataConnectionChecker checker;

  SyktsuNetworkInfo(this.checker);

  @override
  Future<bool> get isConnected => checker.hasConnection;
}
