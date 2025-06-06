// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServicesModelAdapter extends TypeAdapter<ServicesModel> {
  @override
  final int typeId = 0;

  @override
  ServicesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServicesModel(
      id: (fields[0] as num).toInt(),
      serviceName: fields[1] as String,
      serviceUrl: fields[2] as String,
      dateAdd: fields[3] as DateTime,
      isEnable: fields[4] == null ? true : fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ServicesModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceName)
      ..writeByte(2)
      ..write(obj.serviceUrl)
      ..writeByte(3)
      ..write(obj.dateAdd)
      ..writeByte(4)
      ..write(obj.isEnable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServicesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
