import 'services/query_service.dart';

abstract class SyktsuLocalDataSource {
  final QueryService queryService;

  const SyktsuLocalDataSource(this.queryService);
}
