class CalculateChartModel {
  List<String>? labels;
  List<double>? upperCurve;
  List<int>? lowerCurve;

  CalculateChartModel({this.labels, this.upperCurve, this.lowerCurve});

  CalculateChartModel.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    upperCurve = json['upperCurve'].cast<double>();
    lowerCurve = json['lowerCurve'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labels'] = labels;
    data['upperCurve'] = upperCurve;
    data['lowerCurve'] = lowerCurve;
    return data;
  }
}
