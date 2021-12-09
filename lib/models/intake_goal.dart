import 'package:hive/hive.dart';

part 'intake_goal.g.dart';

@HiveType(typeId: 6)
class IntakeGoal extends HiveObject {
  @HiveField(0)
  late double intakeGoalAmount;

  IntakeGoal({required this.intakeGoalAmount});
}
