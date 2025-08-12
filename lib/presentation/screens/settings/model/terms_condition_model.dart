class TermsConditionsModel {
  final String? message;
  final Data? data;

  TermsConditionsModel({
    this.message,
    this.data,
  });

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) =>
      TermsConditionsModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final String? text;

  Data({
    this.text,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        text: json["text"],
      );
}
