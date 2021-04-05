class CartPosition {
  double lat;
  double lng;
  int id;
  CartPosition({this.lat, this.lng, this.id});
  CartPosition.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    id = json['id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['id'] = this.id;
    return data;
  }
}
