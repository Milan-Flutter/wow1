import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/View/bottom_navigation.dart';
import '../Controller/profile_data.dart';
import '../services/push_notification.dart';
import 'Onbording.dart';

class spalsh_scrren extends StatefulWidget {
  const spalsh_scrren({Key? key}) : super(key: key);

  @override
  State<spalsh_scrren> createState() => _spalsh_scrrenState();
}

class _spalsh_scrrenState extends State<spalsh_scrren> {
  profile_data controller = Get.put(profile_data());
  String? token;

  Future<void> update_token(id)
  async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/tokan_update.php"),
        body: {'id': id.toString(), 'tokan': token.toString()});
    if (response.statusCode == 200) {
      print({'id': id.toString(), 'tokan': token.toString()});
      var data = jsonDecode(response.body.toString());
      print(token.toString());
      print("kdrgljgadgoigh" + data.toString());
    }
  }

  void checkCondition()
  async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLogin = sharedPreferences.getBool("isLogin");
    String? id = sharedPreferences.getString("user_id");
    Notificationservices f1 = new Notificationservices();

    setState(() {
      f1.getDevicesToken().then((value) => ({
            token = value,
            print("kGHfAfAf"),
            print("azbc" + token.toString()),
            if (isLogin != null)
              {
                update_token(id.toString()),
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => botttom_navigate(
                          status: '3',
                        ))),
              }
            else
              {
                print("====LOGIN ELSE"),
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(builder: (context) => onbording())),
              },
            print(value)
          }));
    });

    print("===>IS LOGIN=>" + isLogin.toString());
  }

  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () => checkCondition());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/img.png', // replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            child: Center(
              child: Row(
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
            ),
          ),
        ],
      ),
    );
  }
}
