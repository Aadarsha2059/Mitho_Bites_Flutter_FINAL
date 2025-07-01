// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHiveModelAdapter extends TypeAdapter<OrderHiveModel> {
  @override
  final int typeId = 6;

  @override
  OrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHiveModel(
      id: fields[0] as String?,
      userId: fields[1] as String,
      items: (fields[2] as List).cast<dynamic>(),
      totalAmount: fields[3] as double,
      deliveryAddress: (fields[4] as Map?)?.cast<String, dynamic>(),
      deliveryInstructions: fields[5] as String,
      paymentMethod: fields[6] as String,
      paymentStatus: fields[7] as String,
      orderStatus: fields[8] as String,
      estimatedDeliveryTime: fields[9] as DateTime?,
      actualDeliveryTime: fields[10] as DateTime?,
      orderDate: fields[11] as DateTime?,
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
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
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.deliveryAddress)
      ..writeByte(5)
      ..write(obj.deliveryInstructions)
      ..writeByte(6)
      ..write(obj.paymentMethod)
      ..writeByte(7)
      ..write(obj.paymentStatus)
      ..writeByte(8)
      ..write(obj.orderStatus)
      ..writeByte(9)
      ..write(obj.estimatedDeliveryTime)
      ..writeByte(10)
      ..write(obj.actualDeliveryTime)
      ..writeByte(11)
      ..write(obj.orderDate)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
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
