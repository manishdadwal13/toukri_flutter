import 'package:toukri/models/LatLong.dart';

class Cart {
  bool isShow;
  String userName;
  LatLong position;
  List<LatLong> route;

  Cart(this.isShow, this.userName, this.position, this.route);

  static List<Cart> getData() {
    return [
      Cart(false, "Max", LatLong(30.722529, 76.790845), [
        LatLong(30.721672, 76.790005),
        LatLong(30.725318, 76.795918),
        LatLong(30.725041, 76.796390),
        LatLong(30.724211, 76.796959)
      ]),
      Cart(false, "Jennifer", LatLong(30.723073, 76.791693), [
        LatLong(30.722207, 76.790274),
        LatLong(30.720860, 76.791272),
        LatLong(30.719144, 76.792935),
        LatLong(30.720666, 76.795049)
      ]),
      Cart(false, "Smith", LatLong(30.723626, 76.792562), [
        LatLong(30.725881, 76.795991),
        LatLong(30.727034, 76.794843),
        LatLong(30.727901, 76.796785),
        LatLong(30.727145, 76.797590)
      ]),
    ];
  }
}
