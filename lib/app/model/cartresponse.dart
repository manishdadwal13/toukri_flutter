

import 'package:toukri/app/model/cartdata.dart';

class CartResponse {
  bool success;
  String message;
  List<CartData> data;

  CartResponse({this.success, this.message, this.data});

  CartResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CartData>();
      json['data'].forEach((v) {
        data.add(new CartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}