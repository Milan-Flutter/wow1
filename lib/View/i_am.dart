import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/constant.dart';
import '../services/push_notification.dart';
import 'bottom_navigation.dart';

class i_am extends StatefulWidget {
  const i_am(
      {Key? key,
      required this.mobile_num,
      required this.status,
      required this.name,
      this.email})
      : super(key: key);
  final String? mobile_num;
  final String? status;
  final String? name;
  final String? email;

  @override
  State<i_am> createState() => _i_amState();
}

class _i_amState extends State<i_am> {
  String? _selectedGender;
  String? value;
  String? messege;
  bool? fast = false;
  String? f_id;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Notificationservices f1 = new Notificationservices();
  Future<void> update_api() async {
    SharedPreferences SUId = await SharedPreferences.getInstance();
    var abc = SUId.getString('user_id');
    String token = await f1.getDevicesToken();

    print('FCM Token: $token');

    print(abc.toString());
    print(widget.name.toString());
    print(widget.mobile_num.toString());
    print(_selectedGender.toString());
    print(token.toString());
    setState(() {
      f_id = _auth.currentUser?.uid.toString();
      print("jv" + f_id.toString());
    });
    print({
      'id': abc.toString(),
      'name': widget.name.toString(),
      'mobile': widget.mobile_num.toString(),
      'gender': _selectedGender.toString(),
      'f_id': f_id.toString(),
      'tokan': token.toString()
    });
    Response response = await post(
      Uri.parse("https://mechodalgroup.xyz/whoclone/api/update_register.php"),
      body: {
        'id': abc.toString(),
        'name': widget.name.toString(),
        'mobile': widget.mobile_num.toString(),
        'gender': _selectedGender.toString(),
        'f_id': f_id.toString(),
        'tokan': token.toString()
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print("djhdhjd");

      print(data);
      messege = (data['message']);
      if (messege == 'Updated successfully') {
        try {
          print("kjgkgazkah");
          print(widget.email.toString());
          print(_auth.currentUser!.uid.toString());
          await _firestore.collection("users").doc(_auth.currentUser?.uid).set({
            "name": widget.name.toString(),
            "email": widget.email.toString(),
            "status": "Unavalible",
            "w_id": abc.toString(),
            "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
          });
        } catch (e) {
          print("aaaa" + e.toString());
        }
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        Fluttertoast.showToast(msg: "Add succesfully");
        sharedPreferences.setBool("isLogin", true);
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: botttom_navigate(
                  status: '0',
                )));
      } else {
        Fluttertoast.showToast(msg: "Invalid Input");
      }
    } else {
      print("Invalid Input");
    }
  }

  Future<void> fast_user() async {
    Response response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/fast_register.php"),
        body: {"name": widget.name.toString(), "gender": widget.toString()});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      SharedPreferences SUId = await SharedPreferences.getInstance();
      SUId.setString("user_id", data['user_Id'].toString());
      SUId.setBool("isLogin", true);
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              child: botttom_navigate(
                status: '2',
              )));
    }
  }

  @override
  void initState() {
    _selectedGender = "male";
    if (widget.status == "2") {
      fast = true;
    }
    print("fast" + fast.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/all.png', // replace with your image path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Text(
                    "I am a",
                    style: TextStyle(
                        fontSize: 28,
                        color: Color(0xff111A41),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = 'female';
                                value = 'female';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .8,
                              decoration: BoxDecoration(
                                color: _selectedGender == 'female'
                                    ? Color(0xFFff85a6)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Female',
                                    style: TextStyle(
                                      color: _selectedGender == 'female'
                                          ? Colors.white
                                          : Color(0xff3F2D20),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = 'male';
                                value = 'male';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .8,
                              decoration: BoxDecoration(
                                color: _selectedGender == 'male'
                                    ? Color(0xFFff85a6)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Male',
                                    style: TextStyle(
                                      color: _selectedGender == 'male'
                                          ? Colors.white
                                          : Color(0xff3F2D20),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .46,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: main_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          if (fast == true) {
                            fast_user();
                          } else {
                            update_api();
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * .06,
                          width: MediaQuery.of(context).size.width * .8,
                          child: Center(
                            child: Text(
                              'Continue',
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
