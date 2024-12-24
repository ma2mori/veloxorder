import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_name.g.dart';

@HiveType(typeId: 12)
class CategoryName extends Equatable {
  @HiveField(0)
  final String value;

  CategoryName(this.value) {
    if (value.isEmpty) {
      throw ArgumentError('カテゴリー名は空にできません。');
    }
    if (value.length > 20) {
      throw ArgumentError('カテゴリー名は20文字以内でなければなりません。');
    }
  }

  @override
  List<Object?> get props => [value];
}
