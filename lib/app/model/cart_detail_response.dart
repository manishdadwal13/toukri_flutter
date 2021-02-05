class CartDetail {
  bool success;
  String message;
  CartDetailData data;

  CartDetail({this.success, this.message, this.data});

  CartDetail.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new CartDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CartDetailData {
  Cart cart;
  List<CartRoutes> cartRoutes;
  List<CartItems> cartItems;

  CartDetailData({this.cart, this.cartRoutes, this.cartItems});

  CartDetailData.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    if (json['cartRoutes'] != null) {
      cartRoutes = new List<CartRoutes>();
      json['cartRoutes'].forEach((v) {
        cartRoutes.add(new CartRoutes.fromJson(v));
      });
    }
    if (json['cartItems'] != null) {
      cartItems = new List<CartItems>();
      json['cartItems'].forEach((v) {
        cartItems.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cart != null) {
      data['cart'] = this.cart.toJson();
    }
    if (this.cartRoutes != null) {
      data['cartRoutes'] = this.cartRoutes.map((v) => v.toJson()).toList();
    }
    if (this.cartItems != null) {
      data['cartItems'] = this.cartItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cart {
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

  Cart(
      {this.id,
        this.cartDriver,
        this.cartName,
        this.contactNo,
        this.lat,
        this.documentNo,
        this.documentId,
        this.createdAt,
        this.lng,
        this.status});

  Cart.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class CartRoutes {
  int id;
  int cartId;
  double lat;
  double lng;
  String address;

  CartRoutes({this.id, this.cartId, this.lat, this.lng, this.address});

  CartRoutes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cartId'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cartId'] = this.cartId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    return data;
  }
}

class CartItems {
  int id;
  int cartId;
  int itemId;
  String itemQty;
  String iconUrl;

  CartItems({this.id, this.cartId, this.itemId, this.itemQty, this.iconUrl});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cartId'];
    itemId = json['itemId'];
    itemQty = json['itemQty'];
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cartId'] = this.cartId;
    data['itemId'] = this.itemId;
    data['itemQty'] = this.itemQty;
    data['iconUrl'] = this.iconUrl;
    return data;
  }
}