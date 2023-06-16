class AllData {
  List<Data>? data;
  String? status;
  String? message;

  AllData({this.data, this.status, this.message});

  AllData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? id;
  String? googleId;
  String? name;
  String? email;
  String? password;
  String? photoUrl;
  String? mobile;
  String? ageVerification;
  String? walletCoin;
  String? gender;
  String? totalPost;
  String? follower;
  String? following;
  String? type;
  String? user_status;
  String? host_status;
  String?  f_id;

  Data(
      {this.id,
        this.googleId,
        this.name,
        this.email,
        this.password,
        this.photoUrl,
        this.mobile,
        this.ageVerification,
        this.walletCoin,
        this.gender,
        this.totalPost,
        this.follower,
        this.following,
        this.type,
        this.user_status,
        this.host_status,
        this.f_id,

      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    googleId = json['google_Id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    photoUrl = json['photo_url'];
    mobile = json['mobile'];
    ageVerification = json['age_verification'];
    walletCoin = json['wallet_coin'];
    gender = json['gender'];
    totalPost = json['total_post'];
    follower = json['follower'];
    following = json['following'];
    type = json['type'];
    user_status=json['user_status'];
    host_status=json['host_status'];
    f_id=json['f_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['google_Id'] = this.googleId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['photo_url'] = this.photoUrl;
    data['mobile'] = this.mobile;
    data['age_verification'] = this.ageVerification;
    data['wallet_coin'] = this.walletCoin;
    data['gender'] = this.gender;
    data['total_post'] = this.totalPost;
    data['follower'] = this.follower;
    data['following'] = this.following;
    data['type'] = this.type;
    data['user_status']=this.user_status;
    data['host_status']=this.host_status;
    data['f_id']=this.f_id;
    return data;
  }
}