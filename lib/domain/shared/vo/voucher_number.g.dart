// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_number.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoucherNumberAdapter extends TypeAdapter<VoucherNumber> {
  @override
  final int typeId = 11;

  @override
  VoucherNumber read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoucherNumber(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VoucherNumber obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoucherNumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
