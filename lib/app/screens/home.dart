import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toukri/app/apicall/baseUtil.dart';
import 'package:toukri/app/apicall/network_util.dart';
import 'package:toukri/app/screens/widgets/cart_detail_window.dart';
import 'package:toukri/models/cart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Set<Polyline> _polyline = {};
  List<Cart> _carts = <Cart>[];
  List<Marker> _markers = <Marker>[];
  double _radiusValue = 0.0;
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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.725603, 76.795936),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();

    // MARK: add polyline

    setState(() {
      _carts = Cart.getData();
    });

    getCartList();
   // getcartDetail();
    _configureMarkers();
  }

  void addMarker() {
    if (customIcon != null &&
        startPointIcon != null &&
        endPointIcon != null &&
        stopIcon != null) {
      setState(() {
        for (var i = 0; i < _carts.length; i++) {
          Cart cart = _carts[i];
          _markers.add(Marker(
            markerId: MarkerId('markerID$i'),
            onTap: () {
              setState(() {
                // cart.isShow = !cart.isShow;
                _currentIndex = i;
                _onMarkerTapped(i);
                _createPolylineAndSetMarker(cart);

                // addMarker();
              });
            },
            icon: customIcon,
            position: LatLng(cart.position.latitude, cart.position.longitude),
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

  void _createPolylineAndSetMarker(Cart cart) {
    //remove pervious marker
    if (_markers.length > 4) {
      _markers.removeRange(3, _markers.length);
    }
    // clear the polyline lat and long
    if (_latLongPoly.length > 0) {
      _latLongPoly = [];
    }
    for (var j = 0; j < cart.route.length; j++) {
      int _lastIndex = cart.route.length - 1;

      LatLng k = LatLng(cart.route[j].latitude, cart.route[j].longitude);
      _latLongPoly.add(k);

      if (j == 0) {
        // set start route marker
        _markers.add(Marker(
          markerId: MarkerId('markerID-start'),
          icon: startPointIcon,
          position: LatLng(cart.route[j].latitude, cart.route[j].longitude),
        ));
      } else if (j == _lastIndex) {
         // set end route marker
        _markers.add(Marker(
          markerId: MarkerId('markerID-end'),
          icon: endPointIcon,
          position: LatLng(cart.route[j].latitude, cart.route[j].longitude),
        ));
      } else {
         // set route stop marker
        _markers.add(Marker(
          markerId: MarkerId('markerID-stop$j'),
          icon: stopIcon,
          position: LatLng(cart.route[j].latitude, cart.route[j].longitude),
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
        _carts.forEach((cart) {
          if (cart == _carts[_currentIndex]) {
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
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _radiusValue = _radiusValue;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
      GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
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
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(25))),
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
                  contentPadding:
                      EdgeInsets.only(top: 14, bottom: 12, left: 30, right: 12),
                ),
              ))),
      _bottomSettingsWidget(width, height),
      if (_currentIndex != null)
        Container(
            child: _carts[_currentIndex].isShow
                ? Positioned(
                    bottom: 0,
                    child: CartDetailWindow(
                        cart: _carts[_currentIndex],
                        onSwipeDown: () {
                          _onCloseCartDetailWindow();
                        }))
                : null),
    ]));
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
                        SizedBox(width: 2),
                        Text(
                          "Radius",
                          style: TextStyle(
                              color: _isRadiusSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 13),
                        ),
                        SizedBox(width: 2),
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
      _markers.removeRange(3, _markers.length);
      // clear the polyline from pervious route
      _polyline.clear();
      //hide the detail window
      _carts[_currentIndex].isShow = false;
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
    if (_carts.length > 0 && _currentIndex != null) {
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

  void getCartList() {

    NetworkUtil networkUtil= new NetworkUtil();


    String url= baseUrl+gtCartList+"?lat=30.557087&lng=76.939462&radius=1000";

    networkUtil.get(url,headers: {
"x-api-key":"63oVaqpOIfjsnbgSQmHNCylvHfD7GB0ag9m3hApeibul9Lgd6d"
    }).then((dynamic onValue){

    });


  }
}

void getcartDetail(){

  NetworkUtil networkUtil= new NetworkUtil();


  String url= baseUrl+cartDetail+"?id=7";

  networkUtil.get(url,headers: {
    "x-api-key":"63oVaqpOIfjsnbgSQmHNCylvHfD7GB0ag9m3hApeibul9Lgd6d"
  }).then((dynamic onValue){

  });

}
