// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bed_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BedTimeAdapter extends TypeAdapter<BedTime> {
  @override
  final int typeId = 10;

  @override
  BedTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BedTime(
      bedHour: fields[0] as int,
      bedMinute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BedTime obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.bedHour)
      ..writeByte(1)
      ..write(obj.bedMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BedTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
