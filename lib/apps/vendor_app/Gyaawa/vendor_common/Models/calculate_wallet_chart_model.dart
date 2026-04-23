class CalculateWalletChartModel {
  List<String>? labels;
  List<double>? income;
  List<double>? outgoing;

  CalculateWalletChartModel({this.labels, this.income, this.outgoing});

  CalculateWalletChartModel.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    income = json['income'].cast<double>();
    outgoing = json['outgoing'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['labels'] = labels;
    data['income'] = income;
    data['outgoing'] = outgoing;
    return data;
  }
}
