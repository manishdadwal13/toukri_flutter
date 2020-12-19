import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toukri/app/screens/widgets/SwipeGesture.dart';
import 'package:toukri/models/cart.dart';

class CartDetailWindow extends StatelessWidget {
  final Cart cart;
  final Function() onSwipeDown;
  CartDetailWindow({this.cart, this.onSwipeDown});

  Widget _column(String text, String icon, double height) {
    return Column(
      children: [
        Container(
          width: height * 0.03,
          height: height * 0.03,
          child: Image.asset(icon),
        ),
        SizedBox(height: 6),
        Text(text)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SwipeDetector(
      onSwipeDown: () {
        if (onSwipeDown != null) {
          onSwipeDown();
        }
      },
      child: AnimatedContainer(
          transform:
              Matrix4.translationValues(0, cart.isShow ? 0 : height * 0.1, 0),
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
                              "${cart.userName}",
                              style: TextStyle(fontSize: 18),
                            )),
                        Spacer(),
                        FlatButton(
                            height: height * 0.05,
                            minWidth: height * 0.05,
                            onPressed: () {},
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
                            onPressed: () => onSwipeDown())
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
                        alignment: Alignment.center, child: CartVegetables()),
                  ],
                )),
          ])),
    );
  }
}

class CartVegetables extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        Container(
            margin: EdgeInsets.only(right: 20, left: 20),
            width: MediaQuery.of(context).size.width,
            height: height * 0.10,
            color: Colors.grey[100],
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _vegetables.length,
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
                          child: SvgPicture.asset(
                              "assets/svg/${_vegetables[index]}.svg")),
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
      ]),
    );
  }
}
