// class OrderTransactionHistoryModel {
//   bool? status;
//   Wallet? wallet;
//   List<Transactions>? transactions;
//   String? transactionCount;
//   String? transactionEarningSum;
//   String? transactionLossSum;
//   String? minAmount;
//
//   OrderTransactionHistoryModel({this.status, this.wallet, this.transactions,this.minAmount});
//
//   OrderTransactionHistoryModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
//     if (json['transactions'] != null) {
//       transactions = <Transactions>[];
//       json['transactions'].forEach((v) {
//         transactions!.add(Transactions.fromJson(v));
//       });
//     }
//     transactionCount = json['totalTransaction']?.toString();
//     transactionEarningSum = json['earningAmount']?.toString();
//     transactionLossSum = json['outgoing']?.toString();
//     minAmount = json['minAmount']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (wallet != null) {
//       data['wallet'] = wallet!.toJson();
//     }
//     if (transactions != null) {
//       data['transactions'] = transactions!.map((v) => v.toJson()).toList();
//     }
//     data['totalTransaction'] = transactionCount;
//     data['earningAmount'] = transactionEarningSum;
//     data['outgoing'] = transactionLossSum;
//     data['minAmount'] = minAmount;
//     return data;
//   }
// }
//
// class Wallet {
//   String? id;
//   String? vendorId;
//   String? type;
//   String? bankname;
//   String? acHolder;
//   String? acNo;
//   String? acType;
//   String? ifsc;
//   String? currentBalance;
//   String? total;
//   String? walletBalance;
//   String? primaryStatus;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//
//   Wallet(
//       {this.id,
//         this.vendorId,
//         this.type,
//         this.bankname,
//         this.acHolder,
//         this.acNo,
//         this.acType,
//         this.ifsc,
//         this.currentBalance,
//         this.walletBalance,
//         this.total,
//         this.primaryStatus,
//         this.status,
//         this.createdAt,
//         this.updatedAt});
//
//   Wallet.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     vendorId = json['vendor_id']?.toString();
//     type = json['type']?.toString();
//     bankname = json['bankname']?.toString();
//     acHolder = json['ac_holder']?.toString();
//     acNo = json['ac_no']?.toString();
//     acType = json['ac_type']?.toString();
//     ifsc = json['ifsc']?.toString();
//     currentBalance = json['current_balance']?.toString();
//     walletBalance = json['wallet_balance']?.toString();
//     total = json['total']?.toString();
//     primaryStatus = json['primary_status']?.toString();
//     status = json['status']?.toString();
//     createdAt = json['created_at']?.toString();
//     updatedAt = json['updated_at']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['vendor_id'] = vendorId;
//     data['type'] = type;
//     data['bankname'] = bankname;
//     data['ac_holder'] = acHolder;
//     data['ac_no'] = acNo;
//     data['ac_type'] = acType;
//     data['ifsc'] = ifsc;
//     data['current_balance'] = currentBalance;
//     data['wallet_balance'] = walletBalance;
//     data['primary_status'] = primaryStatus;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
//
// class Transactions {
//   String? id;
//   String? userId;
//   String? productName;
//   String? transactionDate;
//   String? vendorId;
//   String? type;
//   String? amount;
//   String? transactionType;
//   String? descp;
//   String? currentBalance;
//   String? createdAt;
//   String? updatedAt;
//   User? user;
//
//   Transactions(
//       {this.id,
//         this.userId,
//         this.productName,
//         this.transactionDate,
//         this.vendorId,
//         this.type,
//         this.amount,
//         this.transactionType,
//         this.descp,
//         this.currentBalance,
//         this.createdAt,
//         this.updatedAt,
//         this.user});
//
//   Transactions.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     userId = json['user_id']?.toString();
//     productName = json['product_name']?.toString();
//     transactionDate = json['transaction_date']?.toString();
//     vendorId = json['vendor_id']?.toString();
//     type = json['type']?.toString();
//     amount = json['amount']?.toString();
//     transactionType = json['transaction_type']?.toString();
//     descp = json['descp']?.toString();
//     currentBalance = json['current_balance']?.toString();
//     createdAt = json['created_at']?.toString();
//     updatedAt = json['updated_at']?.toString();
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['product_name'] = productName;
//     data['transaction_date'] = transactionDate;
//     data['vendor_id'] = vendorId;
//     data['type'] = type;
//     data['amount'] = amount;
//     data['transaction_type'] = transactionType;
//     data['descp'] = descp;
//     data['current_balance'] = currentBalance;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (user != null) {
//       data['user'] = user!.toJson();
//     }
//     return data;
//   }
// }

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? imageUrl;

  User({this.id, this.firstName, this.lastName,this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image_url'] = imageUrl;
    return data;
  }
}

class OrderTransactionHistoryModel {
  bool? status;
  Wallet? wallet;
  List<Transactions>? transactions;
  String? totalTransacton;
  String? earningAmount;
  String? outgoing;
  String? minAmount;

  OrderTransactionHistoryModel(
      {this.status,
        this.wallet,
        this.transactions,
        this.totalTransacton,
        this.earningAmount,
        this.outgoing,
        this.minAmount});

  OrderTransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
    totalTransacton = json['totalTransacton']?.toString();
    earningAmount = json['earningAmount']?.toString();
    outgoing = json['outgoing']?.toString();
    minAmount = json['minAmount']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    data['totalTransacton'] = totalTransacton;
    data['earningAmount'] = earningAmount;
    data['outgoing'] = outgoing;
    data['minAmount'] = minAmount;
    return data;
  }
}

class Wallet {
  String? id;
  String? vendorId;
  String? type;
  String? walletBalance;
  String? currentBalance;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;

  Wallet(
      {this.id,
        this.vendorId,
        this.type,
        this.walletBalance,
        this.currentBalance,
        this.total,
        this.status,
        this.createdAt,
        this.updatedAt});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    vendorId = json['vendor_id']?.toString();
    type = json['type']?.toString();
    walletBalance = json['wallet_balance']?.toString();
    currentBalance = json['current_balance']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['type'] = type;
    data['wallet_balance'] = walletBalance;
    data['current_balance'] = currentBalance;
    data['total'] = total;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Transactions {
  String? id;
  String? userId;
  String? productName;
  String? transactionDate;
  String? vendorId;
  String? type;
  String? amount;
  String? transactionType;
  String? descp;
  String? currentBalance;
  String? createdAt;
  String? updatedAt;
  User? user;

  Transactions(
      {this.id,
        this.userId,
        this.productName,
        this.transactionDate,
        this.vendorId,
        this.type,
        this.amount,
        this.transactionType,
        this.descp,
        this.currentBalance,
        this.createdAt,
        this.updatedAt,
        this.user});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userId = json['user_id']?.toString();
    productName = json['product_name']?.toString();
    transactionDate = json['transaction_date']?.toString();
    vendorId = json['vendor_id']?.toString();
    type = json['type']?.toString();
    amount = json['amount']?.toString();
    transactionType = json['transaction_type']?.toString();
    descp = json['descp']?.toString();
    currentBalance = json['current_balance']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['product_name'] = productName;
    data['transaction_date'] = transactionDate;
    data['vendor_id'] = vendorId;
    data['type'] = type;
    data['amount'] = amount;
    data['transaction_type'] = transactionType;
    data['descp'] = descp;
    data['current_balance'] = currentBalance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
