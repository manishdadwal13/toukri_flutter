import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:toukri/app/apic/base_util.dart';
import 'package:toukri/app/apic/network_utl.dart';
import 'package:toukri/app/model/cart_detail_response.dart';
import 'package:toukri/app/model/cartdata.dart';
import 'package:toukri/app/model/cartresponse.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:toukri/app/screens/widgets/cart_detail_window.dart';
import 'package:toukri/models/cart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Set<Polyline> _polyline = {};

  // List<Cart> _carts = <Cart>[];
  List<CartData> cartList = List();
  List<Marker> _markers = <Marker>[];
  double _radiusValue = 1000.0;
  int _currentIndex;
  bool _isRadiusSelected = true;
  List<LatLng> _latLongPoly = [];
  GoogleMapController _controller;
  int selectedIndex;
  BitmapDescriptor customIcon;
  BitmapDescriptor startPointIcon;
  BitmapDescriptor endPointIcon;
  BitmapDescriptor stopIcon;
  bool isShowCartWindow = false;

  CartDetailData cartDetailData;

  //List<CartDetailData> cartDetailData = List();
  List<CartRoutes> routeList = List();

  static CameraPosition _kGooglePlex=CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 16,
  );
  static CameraPosition _kGoogleD = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 16,
  );

  double lat;
  double lng;


  Socket socket;

  final Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;


  bool isLocationOk = true;

  @override
  void initState() {
    super.initState();

    // MARK: add polyline
    //  var l= _determinePosition();


    getl();
  }


  Future<void> connectScoket() async {
    try {
      // Configure socket transports must be sepecified
      socket = await io('http://13.232.172.117:3000', <String, dynamic>{
        //  socket = await   io('https://socket.io/demos/chat/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      // Connect to websocket
      socket.connect().onConnect((data) {
        print("data----------------${data}");

        // seneUpdateLocation(socket);


            socket.on("cart-locations", ((ddd) {

              print("data----------------${ddd}");
        }));
      });
      // socket.emit("/", "hvv");

      socket.onConnectError((data) {
        print("ee----------------${data}");
      });
      // Handle socket events

    } catch (e) {
      print("----------------${e.toString()}");
    }
  }


  void addMarker() {
    if (customIcon != null &&
        startPointIcon != null &&
        endPointIcon != null &&
        stopIcon != null) {
      setState(() {
        for (var i = 0; i < cartList.length; i++) {
          CartData cart = cartList[i];
          _markers.add(Marker(
            markerId: MarkerId('markerID$i'),
            onTap: () {
              getcartDetail(cart, i);
              debugPrint("---------------------------clickddd${cart.id}");

              //getcartDetail(cart);

              setState(() {
                // cart.isShow = !cart.isShow;
                _currentIndex = i;
                _onMarkerTapped(i);

                // addMarker();
              });
            },
            icon: customIcon,
            position: LatLng(cart.lat, cart.lng),
          ));
        }
      });
    }
  }

  void _configureMarkers() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(40, 40)), 'assets/cart.png')
        .then((onValue) {
      customIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(22, 22)), 'assets/start_point.png')
        .then((onValue) {
      startPointIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(22, 22)), 'assets/end_point.png')
        .then((onValue) {
      endPointIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(22, 22)), 'assets/stop.png')
        .then((onValue) {
      stopIcon = onValue;
      addMarker();
    });
  }

  void _createPolylineAndSetMarker(List<CartRoutes> routeList) {
    //remove pervious marker
    if (_markers.length > routeList.length) {
      _markers.removeRange(_markers.length - 1, _markers.length);
    }
    // clear the polyline lat and long
    if (_latLongPoly.length > 0) {
      _latLongPoly = [];
    }

    for (var j = 0; j < routeList.length; j++) {
      int _lastIndex = routeList.length - 1;

      LatLng k = LatLng(routeList[j].lat, routeList[j].lng);
      _latLongPoly.add(k);

      if (j == 0) {
        // set start route marker
        _markers.add(Marker(
          markerId: MarkerId('markerID-start'),
          icon: startPointIcon,
          position: LatLng(routeList[j].lat, routeList[j].lng),
        ));
      } else if (j == _lastIndex) {
        // set end route marker
        _markers.add(Marker(
          markerId: MarkerId('markerID-end'),
          icon: endPointIcon,
          position: LatLng(routeList[j].lat, routeList[j].lng),
        ));
      } else {
        // set route stop marker
        _markers.add(Marker(
          markerId: MarkerId('markerID-stop$j'),
          icon: stopIcon,
          position: LatLng(routeList[j].lat, routeList[j].lng),
        ));
      }
    }
    //clear polyline if already there
    if (_polyline.length > 0) {
      _polyline.clear();
    }

    var polyline = Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        points: _latLongPoly,
        width: 5,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap);
    _polyline.add(polyline);
  }

