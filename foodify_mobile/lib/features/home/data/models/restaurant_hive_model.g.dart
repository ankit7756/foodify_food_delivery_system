// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantHiveModelAdapter extends TypeAdapter<RestaurantHiveModel> {
  @override
  final int typeId = 1;

  @override
  RestaurantHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      description: fields[3] as String,
      rating: fields[4] as double,
      deliveryTime: fields[5] as String,
      deliveryFee: fields[6] as double,
      categories: (fields[7] as List).cast<String>(),
      isOpen: fields[8] as bool,
      address: fields[9] as String,
      phone: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.deliveryTime)
      ..writeByte(6)
      ..write(obj.deliveryFee)
      ..writeByte(7)
      ..write(obj.categories)
      ..writeByte(8)
      ..write(obj.isOpen)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
