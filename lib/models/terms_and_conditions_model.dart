import 'dart:convert';

TermsAndConditionsModel termsAndConditionModelFromJson(String str) =>
    TermsAndConditionsModel.fromJson(json.decode(str));

String termsAndConditionModelToJson(TermsAndConditionsModel data) =>
    json.encode(data.toJson());

class TermsAndConditionsModel {
  final List<Detail> details;

  TermsAndConditionsModel({
    required this.details,
  });

  factory TermsAndConditionsModel.fromJson(Map<String, dynamic>? json) =>
      TermsAndConditionsModel(
        details:
            List<Detail>.from(json?["details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  int id;
  String value;
  DateTime createdAt;
  DateTime updatedAt;

  Detail({
    required this.id,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Detail.fromJson(Map<String, dynamic>? json) => Detail(
        id: json?["id"],
        value: json?["value"],
        createdAt: DateTime.parse(json?["createdAt"]),
        updatedAt: DateTime.parse(json?["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
