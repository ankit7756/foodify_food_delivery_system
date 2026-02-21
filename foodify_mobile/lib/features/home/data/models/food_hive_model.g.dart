// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodHiveModelAdapter extends TypeAdapter<FoodHiveModel> {
  @override
  final int typeId = 2;

  @override
  FoodHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodHiveModel(
      id: fields[0] as String,
      restaurantId: fields[1] as String,
      name: fields[2] as String,
      image: fields[3] as String,
      description: fields[4] as String,
      price: fields[5] as double,
      category: fields[6] as String,
      rating: fields[7] as double,
      isAvailable: fields[8] as bool,
      isPopular: fields[9] as bool,
      restaurantName: fields[10] as String?,
      restaurantImage: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.restaurantId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.isAvailable)
      ..writeByte(9)
      ..write(obj.isPopular)
      ..writeByte(10)
      ..write(obj.restaurantName)
      ..writeByte(11)
      ..write(obj.restaurantImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
