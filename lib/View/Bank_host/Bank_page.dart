import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:wow/View/Bank_host/add_bank_page.dart';
import 'package:wow/constant.dart';
import '../../Controller/profile_data.dart';
import '../../services/push_notification.dart';

class bank_page extends StatefulWidget {
  const bank_page({Key? key}) : super(key: key);

  @override
  State<bank_page> createState() => _bank_pageState();
}

class _bank_pageState extends State<bank_page> {
  bool add = false;
  @override
  String? uid;
  String? name;
  String? acc_num;
  String? ifsc;
  String? b_name;
  bool isloding = false;
  profile_data controller = Get.put(profile_data());
  void initState() {
    uid = controller.uid.toString();

    if (controller.b_u_name.value == "") {
      print('djfsebngksngsdgsd');
      add = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Notificationservices n1 = new Notificationservices();
    FirebaseMessaging.onMessage.listen((message) {
      print("message" + message.notification!.title.toString());
      print("message" + message.notification!.body.toString());
      print("messagethyey" + message.data.toString());
      n1.showNotification(message, context);
    });
    return Scaffold(
        backgroundColor: bg_color,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      Text(
                        "Available Balance",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Text(
                        controller.coin.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .02,
                      ),
                      Text(
                        "Coins",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .06,
                        width: MediaQuery.of(context).size.width * .7,
                        padding: EdgeInsets.only(right: 10, left: 5),
                        decoration: BoxDecoration(
                          color: main_color,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          "Bank Details",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                      Container()
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  add
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img_28.png",
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .04,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 45),
                              child: Text(
                                "Please Add your bank details. This account is used for withdrove coins",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .02,
                            ),
                            TextButton(
                              onPressed: () {
                                pushNewScreen(
                                  context,
                                  screen: add_bank(
                                    status: '0',
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Text(
                                "Add Bank Details",
                                style: TextStyle(
                                    color: main_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      : Obx(() {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: main_color.withOpacity(.3),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        pushNewScreen(
                                          context,
                                          screen: add_bank(
                                            status: '1',
                                          ),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      },
                                      child: Text(
                                        "Change",
                                        style: TextStyle(
                                            color: main_color, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Name             : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(controller.b_u_name.toString())
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Account        : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(controller.account_number.toString())
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "IFHC Code    : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(controller.ifsc.toString())
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Bank Name : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(controller.b_name.toString())
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                              ],
                            ),
                          );
                        })
                ],
              ),
            ),
          ),
        ));
  }
}
