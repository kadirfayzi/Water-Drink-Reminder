import 'dart:async';
import 'package:health/health.dart';

class HealthService {
  final HealthFactory _health = HealthFactory();

  /// Add intake water amount to health app.
  Future addWaterToHealthApp(double waterAmount) async {
    final now = DateTime.now();

    final types = [HealthDataType.WATER];
    final rights = [HealthDataAccess.WRITE];
    final permissions = [HealthDataAccess.READ_WRITE];
    bool? hasPermissions = await HealthFactory.hasPermissions(types, permissions: rights);
    if (hasPermissions == false) {
      return await _health.requestAuthorization(types, permissions: permissions);
    }

    bool success = await _health.writeHealthData(waterAmount, HealthDataType.WATER, now, now);
    print('water added to health app : $success');
  }
}
