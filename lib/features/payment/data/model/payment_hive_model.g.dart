// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentHiveModelAdapter extends TypeAdapter<PaymentHiveModel> {
  @override
  final int typeId = 6;

  @override
  PaymentHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentHiveModel(
      id: fields[0] as String?,
      food: fields[1] as String,
      quantity: fields[2] as int,
      totalPrice: fields[3] as double,
      paymentMode: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.food)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.totalPrice)
      ..writeByte(4)
      ..write(obj.paymentMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
