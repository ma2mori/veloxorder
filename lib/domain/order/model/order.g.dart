// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 3;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: fields[0] as String?,
      voucherNumber: fields[1] as VoucherNumber,
      dateTime: fields[2] as DateTime,
      items: (fields[3] as List).cast<OrderItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.voucherNumber)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderItemAdapter extends TypeAdapter<OrderItem> {
  @override
  final int typeId = 4;

  @override
  OrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItem(
      menuItemId: fields[0] as String,
      quantity: fields[1] as int,
      status: fields[2] as OrderItemStatus,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.menuItemId)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderItemStatusAdapter extends TypeAdapter<OrderItemStatus> {
  @override
  final int typeId = 5;

  @override
  OrderItemStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderItemStatus.pending;
      case 1:
        return OrderItemStatus.prepared;
      case 2:
        return OrderItemStatus.delivered;
      default:
        return OrderItemStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, OrderItemStatus obj) {
    switch (obj) {
      case OrderItemStatus.pending:
        writer.writeByte(0);
        break;
      case OrderItemStatus.prepared:
        writer.writeByte(1);
        break;
      case OrderItemStatus.delivered:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
