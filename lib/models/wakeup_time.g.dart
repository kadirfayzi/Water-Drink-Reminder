// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wakeup_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WakeupTimeAdapter extends TypeAdapter<WakeupTime> {
  @override
  final int typeId = 9;

  @override
  WakeupTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WakeupTime(
      wakeupHour: fields[0] as int,
      wakeupMinute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WakeupTime obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.wakeupHour)
      ..writeByte(1)
      ..write(obj.wakeupMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WakeupTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
