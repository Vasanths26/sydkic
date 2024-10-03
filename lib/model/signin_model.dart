class LogInModel {
  String? status;
  User? user;
  Authorization? authorization;

  LogInModel({this.status, this.user, this.authorization});

  LogInModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    authorization = json['authorization'] != null
        ? Authorization.fromJson(json['authorization'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (authorization != null) {
      data['authorization'] = authorization!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? avatar;
  String? authkey;
  String? wallet;
  String? role;
  String? email;
  // String? phone;
  // String? address;
  // String? emailVerifiedAt;
  // int? status;
  // String? meta;
  // String? plan;
  // int? planId;
  // int? willExpire;
  // int? wlPlan;
  // int? wbPlan;
  // int? igPlan;
  // int? createdAt;
  // int? updatedAt;
  // int? googleId;

  User(
      {this.id,
        this.name,
        this.avatar,
        this.authkey,
        this.wallet,
        this.role,
        this.email,
        // this.phone,
        // this.address,
        // this.emailVerifiedAt,
        // this.status,
        // this.meta,
        // this.plan,
        // this.planId,
        // this.willExpire,
        // this.wlPlan,
        // this.wbPlan,
        // this.igPlan,
        // this.createdAt,
        // this.updatedAt,
        // this.googleId
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    authkey = json['authkey'];
    wallet = json['wallet'];
    role = json['role'];
    email = json['email'];
    // phone = json['phone'];
    // address = json['address'];
    // emailVerifiedAt = json['email_verified_at'];
    // status = json['status'];
    // meta = json['meta'];
    // plan = json['plan'];
    // planId = json['plan_id'];
    // willExpire = json['will_expire'];
    // wlPlan = json['wl_plan'];
    // wbPlan = json['wb_plan'];
    // igPlan = json['ig_plan'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // googleId = json['google_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['authkey'] = authkey;
    data['wallet'] = wallet;
    data['role'] = role;
    data['email'] = email;
    // data['phone'] = this.phone;
    // data['address'] = this.address;
    // data['email_verified_at'] = this.emailVerifiedAt;
    // data['status'] = this.status;
    // data['meta'] = this.meta;
    // data['plan'] = this.plan;
    // data['plan_id'] = this.planId;
    // data['will_expire'] = this.willExpire;
    // data['wl_plan'] = this.wlPlan;
    // data['wb_plan'] = this.wbPlan;
    // data['ig_plan'] = this.igPlan;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    // data['google_id'] = this.googleId;
    return data;
  }
}

class Authorization {
  String? token;
  String? type;

  Authorization({this.token, this.type});

  Authorization.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['type'] = type;
    return data;
  }
}
