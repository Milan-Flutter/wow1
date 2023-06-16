import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/View/profile_page.dart';
import 'package:wow/View/sign_in.dart';
import 'package:wow/View/wallet.dart';
import '../Api/All_Data.dart';
import '../Controller/image_controller.dart';
import '../Controller/profile_data.dart';
import '../Model/All_Data.dart';
import '../constant.dart';
import '../services/push_notification.dart';
import 'Live_Stream/live_stream_page.dart';
import 'Video_Call/searching.dart';
import 'bottom_navigation.dart';
import 'notification.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({Key? key}) : super(key: key);

  @override
  State<HomeScreeen> createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final String animationUrl =
      'https://assets4.lottiefiles.com/packages/lf20_et7lpS7023.json';

  int i = 1;
  String? z;
  bool isloding = false;
  String? coin;
  bool fastU = false;
  int count = 0;
  DateTime? currentBackPressTime;
  String? type;
  bool isLodding = false;

  bool user = false;
  String? id;
  profile_data controller = Get.put(profile_data());
  ImageLoopController img_controller = Get.put(ImageLoopController());

  void check() {
    userData().data().then((value1) {
      AllData? data1 = value1;
      type = data1!.data![0].type.toString();
      if (type == "1") {
        user = true;
      } else if (type == "2") {
        fastU = true;
      }
      setState(() {
        isLodding = true;
      });
    });
  }

  @override
  void initState() {
    check();

    id = controller.uid.toString();

    z = "female";

    controller.harsh();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    Navigator.push(context,
        PageTransition(type: PageTransitionType.topToBottom, child: SignIn()));
  }

  Future<void> Stream() async {
    var response = await post(
        Uri.parse(
            "https://mechodalgroup.xyz/whoclone/api/update_register_host_status.php"),
        body: {'id': controller.uid.toString(), 'host_streem': "active"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      debugPrint("jkvbf;lsdhnsdthsd");
      print(data);
      var messege = (data['message']);
      if (messege == "Updated successfully") {
        pushNewScreen(
          context,
          screen: live_Stream(
            id: controller.uid.toString(),
            name: controller.name.toString(),
            liveid: id.toString(),
            host: true,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      } else {
        Fluttertoast.showToast(msg: "Please try again..");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Notificationservices n1 = new Notificationservices();
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("message" + message.notification!.title.toString());
      debugPrint("message" + message.notification!.body.toString());
      debugPrint("messagethyey" + message.data.toString());
      n1.showNotification(message, context);
    });
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        debugPrint("object");
        SystemNavigator.pop(); // Exit the app
        return true;
      },
      child: isLodding
          ? SafeArea(
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
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    fastU
                                        ? Fluttertoast.showToast(
                                            msg: "Please login")
                                        : pushNewScreen(
                                            context,
                                            screen: profile(),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .06,
                                    width:
                                        MediaQuery.of(context).size.width * .45,
                                    padding: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          "assets/img_8.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: s_color,
                                  onTap: () {
                                    fastU
                                        ? Fluttertoast.showToast(
                                            msg: "Please login")
                                        : pushNewScreen(
                                            context,
                                            screen: wallet(),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                          );
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        .06,
                                    width:
                                        MediaQuery.of(context).size.width * .28,
                                    padding:
                                        EdgeInsets.only(right: 10, left: 5),
                                    decoration: BoxDecoration(
                                      color: main_color,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: notification(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Image.asset(
                                "assets/img_9.png",
                                height: 50,
                                width: 50,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .25,
                      ),
                      InkWell(onTap: () {
                        pushNewScreen(
                          context,
                          screen: searching(
                            zender: z.toString(),
                          ),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      }, child: Obx(() {
                        return Image.asset(
                          img_controller
                              .images[img_controller.currentImageIndex.value],
                          height: 150,
                          width: 150,
                        );
                      })),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .2,
                      ),
                       user || fastU
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        i = 1;
                                        z = "female";
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color:
                                            i == 1 ? main_color : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          bottomLeft: Radius.circular(15.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Girls",
                                              style: TextStyle(
                                                  color: i == 1
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/mo.png",
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "9 Coins",
                                                  style: TextStyle(
                                                      color: i == 1
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 8),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        i = 2;
                                        z = "male";
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color:
                                            i == 2 ? main_color : Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Boys",
                                              style: TextStyle(
                                                  color: i == 2
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/mo.png",
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "9 Coins",
                                                  style: TextStyle(
                                                      color: i == 2
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 8),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        i = 3;
                                        z = "both";
                                      });
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color:
                                            i == 3 ? main_color : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          bottomRight: Radius.circular(15.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Both",
                                              style: TextStyle(
                                                  color: i == 3
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Free",
                                                  style: TextStyle(
                                                      color: i == 3
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 8),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: main_color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Stream();
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  width: MediaQuery.of(context).size.width * .7,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/img_21.png",
                                        height: 34,
                                        width: 35,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Go Live',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: s_color,
              ),
            ),
    ));
  }
}
