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
  int userId;
  int id;
  String? title;
  String? body;

  Detail({
    required this.userId,
    required this.id,
    this.title,
    this.body,
  });

  factory Detail.fromJson(Map<String, dynamic>? json) => Detail(
        userId: json?['userId'],
        id: json?['id'],
        title: json?['title'],
        body: json?['body'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}
