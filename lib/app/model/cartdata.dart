import 'package:toukri/app/model/cart_detail_response.dart';

class CartData {
  int id;
  String cartDriver;
  String cartName;
  String contactNo;
  double lat;
  String documentNo;
  String documentId;
  String createdAt;
  double lng;
  int status;
  String distance;
  bool isShow;
  CartDetailData cartDetailData;



  CartData(
      {this.id,
        this.cartDriver,
        this.cartName,
        this.contactNo,
        this.lat,
        this.documentNo,
        this.documentId,
        this.createdAt,
        this.lng,
        this.status,
        this.distance});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartDriver = json['cartDriver'];
    cartName = json['cartName'];
    contactNo = json['contactNo'];
    lat = json['lat'];
    documentNo = json['documentNo'];
    documentId = json['documentId'];
    createdAt = json['createdAt'];
    lng = json['lng'];
    status = json['status'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cartDriver'] = this.cartDriver;
    data['cartName'] = this.cartName;
    data['contactNo'] = this.contactNo;
    data['lat'] = this.lat;
    data['documentNo'] = this.documentNo;
    data['documentId'] = this.documentId;
    data['createdAt'] = this.createdAt;
    data['lng'] = this.lng;
    data['status'] = this.status;
    data['distance'] = this.distance;
    return data;
  }
}
