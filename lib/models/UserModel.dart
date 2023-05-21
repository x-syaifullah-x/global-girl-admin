import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simpleworld/utils/ModelKeys.dart';

class UserModel {
  String? id;
  String? username;
  String? email;
  String? photoUrl;
  String? loginType;
  DateTime? timestamp;
  bool? isAdmin;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.loginType,
    this.timestamp,
    this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[CommonKeys.id],
      username: json[UserKeys.username],
      email: json[UserKeys.email],
      photoUrl: json[UserKeys.photoUrl],
      loginType: json[UserKeys.loginType],
      isAdmin: json[UserKeys.isAdmin],
      timestamp: json[CommonKeys.updatedAt] != null
          ? (json[CommonKeys.updatedAt] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[UserKeys.username] = this.username;
    data[UserKeys.email] = this.email;
    data[UserKeys.photoUrl] = this.photoUrl;
    data[UserKeys.loginType] = this.loginType;
    data[CommonKeys.updatedAt] = this.timestamp;
    data[UserKeys.isAdmin] = this.isAdmin;
    return data;
  }
}
