import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'voucher_number.g.dart';

@HiveType(typeId: 11)
class VoucherNumber extends Equatable {
  @HiveField(0)
  final String value;

  VoucherNumber(this.value) {
    if (value.isEmpty) {
      throw ArgumentError('引換券番号は空であってはなりません。');
    }
  }

  @override
  List<Object?> get props => [value];
}
