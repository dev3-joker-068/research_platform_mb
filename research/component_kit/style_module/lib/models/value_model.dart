import 'package:json_annotation/json_annotation.dart';

part 'value_model.g.dart';

@JsonSerializable()
class ValueModel {
  final String value;

  const ValueModel({
   required this.value,
  });

  factory ValueModel.fromJson(Map<String, dynamic> json) => _$ValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$ValueModelToJson(this);

  ValueModel toEntity() => ValueModel(value: value);
}
