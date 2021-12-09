// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intake_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IntakeGoalAdapter extends TypeAdapter<IntakeGoal> {
  @override
  final int typeId = 6;

  @override
  IntakeGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IntakeGoal(
      intakeGoalAmount: fields[0] as double,
    );
  }

  @override
  void write(BinaryWriter writer, IntakeGoal obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.intakeGoalAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntakeGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
