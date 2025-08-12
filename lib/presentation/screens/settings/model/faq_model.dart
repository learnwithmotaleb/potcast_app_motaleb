class FaqModel {
  final String? message;
  final List<FaqData>? data;

  FaqModel({
    this.message,
    this.data,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<FaqData>.from(json["data"]!.map((x) => FaqData.fromJson(x))),
      );
}

class FaqData {
  final String? id;
  final String? question;
  final String? answer;
  final num? v;

  FaqData({
    this.id,
    this.question,
    this.answer,
    this.v,
  });

  factory FaqData.fromJson(Map<String, dynamic> json) => FaqData(
        id: json["_id"],
        question: json["question"],
        answer: json["answer"],
        v: json["__v"],
      );
}
