import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/Model/All_Data.dart';
import 'package:wow/View/bottom_navigation.dart';
import 'package:wow/View/name.dart';
import 'package:wow/constant.dart';

import '../Api/All_Data.dart';
import '../services/push_notification.dart';

class sign_email extends StatefulWidget {
  const sign_email({Key? key}) : super(key: key);

  @override
  State<sign_email> createState() => _sign_emailState();
}

class _sign_emailState extends State<sign_email> {
  final getStorage = GetStorage();
  String? User_id;
  AllData? data1;
  String? u_name;
  String? f_id;
  String? token;

  var messege;
  @override
  void initState() {
    super.initState();
  }

  Future<void> update_token(String token, id) async {
    Response response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/tokan_update.php"),
        body: {'id': id.toString(), 'tokan': token.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
    }
  }

  void profile(String uid) {
    userData().data3(id: uid.toString()).then((value) {
      data1 = value;
      setState(() {
        u_name = data1!.data![0].name.toString();
        f_id = data1!.data![0].f_id.toString();
        print(f_id);
      });
    });
  }

  Future<void> LOG_IN(String email, password) async {
    try {
      Response response = await post(
          Uri.parse(
              "https://mechodalgroup.xyz/whoclone/api/host_login_select.php"),
          body: {'email': email.toString(), 'password': password.toString()});
      Notificationservices f1 = new Notificationservices();
      setState(() {
        f1.getDevicesToken().then((value) => ({
              token = value,
              print("kGHfAfAf"),
              print("azbc" + token.toString()),
              print(value)
            }));
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        messege = (data['status']);
        User_id = data['id'];

        if (messege == 'Login Successful') {
          update_token(token.toString(), User_id.toString());
          print("dgasesetg" + f_id.toString());

          if (f_id == null) {
            print("jhgkaGgjHglg");
            profile(User_id.toString());
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email.toString(), password: password.toString())
                .then((value) {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({
                "name": u_name.toString(),
                "email": email.toString(),
                "status": "Unavalible",
                "w_id": User_id.toString(),
                "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
              }).then((value) {
                print("lkSZJgbl");
              });
            }).catchError((e) {
              print(e);
            });

            print("fghiuafliESg" +
                FirebaseAuth.instance.currentUser!.uid.toString());
            Response response = await post(
                Uri.parse(
                    "https://mechodalgroup.xyz/safe4u/apis/host_insert_id.php"),
                body: {
                  'id': User_id.toString(),
                  'f_id': FirebaseAuth.instance.currentUser!.uid.toString(),
                });
            var data = jsonDecode(response.body.toString());
            print("jhfgdyDU" + data);
            if (response.statusCode == 200) {
              var data = jsonDecode(response.body.toString());
              print("jhfgdyDU" + data);
              messege = (data['message']);
            }
          }

          Fluttertoast.showToast(msg: "Login Successful");
          getStorage.write('Id', User_id);
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setBool("isLogin", true);
          sharedPreferences.setString("user", "host");

          SharedPreferences SUId = await SharedPreferences.getInstance();
          print('uuu' + User_id.toString());
          SUId.setString("user_id", User_id.toString());
          var abc = SUId.getString('user_id');
          print('sss' + abc.toString());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => botttom_navigate(
                    status: '3',
                  )));
        } else {
          Fluttertoast.showToast(msg: "Invalid Input");
        }
      } else {
        print("Invalid Input");
      }
    } catch (e) {
      if (messege == "Invalid Email Address") {
        Fluttertoast.showToast(msg: "Invalid Email Address");
      }
      print("login failled");
      print('error' + e.toString());
    }
  }

  TextEditingController _Emailcontroller = TextEditingController();
  TextEditingController _passcontroller = TextEditingController();
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * .06,
                          width: MediaQuery.of(context).size.width * .13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffFFFFFF)),
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: s_color,
                            size: 15,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Text(
                            "Sing In with Email",
                            style: TextStyle(
                                fontSize: 28,
                                color: Color(0xff111A41),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .015,
                          ),
                          Text(
                            "Type the verification code we’ve sent you",
                            style: TextStyle(
                                color: Color(0xff73665C), fontSize: 11),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              controller: _Emailcontroller,
                              decoration: InputDecoration(
                                hintText: 'Your Your Name',
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Color(0xff3F2D20)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: main_color)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color:
                                        main_color, // Set the border color when the TextField is focused
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: _passcontroller,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Enter a Password',
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Color(0xff3F2D20)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: main_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color:
                                        main_color, // Set the border color when the TextField is focused
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .4,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 50),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: main_color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    onPressed: () {
                                      print("jkxczvjfdgdgSDg");
                                      LOG_IN(_Emailcontroller.text,
                                          _passcontroller.text);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      child: Center(
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
