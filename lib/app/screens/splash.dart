import 'package:flutter/material.dart';
import 'package:toukri/app/screens/login.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.fill,
          )),
        ),
        Positioned(
            bottom: MediaQuery.of(context).size.width * .14,
            width: MediaQuery.of(context).size.width,
            
            child: 
               Center(
                 child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.white,
                    height: 60,
                    minWidth: MediaQuery.of(context).size.width * .88,
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Login())),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )),
               ),
            ),
      ],
    );
  }
}
