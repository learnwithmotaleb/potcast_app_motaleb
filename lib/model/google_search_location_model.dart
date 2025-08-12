class GoogleSearchLocationModel {
  final List<Prediction>? predictions;

  GoogleSearchLocationModel({
    this.predictions,
  });

  factory GoogleSearchLocationModel.fromJson(Map<String, dynamic> json) =>
      GoogleSearchLocationModel(
        predictions: json["predictions"] == null
            ? []
            : List<Prediction>.from(
                json["predictions"]!.map((x) => Prediction.fromJson(x))),
      );
}

class Prediction {
  final String? description;
  final String? placeId;
  final StructuredFormatting? structuredFormatting;

  Prediction({
    this.description,
    this.placeId,
    this.structuredFormatting,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        placeId: json["place_id"],
        structuredFormatting: json["structured_formatting"] == null
            ? null
            : StructuredFormatting.fromJson(json["structured_formatting"]),
      );
}

class StructuredFormatting {
  final String? mainText;

  StructuredFormatting({
    this.mainText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
      );
}
