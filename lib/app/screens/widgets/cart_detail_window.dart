import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:toukri/app/model/cart_detail_response.dart';
import 'package:toukri/app/model/cartdata.dart';
import 'package:toukri/app/screens/widgets/SwipeGesture.dart';
import 'package:toukri/models/cart.dart';
import 'package:url_launcher/url_launcher.dart';

class CartDetailWindow extends StatefulWidget {
  final CartData cart;
  final Function() onSwipeDown;

  CartDetailWindow({this.cart, this.onSwipeDown});



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartDetailWindowState();
  }
}

class _CartDetailWindowState extends State<CartDetailWindow>{





  Widget _column(String text, String icon, double height) {
    return Column(
      children: [
        InkWell(
            onTap: ()=>{
              if(text=="Share"){
                Share.share('check out my website https://example.com'),


              }


            },
            child: Container(
          width: height * 0.03,
          height: height * 0.03,
          child: Image.asset(icon),
        )   ),
        SizedBox(height: 6),
        Text(text)
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SwipeDetector(
      onSwipeDown: () {
        if (widget.onSwipeDown != null) {
          widget.onSwipeDown();
        }
      },
      child: AnimatedContainer(
          transform: Matrix4.translationValues(0, true ? 0 : height * 0.1, 0),
          duration: Duration(milliseconds: 1000),
          color: Colors.white,
          height: height * 0.3,
          width: width,
          child: Stack(children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: height * 0.07,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg')),
                            borderRadius:
                            BorderRadius.all(Radius.circular(6.0)),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 12, top: 12),
                            child: Text(
                              "${widget.cart.cartName}",
                              style: TextStyle(fontSize: 18),
                            )),
                        Spacer(),
                        FlatButton(
                            height: height * 0.05,
                            minWidth: height * 0.05,
                            onPressed: () {

                              _launchURL();

                            },
                            child: Container(
                                width: height * 0.05,
                                height: height * 0.05,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                ))),
                        IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () => widget.onSwipeDown())
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _column('My Story', 'assets/my_story.png', height),
                        _column('My Rate', 'assets/green_star.png', height),
                        _column('Share', 'assets/share.png', height)
                      ],
                    ),
                    SizedBox(height: 12),
                   Container(
                        alignment: Alignment.center, child: widget.cart.cartDetailData!=null? CartVegetables(cartDetailData: widget.cart.cartDetailData,):Container()),
                  ],
                )),
          ])),
    );
  }
  _launchURL() async {
    const url = 'tel:';
    if (await canLaunch(url)) {
      await launch(url,);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CartVegetables extends StatefulWidget {

  final CartDetailData cartDetailData;

  const CartVegetables({Key key, this.cartDetailData}) : super(key: key);

  @override
  _CartVegetablesState createState() => _CartVegetablesState();
}

class _CartVegetablesState extends State<CartVegetables> {
  final ScrollController scrollController = ScrollController();
  double _offset = 0;
  List _vegetables = [
    "beans",
    "beetroot",
    "Bittergourd",
    "Bottlegourd",
    "Brinjal-Bharta",
    "Brinjal",
    "cabbage",
    "capsicum",
    "carrot",
    "cauliflower",
    "Chillipepper",
    "coriander",
    "cucumber",
    "fruit",
    "garlic",
    "ginger",
    "lemons",
    "mushrooms",
    "okra",
    "onion",
    "potato",
    "pumpkin",
    "radish",
    "spinach",
    "tomato"
  ];
  List<CartItems> cartItems= List();
  @override
  void initState() {
    super.initState();


    setState(() {
      cartItems= widget.cartDetailData.cartItems;
    });



  }

  void tabbedBack() {
    print("animate to${scrollController.position}");
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void tabbedForward(BuildContext context) {
    if (_offset <= scrollController.position.maxScrollExtent) {
      setState(() {
        _offset += MediaQuery.of(context).size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Expanded(
        child: Container(
      width: MediaQuery.of(context).size.width,
          height: height * 0.085,
      child:cartItems.length!=0? Stack(children: [
        Container(
            margin: EdgeInsets.only(right: 20, left: 20),
            width: MediaQuery.of(context).size.width,

            color: Colors.grey[100],
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    width: 44,
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: InkWell(
                          onTap: () {
                            print("Selected ${_vegetables[index]}");
                          },
                          child: SvgPicture.network(cartItems[index].iconUrl)),
                    ));
              },
            )),
        Positioned.fill(
          left: -23,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FlatButton(
                onPressed: () {
                  if (MediaQuery.of(context).size.width <= _offset) {
                    setState(() {
                      _offset -= MediaQuery.of(context).size.width;
                    });
                    scrollController.animateTo(_offset,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut);
                  } else {
                    setState(() {
                      _offset = 0;
                    });
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 0))
                        ],
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.grey[500],
                    ))),
          ),
        ),
        Positioned.fill(
          right: -23,
          child: Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
                onPressed: () {
                  if (_offset <= scrollController.position.maxScrollExtent) {
                    setState(() {
                      _offset += MediaQuery.of(context).size.width;
                    });
                    scrollController.animateTo(_offset,
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut);
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 0))
                        ],
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: 30,
                    width: 30,
                    child: Icon(Icons.arrow_forward_ios_outlined,
                        color: Colors.grey[500]))),
          ),
        )
      ]):
      Container(),
    ));
  }
}
