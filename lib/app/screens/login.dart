import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toukri/app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toukri/app/screens/widgets/tutorial.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  bool sendToTutorial = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool authSignedIn;
  String uid;
  String userEmail;
  FirebaseUser _user;
  void initState() {
    super.initState();
    setupFirstTime();
  }

// show tutorial screen if user is new
  void setupFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool value = prefs.getBool('isFirstTime');
// check if user already login the app or not
    if (value != null || value == true) {
      // user already login
      setState(() {
        sendToTutorial = false;
      });
    } else {
      // new user login
      setState(() {
        sendToTutorial = true;
      });
      prefs.setBool('isFirstTime', true);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            )),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.7),
                  Colors.white.withOpacity(0.6)
                ])),
          ),
          Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 130,
                child: Image.asset('assets/toukri_logo.png'),
              ),
              SizedBox(height: 80),
              ButtonTheme(
                height: 50,
                minWidth: 250,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  textColor: Colors.black,
                  color: Colors.white,
                  onPressed: () => {

                    signInWithGoogle().whenComplete(() {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                               Home()));

                    })

                  },
                  elevation: 2.0,
                  child: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 33,
                          width: 33,
                          child: Image.asset('assets/google-login.png'),
                        ),
                        SizedBox(width: 12),
                        Text("Sign in with Google")
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ButtonTheme(
                height: 50,
                minWidth: 250,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  textColor: Colors.black,
                  color: Colors.white,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              sendToTutorial ? Tutorial() : Home())),
                  elevation: 2.0,
                  child: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Login as Guest")],
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }



  Future<FirebaseUser> signInWithGoogle() async {

googleSignIn.signOut();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =

    await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(

      accessToken: googleSignInAuthentication.accessToken,

      idToken: googleSignInAuthentication.idToken,

    );

    AuthResult authResult = await _auth.signInWithCredential(credential);

    _user = authResult.user;

    assert(!_user.isAnonymous);

    assert(await _user.getIdToken() != null);

   // FirebaseUser currentUser = await authResult.currentUser();

   // assert(_user.uid == currentUser.uid);



    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");

  }

}
