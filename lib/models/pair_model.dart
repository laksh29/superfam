import 'package:superfam_1/models/pair_field_model.dart';

class PairModel {
  final int? id;
  final String? key;
  final String? value;
  final String? createdTime;

  PairModel({
    this.id,
    required this.key,
    required this.value,
    this.createdTime,
  });
  factory PairModel.fromJson(Map<String, dynamic> json) {
    return PairModel(
      id: json['_id'] as int?,
      key: json['key'] as String?,
      value: json['value'] as String?,
      createdTime: json['created_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PairFields.id: id,
      PairFields.key: key,
      PairFields.value: value,
      PairFields.createdTime: createdTime,
    };
  }

  //
  PairModel copy({
    int? id,
    String? key,
    String? value,
    String? createdTime,
  }) {
    return PairModel(
      id: id,
      key: key,
      value: value,
      createdTime: createdTime,
    );
  }
}
