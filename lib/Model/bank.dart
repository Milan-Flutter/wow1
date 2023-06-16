class bank {
  int? success;
  String? message;
  Data? data;

  bank({this.success, this.message, this.data});

  bank.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Bank>? bank;

  Data({this.bank});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bank'] != null) {
      bank = <Bank>[];
      json['bank'].forEach((v) {
        bank!.add(new Bank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bank != null) {
      data['bank'] = this.bank!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bank {
  String? id;
  String? userId;
  String? name;
  String? accNumber;
  String? ifsc;
  String? bankName;

  Bank(
      {this.id,
        this.userId,
        this.name,
        this.accNumber,
        this.ifsc,
        this.bankName});

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    accNumber = json['acc_number'];
    ifsc = json['ifsc'];
    bankName = json['bank_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['acc_number'] = this.accNumber;
    data['ifsc'] = this.ifsc;
    data['bank_name'] = this.bankName;
    return data;
  }
}