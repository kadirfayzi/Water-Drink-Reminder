// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CupAdapter extends TypeAdapter<Cup> {
  @override
  final int typeId = 0;

  @override
  Cup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cup(
      capacity: fields[0] as double,
      image: fields[1] as String,
      selected: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Cup obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.capacity)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
