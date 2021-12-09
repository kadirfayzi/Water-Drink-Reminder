// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoundAdapter extends TypeAdapter<Sound> {
  @override
  final int typeId = 4;

  @override
  Sound read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sound(
      soundValue: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sound obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.soundValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
