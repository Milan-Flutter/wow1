import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:wow/View/bottom_navigation.dart';
import 'package:wow/constant.dart';
import '../../Controller/profile_data.dart';
import 'call_page.dart';

class PickupCallPage extends StatefulWidget {
  final String? hostid;
  const PickupCallPage({super.key, this.hostid});
  @override
  State<PickupCallPage> createState() => _PickupCallPageState();
}

class _PickupCallPageState extends State<PickupCallPage> {
  profile_data controller = Get.put(profile_data());
  @override
  void initState() {
// TODO: implement initState
    Fluttertoast.showToast(msg: widget.hostid.toString());
    var data = jsonDecode(widget.hostid.toString());
    print(data.toString());
    super.initState();
  }

  Api(String type) async {
    try {
      var response = await post(
          Uri.parse(
              "https://mechodalgroup.xyz/whoclone/api/add_call_history.php"),
          body: {
            'user_id': controller.uid.toString(),
            'miss_id': widget.hostid.toString(),
            'type': type.toString(),
          });
      print({
        'user_id': controller.uid.toString(),
        'miss_id': widget.hostid.toString(),
        'type': type.toString(),
      });
      if (response.statusCode == 200) {
        var messege;
        var data = jsonDecode(response.body.toString());
        print(data.toString());
        messege = (data["message"]);
        Fluttertoast.showToast(msg: messege);
        if (messege == 'Video call history recorded successfully.') {
          if (type == "miss call") {
            pushNewScreen(
              context,
              screen: botttom_navigate(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          } else {
            pushNewScreen(
              context,
              screen: MyCall(
                Username: controller.name.toString(),
                userID: controller.uid.toString(),
                callID: controller.uid.toString(),
                privet: true,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          }
        } else {
          print(data);
        }
      } else {
        print("Invalid Input");
      }
    } catch (e) {
      print("login failled");
      print('error' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/all.png', // replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * .1),
                Text(
                  'Incoming Call',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: main_color),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .2),
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: AssetImage(
                    'assets/img_11.png',
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                Text(
                  'John Doe',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: s_color),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .1),
                Text(
                  'Incoming Call',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        Api("attend call");
                      },
                      child: Icon(
                        Icons.video_call,
                      ),
                      backgroundColor: Colors.green,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Api("miss call");
                      },
                      child: Icon(Icons.call_end),
                      backgroundColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
