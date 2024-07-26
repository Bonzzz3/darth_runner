// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rundata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RundataAdapter extends TypeAdapter<Rundata> {
  @override
  final int typeId = 1;

  @override
  Rundata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rundata(
      hiveDistance: fields[0] as double,
      hiveDate: fields[3] as DateTime,
      hiveTime: fields[1] as String,
      hivePace: fields[2] as double,
      hiveRunTitle: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Rundata obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.hiveDistance)
      ..writeByte(1)
      ..write(obj.hiveTime)
      ..writeByte(2)
      ..write(obj.hivePace)
      ..writeByte(3)
      ..write(obj.hiveDate)
      ..writeByte(4)
      ..write(obj.hiveRunTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RundataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
