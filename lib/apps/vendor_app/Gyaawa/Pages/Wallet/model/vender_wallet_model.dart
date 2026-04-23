class VendorWalletModel {
  bool? status;
  String? message;
  Card? stats;
  WalletOverview? walletOverview;
  List<RecentTransactions>? recentTransactions;
  PaymentMethods? paymentMethods;

  VendorWalletModel(
      {this.status,
        this.stats,
        this.message,
        this.walletOverview,
        this.recentTransactions,
        this.paymentMethods});

  VendorWalletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    stats = json['stats'] != null ? Card.fromJson(json['stats']) : null;
    walletOverview = json['wallet_overview'] != null
        ? WalletOverview.fromJson(json['wallet_overview'])
        : null;
    if (json['recent_transactions'] != null) {
      recentTransactions = <RecentTransactions>[];
      json['recent_transactions'].forEach((v) {
        recentTransactions!.add(RecentTransactions.fromJson(v));
      });
    }
    paymentMethods = json['payment_methods'] != null
        ? PaymentMethods.fromJson(json['payment_methods'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    if (walletOverview != null) {
      data['wallet_overview'] = walletOverview!.toJson();
    }
    if (recentTransactions != null) {
      data['recent_transactions'] =
          recentTransactions!.map((v) => v.toJson()).toList();
    }
    if (paymentMethods != null) {
      data['payment_methods'] = paymentMethods!.toJson();
    }
    return data;
  }
}

class Card {
  String? availableBalance;
  String? pendingEarnings;
  String? totalEarnings;
  String? lastPayout;
  String? monthlyPercentage;
  String? lastPayoutDate;

  Card(
      {this.availableBalance,
        this.pendingEarnings,
        this.totalEarnings,
        this.lastPayout,
        this.monthlyPercentage,
        this.lastPayoutDate,
      });

  Card.fromJson(Map<String, dynamic> json) {
    availableBalance = json['available_balance']?.toString();
    pendingEarnings = json['pending_earnings']?.toString();
    totalEarnings = json['total_earnings']?.toString();
    lastPayout = json['last_payout']?.toString();
    monthlyPercentage = json['monthly_percentage']?.toString();
    lastPayoutDate = json['last_payout_date']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['available_balance'] = availableBalance;
    data['pending_earnings'] = pendingEarnings;
    data['total_earnings'] = totalEarnings;
    data['last_payout'] = lastPayout;
    data['monthly_percentage'] = monthlyPercentage;
    return data;
  }
}

class WalletOverview {
  String? range;
  Stats? stats;
  List<Charts>? charts;

  WalletOverview({this.range, this.stats, this.charts});

  WalletOverview.fromJson(Map<String, dynamic> json) {
    range = json['range']?.toString();
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
    if (json['charts'] != null) {
      charts = <Charts>[];
      json['charts'].forEach((v) {
        charts!.add(Charts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['range'] = range;
    if (stats != null) {
      data['stats'] = stats!.toJson();
    }
    if (charts != null) {
      data['charts'] = charts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stats {
  String? totalEarnings;
  String? average;
  String? peekDay;
  String? growth;

  Stats({this.totalEarnings, this.average, this.peekDay, this.growth});

  Stats.fromJson(Map<String, dynamic> json) {
    totalEarnings = json['total_earnings']?.toString();
    average = json['average']?.toString();
    peekDay = json['peek_day']?.toString();
    growth = json['growth']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_earnings'] = totalEarnings;
    data['average'] = average;
    data['peek_day'] = peekDay;
    data['growth'] = growth;
    return data;
  }
}

class Charts {
  String? label;
  String? amount;

  Charts({this.label, this.amount});

  Charts.fromJson(Map<String, dynamic> json) {
    label = json['label']?.toString();
    amount = json['amount']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['amount'] = amount;
    return data;
  }
}

class RecentTransactions {
  String? id;
  String? transactionType;
  String? amount;
  String? descp;
  String? createdAt;

  RecentTransactions(
      {this.id, this.transactionType, this.amount, this.descp, this.createdAt});

  RecentTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    transactionType = json['transaction_type']?.toString();
    amount = json['amount']?.toString();
    descp = json['descp']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_type'] = transactionType;
    data['amount'] = amount;
    data['descp'] = descp;
    data['created_at'] = createdAt;
    return data;
  }
}

class PaymentMethods {
  List<Bank>? bank;
  List<MobileMoney>? mobileMoney;

  PaymentMethods({this.bank, this.mobileMoney});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    if (json['bank'] != null) {
      bank = <Bank>[];
      json['bank'].forEach((v) {
        bank!.add(Bank.fromJson(v));
      });
    }
    if (json['mobile_money'] != null) {
      mobileMoney = <MobileMoney>[];
      json['mobile_money'].forEach((v) {
        mobileMoney!.add(MobileMoney.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bank != null) {
      data['bank'] = bank!.map((v) => v.toJson()).toList();
    }
    if (mobileMoney != null) {
      data['mobile_money'] = mobileMoney!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bank {
  String? id;
  String? bankname;
  String? acNo;
  String? acType;

  Bank({this.id, this.bankname, this.acNo, this.acType});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    bankname = json['bankname']?.toString();
    acNo = json['ac_no']?.toString();
    acType = json['ac_type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bankname'] = bankname;
    data['ac_no'] = acNo;
    data['ac_type'] = acType;
    return data;
  }
}

class MobileMoney {
  String? id;
  String? provider;
  String? phoneCode;
  String? phone;
  String? acName;

  MobileMoney(
      {this.id, this.provider, this.phoneCode, this.phone, this.acName});

  MobileMoney.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    provider = json['provider']?.toString();
    phoneCode = json['phone_code']?.toString();
    phone = json['phone']?.toString();
    acName = json['ac_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider'] = provider;
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['ac_name'] = acName;
    return data;
  }
}
