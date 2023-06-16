import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/View/bottom_navigation.dart';
import 'package:wow/View/wallet.dart';

import '../../Api/All_Data.dart';
import '../../Controller/image_controller.dart';
import '../../Controller/profile_data.dart';
import '../../Model/All_Data.dart';
import 'call_page.dart';

class searching extends StatefulWidget {
  const searching({Key? key, required this.zender}) : super(key: key);
  final String? zender;

  @override
  State<searching> createState() => _searchingState();
}

class _searchingState extends State<searching> {
  profile_data controller = Get.put(profile_data());
  bool fun = false;

  String? id;
  String? type;
  String? name;
  String? callId;
  var messege;
  final String animationUrl =
      'https://assets4.lottiefiles.com/packages/lf20_et7lpS7023.json';

  String? coin;

  ImageLoopController img_controller = Get.put(ImageLoopController());

  Future<void> coin_call(
    String coin,
  ) async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/coin.php"),
        body: {
          'wallet_coin': coin.toString(),
          'user_id': id.toString(),
          'host_id': callId.toString()
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print("faudgdgdgdgdgdgkur");

      var messege = (data['message']);

      if (messege == 'Coins transferred successfully.') {
        controller.harsh();
        Fluttertoast.showToast(msg: "Coins transferred successfully.");
        print("vSSAfvZgEg");
        print("object" + name.toString());
        print(id.toString());
        print(callId.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyCall(
                    Username: name.toString(),
                    userID: id.toString(),
                    callID: callId.toString(),
                    privet: false,
                  )),
        );
      } else if (messege == "Insufficient coins in the user's wallet.") {
        Fluttertoast.showToast(msg: "Insufficient coins in the user's wallet");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Please try again");
      }
    } else {
      print("Invalid Input");
    }
  }

  Future<void> setVideoCall() async {
    if (type == "0") {
      print("abcc");
      var response = await post(
          Uri.parse(
              "https://mechodalgroup.xyz/whoclone/api/update_register_status.php"),
          body: {'id': id.toString(), 'host_status': "active"});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        messege = (data['message']);
        if (messege == "Updated successfully") {
          print("object");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyCall(
                      Username: name.toString(),
                      userID: id.toString(),
                      callID: id.toString(),
                      privet: false,
                    )),
          );
        }
      }
    } else if (type == "1" || type == "2") {
      print("Harsh12");
      var response = await post(
          Uri.parse(
              "https://mechodalgroup.xyz/whoclone/api/update_register_status.php"),
          body: {'id': id.toString(), 'user_status': "active"});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        messege = (data['message']);
        if (messege == "Updated successfully") {
          print({'gender': widget.zender.toString()});
          var response = await post(
              Uri.parse(
                  "https://mechodalgroup.xyz/whoclone/api/user_status.php"),
              body: {'gender': widget.zender.toString()});
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body.toString());
            print("gAKSJGhlgkjng");


            if (data['message'] == "Matching Successfully") {
              callId = data['id'].toString();
              setState(() {});
              var response = await post(
                  Uri.parse(
                      "https://mechodalgroup.xyz/whoclone/api/update_register_status.php"),
                  body: {'id': id.toString(), 'host_status': "incalling"});
              if (response.statusCode == 200) {
                var data = jsonDecode(response.body.toString());

                messege = (data['message']);
                if (messege == "Updated successfully") {
                  print(callId.toString());
                  print("sdkagmdklhjsa;dfh");

                  print("ASF" + data['id'].toString());
                  if (callId != null) {
                    print(name);
                    print(id);
                    print(callId);
                    if (widget.zender == "male") {
                      print("fkESHSZf");
                      coin_call("9");
                    } else if (widget.zender == "female") {
                      print("kfjshg");
                      coin_call("9");
                    } else {
                      print("sgjkhnldfkmhdrkhmzdh");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyCall(
                                  Username: name.toString(),
                                  userID: id.toString(),
                                  callID: callId.toString(),
                                  privet: false,
                                )),
                      );
                    }
                  }
                }
              }
            } else if (data['message'] ==
                "No matching rows with host_status as active found.") {
              fun ? null : setVideoCall();
            } else {
              print("Data not Valid");
            }
          }
        }
      }
    } else {
      print("User Not Valid");
    }
  }

  @override
  void initState() {
    super.initState();
    print("ksjgNgzhzdh");
    id = controller.uid.toString();
    type = controller.type.toString();
    name = controller.name.toString();
    coin = controller.coin.toString();
    print(widget.zender.toString());
    setVideoCall();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Center(
            child: Lottie.network(
              animationUrl,
              fit: BoxFit.cover,
            ),
          ),
          Image.asset(
            'assets/all.png', // replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: wallet()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .06,
                    width: MediaQuery.of(context).size.width * .28,
                    padding: EdgeInsets.only(right: 10, left: 5),
                    decoration: BoxDecoration(
                      color: Color(0xffE32753),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          "assets/mo.png",
                          height: 30,
                          width: 30,
                        ),
                        Obx(() {
                          return Text(
                            controller.coin.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .35,
              ),
              Center(
                child: Obx(() {
                  return Image.asset(
                    img_controller
                        .images[img_controller.currentImageIndex.value],
                    height: 150,
                    width: 150,
                  );
                }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .2,
              ),
              Center(
                child: Text(
                  "Searching..... ",
                  style: TextStyle(
                    color: Color(0xff73665C),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffE32753),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      fun = true;
                    });
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .06,
                    width: MediaQuery.of(context).size.width * .3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Leave',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.logout)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
