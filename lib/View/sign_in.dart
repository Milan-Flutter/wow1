import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wow/View/mobile_num.dart';
import 'package:wow/View/sign_email.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wow/constant.dart';
import 'package:wow/services/push_notification.dart';
import 'bottom_navigation.dart';
import 'name.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? Google_id;
  String? email_id;
  String? photo_url;
  String? messege;
  String? User_id;
  String? token;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool Fastu = false;
  String? uid;

  final getStorage = GetStorage();

  googleLogin() async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }

      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      try {
        User? user = (await _auth.signInWithCredential(credential)).user;
      } catch (e) {}
      await _auth.signInWithCredential(credential);
      print("Result $reslut");
      setState(() {
        Google_id = reslut.id;
        photo_url = reslut.photoUrl;
        email_id = reslut.email;
        Fastu ? Fastuserlogin() : check_log_reg();
      });
      print(reslut.displayName);
      print(reslut.email);
      print(reslut.photoUrl);
    } catch (error) {
      print('errorr' + error.toString());
    }
  }

  Fastuserlogin() async {
    print('aa' + Google_id.toString());
    print('aa' + email_id.toString());
    print('aa' + photo_url.toString());

    Response response = await post(
        Uri.parse(
            "https://mechodalgroup.xyz/whoclone/api/fast_register_update.php"),
        body: {
          'id': uid.toString(),
          'google_Id': Google_id.toString(),
          'email': email_id.toString(),
          'photo_url': photo_url,
          'type': "1"
        });
    print(response.body.toString());
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      messege = (data['message']);
      if (messege == "Updated successfully") {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        sharedPreferences.setBool("isLogin", false);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => mobile_num(
                  status: '0',
                  email: email_id.toString(),
                )));
      }
    }
  }

  Future<void> update_token(String token, id) async {
    Response response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/tokan_update.php"),
        body: {'id': id.toString(), 'tokan': token.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
    }
  }

  Future<void> check_log_reg() async {
    print("BMFfkjhnfS");
    print('aa' + Google_id.toString());
    print('dsffsdg' + email_id.toString());
    print('aa' + photo_url.toString());

    Response response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/register.php"),
        body: {
          'google_Id': Google_id.toString(),
          'email': email_id.toString(),
          'photo_url': photo_url
        });
    print("BMFfkjhnfS");
    print(response.statusCode.toString());
    var data = jsonDecode(response.body.toString());
    print(data);

    if (response.statusCode == 200) {
      Notificationservices f1 = new Notificationservices();
      setState(() {
        f1.getDevicesToken().then((value) => ({
              token = value,
              print("kGHfAfAf"),
              print("azbc" + token.toString()),
              print(value)
            }));
      });
      print("jhfDhfDKJgnadskgjnsd");
      var data = jsonDecode(response.body.toString());
      print(data);
      messege = (data['message']);
      User_id = data['user_Id'];

      if (messege == 'Login Succesfull') {
        update_token(token.toString(), User_id.toString());
        print("object");
        Fluttertoast.showToast(msg: "Login Successful");
        getStorage.write('Id', User_id);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool("isLogin", true);

        sharedPreferences.setString("user", "user");
        sharedPreferences.setString("user_id", User_id.toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => botttom_navigate(status: '1')));
      } else if (messege == 'Registration successful') {
        update_token(token.toString(), User_id.toString());
        Fluttertoast.showToast(msg: "Registration Successful");
        getStorage.write('Id', User_id);
       SharedPreferences SUId = await SharedPreferences.getInstance();
        SUId.setString("user_id", User_id.toString());
        SUId.setString("user", "user");
      Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => mobile_num(
                  status: '0',
                  email: email_id.toString(),
                )));
      } else {
        Fluttertoast.showToast(msg: "Invalid Input1111");
      }
    } else {
      print("Invalid Inputabc");
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  check() async {
    SharedPreferences Suid = await SharedPreferences.getInstance();
    var data = Suid.getString('user_id');
    uid = data.toString();
    print(uid);
    if (data != null) {
      Fastu = true;
      print("anlnkmhbgugkjgjb");
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/all.png', // replace with your image path
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img_1.png",
                          height: 40,
                          width: 35,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .05,
                        ),
                        Text(
                          "App Logo",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xff111A41),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff333333),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: s_color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              googleLogin();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .06,
                              child: Center(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/img_5.png",
                                      height: 18,
                                      width: 16,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .02,
                                    ),
                                    Text(
                                      'With Google  ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xff73665C))),
                              child: Image.asset(
                                "assets/img_6.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: sign_email()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .13,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xff73665C))),
                              child: Image.asset(
                                "assets/img_7.png",
                                height: 25,
                                width: 25,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .015,
                    ),
                    Text(
                      "Or Fast Login",
                      style: TextStyle(color: Color(0xff73665C), fontSize: 14),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .015,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: main_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: name(
                                    mobile_num: "",
                                    status: '2',
                                  )));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * .06,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                            child: Text(
                              'Fast Login',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            _launchURL('https://www.mechodal.com/');
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(color: s_color, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .09),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(color: s_color, fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
