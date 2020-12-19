import 'package:flutter/material.dart';
import 'package:toukri/app/screens/home.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: Stack(children: [
        Center(
          child: Container(
            height: height * 0.7,
            width: width * 0.7,
            decoration: BoxDecoration(
                // shape: BoxShape.retangle, // BoxShape.circle or BoxShape.retangle
                //color: const Color(0xFF66BB6A),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 8.0,
                  ),
                ]),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset('assets/tutorial.png', fit: BoxFit.cover)),
          ),
        ),
        Positioned(
            width: width * 0.5,
            left: width * 0.25,
            bottom: 30,
            child: ButtonTheme(
              height: 50,
              minWidth: 250,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                ),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>  Home())),
                elevation: 2.0,
                child: Container(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     
                      Text("Go to home")
                    ],
                  ),
                ),
              ),
            ),)
      ]),
    );
  }
}
