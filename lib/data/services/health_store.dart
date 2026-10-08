import 'health_repository.dart';
import 'health_store_web.dart'
    if (dart.library.io) 'health_store_mobile.dart'
    as platform;

HealthRepository createHealthRepository() => platform.createHealthRepository();
