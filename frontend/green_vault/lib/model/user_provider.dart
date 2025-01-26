import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? imageUrl;
  String? authPerson;
  String? conNum;
  String? email;
  String? address;

  void setUserData({
    required String imageUrl,
    required String authPerson,
    required String conNum,
    required String email,
    required String address,
  }) {
    this.imageUrl = imageUrl;
    this.authPerson = authPerson;
    this.conNum = conNum;
    this.email = email;
    this.address = address;
    notifyListeners();
  }
}

class TotalCredits with ChangeNotifier {
  String? totalCredits;

  void getTotalCredits({
    required String totalCredits,
  }) {
    this.totalCredits = totalCredits;
    notifyListeners();
  }
}
