import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'amount.g.dart';

@HiveType(typeId: 10)
class Amount extends Equatable {
  @HiveField(0)
  final int value;

  Amount(this.value) {
    if (value < 0) {
      throw ArgumentError('金額は0以上でなければなりません。');
    }
  }

  Amount operator +(Amount other) => Amount(this.value + other.value);

  Amount operator -(Amount other) => Amount(this.value - other.value);

  @override
  List<Object?> get props => [value];
}
