// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHiveModelAdapter extends TypeAdapter<OrderHiveModel> {
  @override
  final int typeId = 3;

  @override
  OrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHiveModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      restaurantId: fields[2] as String,
      restaurantName: fields[3] as String,
      status: fields[4] as String,
      totalAmount: fields[5] as double,
      subtotal: fields[6] as double,
      deliveryFee: fields[7] as double,
      deliveryAddress: fields[8] as String,
      phone: fields[9] as String,
      paymentMethod: fields[10] as String,
      orderDate: fields[11] as DateTime,
      deliveryDate: fields[12] as DateTime?,
      itemsJson: (fields[13] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.restaurantId)
      ..writeByte(3)
      ..write(obj.restaurantName)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.totalAmount)
      ..writeByte(6)
      ..write(obj.subtotal)
      ..writeByte(7)
      ..write(obj.deliveryFee)
      ..writeByte(8)
      ..write(obj.deliveryAddress)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.orderDate)
      ..writeByte(12)
      ..write(obj.deliveryDate)
      ..writeByte(13)
      ..write(obj.itemsJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
