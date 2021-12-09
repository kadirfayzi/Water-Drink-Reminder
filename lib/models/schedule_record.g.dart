// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleRecordAdapter extends TypeAdapter<ScheduleRecord> {
  @override
  final int typeId = 3;

  @override
  ScheduleRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleRecord(
      time: fields[0] as String,
      isSet: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.isSet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