// make marker highlighed when tabbed
  void _onMarkerTapped(int index) {
    final Marker tappedMarker = _markers[index];
    if (tappedMarker != null) {
      setState(() {
        cartList.forEach((cart) {
          if (cart == cartList[_currentIndex]) {
            cart.isShow = true;
          } else {
            cart.isShow = false;
          }
        });
        if (selectedIndex != null) {
          final Marker resetOld =
              _markers[selectedIndex].copyWith(iconParam: customIcon);
          _markers[selectedIndex] = resetOld;
        }
        selectedIndex = index;

        BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(22, 22)),
                'assets/cart-selected.png')
            .then((onValue) {
          final Marker newMarker = tappedMarker.copyWith(
            iconParam: onValue,
          );
          _markers[index] = newMarker;
        });
      });
    }
  }

  void tabbedOnSearch() {
    getCartList(_radiusValue);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: isLocationOk == true
            ? Stack(alignment: Alignment.center, children: [
                GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    polylines: _polyline,
                    markers: Set<Marker>.from(_markers),
                    onMapCreated: _onMapCreated),
                Positioned(
                    top: 64,
                    left: 20,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        height: 50,
                        width: MediaQuery.of(context).size.width - 40,
                        child: TextField(
                          maxLines: 1,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintMaxLines: 1,
                            hintStyle: TextStyle(fontSize: 16),
                            hintText: "Search vegetables",
                            suffixIcon: Icon(Icons.search, color: Colors.black),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                top: 14, bottom: 12, left: 30, right: 12),
                          ),
                        ))),
                _bottomSettingsWidget(width, height),
                if (_currentIndex != null)
                  Container(
                      child: cartList[_currentIndex].isShow
                          ? Positioned(
                              bottom: 0,
                              child: CartDetailWindow(
                                  cart: cartList[_currentIndex],
                                  onSwipeDown: () {
                                    _onCloseCartDetailWindow();
                                  }))
                          : null),
              ])
            : Container(child: Text("No Data")));
  }

  //MARK: - Bottom Settings Widget
  Widget _bottomSettingsWidget(double width, double height) {
    return Positioned(
        bottom: 0,
        child: Container(
          width: width,
          height: width * 0.23,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(4, -3), // changes position of shadow
              ),
            ],
          ),
          child: Center(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    elevation: 0,
                    color: _isRadiusSelected ? Colors.green : Colors.white,
                    onPressed: () async {
                      setState(() {
                        _isRadiusSelected = true;
                      });
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(
                              builder: (context, state) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    elevation: 1.0,
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      height: width * 0.8,
                                      width: width * 0.8,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    child: Icon(
                                                        Icons.cancel_outlined)),
                                              ),
                                              Text(
                                                "Select Radius",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SliderTheme(
                                                data: SliderTheme.of(context)
                                                    .copyWith(
                                                        trackHeight: 12,
                                                        overlayColor:
                                                            Colors.green,
                                                        valueIndicatorColor:
                                                            Colors.green),
                                                child: Slider(
                                                    activeColor: Colors.green,
                                                    inactiveColor:
                                                        Colors.grey[200],
                                                    value: _radiusValue,
                                                    divisions: 1000,
                                                    onChanged: (value) {
                                                      print("$value");
                                                      state(() {
                                                        _radiusValue = value;
                                                      });
                                                    },
                                                    min: 0,
                                                    max: 1000,
                                                    label: _radiusValue
                                                            .round()
                                                            .toString() +
                                                        "m"),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 26),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("0m"),
                                                    Text("1000m"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: width * 0.7,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              elevation: 0,
                                              color: Colors.green,
                                              onPressed: tabbedOnSearch,
                                              child: Text("Search",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.radio_button_off_sharp,
                          color:
                              _isRadiusSelected ? Colors.white : Colors.black,
                        ),
                        SizedBox(width: 1),
                        Expanded(
                            child: Text(
                          "Radius",
                          style: TextStyle(
                              color: _isRadiusSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 13),
                        )),
                        SizedBox(width: 1),
                        if (_radiusValue > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Text(
                              _radiusValue.round().toString() + "m",
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    elevation: 0,
                    color: _isRadiusSelected ? Colors.white : Colors.green,
                    onPressed: () {
                      setState(() {
                        _isRadiusSelected = false;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.settings,
                            color: _isRadiusSelected
                                ? Colors.black
                                : Colors.white),
                        SizedBox(width: 2),
                        Text("Settings",
                            style: TextStyle(
                                color: _isRadiusSelected
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ));
  }

//MARK: Close the window
  void _onCloseCartDetailWindow() {
    setState(() {
      //remove pervious route markers
      // _markers.removeRange(3, _markers.length);
      // clear the polyline from pervious route
      _polyline.clear();
      //hide the detail window
      cartList[_currentIndex].isShow = false;
      //reset the marker state
      if (selectedIndex != null) {
        final Marker resetOld =
            _markers[selectedIndex].copyWith(iconParam: customIcon);
        _markers[selectedIndex] = resetOld;
      }
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    // set the polyline as
    _controller = controllerParam;
    if (cartList.length > 0 && _currentIndex != null) {
      setState(() {
        var polyline = Polyline(
            polylineId: PolylineId('line1'),
            visible: true,
            //latlng is List<LatLng>

            points: _latLongPoly,
            width: 5,
            color: Colors.blue,
            startCap: Cap.squareCap,
            endCap: Cap.squareCap);
        _polyline.add(polyline);
      });
    }
  }

  void getCartList(double radiusValue) {
    NetworkUtil networkUtil = new NetworkUtil();

    String url = baseUrl +
        gtCartList +
        "?lat=${lat.toString()}&lng=${lng.toString()}&radius=$radiusValue";

    networkUtil.get(url, headers: {
      "x-api-key": "63oVaqpOIfjsnbgSQmHNCylvHfD7GB0ag9m3hApeibul9Lgd6d"
    }).then((dynamic onValue) {
      var res = CartResponse.fromJson(onValue);

      if (res.success == true) {
        setState(() {
          cartList = res.data;
          _configureMarkers();
          connectScoket();
        });
      }
    });
  }

 void getl() async {

    _serviceEnabled = await location.serviceEnabled();
    print("-------$_serviceEnabled");
    if (!_serviceEnabled) {

      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    } else {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
      if (_locationData != null) {
        setState(() {
          lat = _locationData.latitude;
          lng = _locationData.longitude;
        });
        animateCameraPosition(lat, lng);

        _configureMarkers();
        getCartList(_radiusValue);
        print("------------${_locationData.latitude}");
      }
    }
  }

  void getcartDetail(CartData cart, int i) {
    NetworkUtil networkUtil = new NetworkUtil();

    String url = baseUrl + cartDetail + "?id=${cart.id}";

    networkUtil.get(url, headers: {
      "x-api-key": "63oVaqpOIfjsnbgSQmHNCylvHfD7GB0ag9m3hApeibul9Lgd6d"
    }).then((dynamic onValue) {
      var res = CartDetail.fromJson(onValue);

      if (res.success == true) {
        setState(() {
          cartDetailData = res.data;
          routeList = cartDetailData.cartRoutes;
          cartList[i].cartDetailData = res.data;
          _createPolylineAndSetMarker(routeList);
        });
      }
    });
  }
  void animateCameraPosition(double lat, double lang) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lang),
          zoom: 14,
        ),
      ),
    );
  }
}
