// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedbackHiveModelAdapter extends TypeAdapter<FeedbackHiveModel> {
  @override
  final int typeId = 8;

  @override
  FeedbackHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedbackHiveModel(
      feedbackId: fields[0] as String?,
      userId: fields[1] as String,
      productId: fields[2] as String,
      rating: fields[3] as int,
      comment: fields[4] as String,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FeedbackHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.feedbackId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.comment)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
