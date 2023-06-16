import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:wow/View/Home_page.dart';
import 'package:wow/constant.dart';
import '../Api/All_Data.dart';
import '../Controller/profile_data.dart';
import '../Model/All_Data.dart';
import '../services/push_notification.dart';
import 'Bank_host/Bank_page.dart';
import 'Live_Stream/User/live_join_page.dart';
import 'chat/chat_home.dart';
import 'follower_page.dart';
import 'history_page.dart';

class botttom_navigate extends StatefulWidget {
  @override
  _botttom_navigateState createState() => _botttom_navigateState();
  const botttom_navigate({Key? key, this.status, this.button})
      : super(key: key);
  final String? status;
  final String? button;
}

class _botttom_navigateState extends State<botttom_navigate> {
  String? type;
  int i = 0;
  int ind = 2;
  profile_data controller = Get.put(profile_data());

  bool user = false;
  bool fast = false;
  AllData? data1;
  bool isLodding = false;

 List<Widget> _pages() {
    return [
      user || fast ? live_page_user() : bank_page(),
      fast
          ? Center(
              child: Text("Please Login!!"),
            )
          : followe_page(),
      HomeScreeen(),
      fast
          ? Center(
              child: Text("Please Login!!"),
            )
          : chat_home(),
      fast
          ? Center(
              child: Text("Please Login!!"),
            )
          : history()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItem() {
    return [
      user || fast
          ? PersistentBottomNavBarItem(
              icon: Icon(Icons.location_on_outlined, color: main_color),
              title: "Discover",
              activeColorPrimary: main_color,
              inactiveColorPrimary: Colors.white,
              inactiveIcon: Icon(
                Icons.location_on_outlined,
                color: s_color,
              ),
            )
          : PersistentBottomNavBarItem(
              icon: Icon(Icons.monetization_on, color: main_color),
              title: "Bank",
              activeColorPrimary: main_color,
              inactiveColorPrimary: Colors.white,
              inactiveIcon: Icon(
                Icons.monetization_on,
                color: s_color,
              ),
            ),
      PersistentBottomNavBarItem(
        title: "Followed",
        activeColorPrimary: main_color,
        inactiveColorPrimary: Colors.white,
        icon: Icon(
          Icons.favorite_border_rounded,
          color: main_color,
        ),
        inactiveIcon: Icon(
          Icons.favorite_border_rounded,
          color: s_color,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.call,
          color: Colors.white,
        ),
        activeColorPrimary: main_color,
        inactiveColorPrimary: s_color,
      ),
      PersistentBottomNavBarItem(
        title: "Messages",
        activeColorPrimary: main_color,
        inactiveColorPrimary: Colors.white,
        icon: Icon(
          Icons.messenger_outline_rounded,
          color: main_color,
        ),
        inactiveIcon: Icon(
          Icons.messenger_outline_rounded,
          color: s_color,
        ),
      ),
      PersistentBottomNavBarItem(
        title: "History",
        activeColorPrimary: main_color,
        inactiveColorPrimary: Colors.white,
        icon: Icon(
          Icons.history,
          color: main_color,
        ),
        inactiveIcon: Icon(
          Icons.history,
          color: s_color,
        ),
      ),
    ];
  }

  _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .45,
                  padding: EdgeInsets.only(top: 22, bottom: 15),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .05,
                          width: MediaQuery.of(context).size.width * .6,
                          padding: EdgeInsets.only(right: 10, left: 5),
                          decoration: BoxDecoration(
                            color: main_color,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ZERO TOLERANCE POLICY",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 45,
                              ),
                              Image.asset(
                                "assets/img_14.png",
                                height: 50,
                                width: 50,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                "age Verification",
                                style: TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "You must be 18 years old or over to enter",
                                style:
                                    TextStyle(color: main_color, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide(
                                  color: main_color,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Do something
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .5,
                              child: Center(
                                child: Text(
                                  'Yes! I am 18+',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: main_color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Other child widgets here
                ),
              );
            },
          );
        });
  }

  _age1() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * .45,

                padding: EdgeInsets.only(top: 22, bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.width * .6,
                        padding: EdgeInsets.only(right: 10, left: 5),
                        decoration: BoxDecoration(
                          color: main_color,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ZERO TOLERANCE POLICY",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 45,
                            ),
                            Image.asset(
                              "assets/img_14.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "age Verification",
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "You must be 18 years old or over to enter",
                              style: TextStyle(color: main_color, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: BorderSide(
                                color: main_color,
                                width: 2.0,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _freecoin();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .05,
                            width: MediaQuery.of(context).size.width * .5,
                            child: Center(
                              child: Text(
                                'Yes! I am 18+',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: main_color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Other child widgets here
              ),
            ),
          );
        });
  }

  _freecoin() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * .45,

                padding: EdgeInsets.only(top: 22, bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/img_13.png'),
                      fit: BoxFit.fill,
                    )),

                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Center(
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .1,
                              ),
                              Image.asset(
                                "assets/mo.png",
                                height: 100,
                                width: 100,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "+50",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Text(
                          "You’ve won free\ncoin!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: main_color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: botttom_navigate()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .5,
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
                      ],
                    ),
                  ),
                ),
                // Other child widgets here
              ),
            ),
          );
        });
  }

  void check() {
    userData().data().then((value1) {
      AllData? data1 = value1;
      type = data1!.data![0].type.toString();
      if (type == "1") {
        user = true;
      } else if (type == "2") {
        fast = true;
      }
      setState(() {
        isLodding = true;
      });
    });
  }

  @override
  void initState() {
    controller.harsh();
    check();

    print("data fetch");



    controller.bank_details();
       debugPrint(widget.status.toString());
    if (widget.button != null) {
      setState(() {
        ind = int.parse(widget.button.toString());
      });
    }
    if (widget.status == '1')
    {
      _showDialog();
    } else if (widget.status == '0') {
      _age1();
    } else if (widget.status == '2') {
      _age1();
    } else {
        debugPrint("objectaaaadhfd");
    }

    super.initState();
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
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          i++;
        });debugPrint("object");
        if (i == 2) {
          SystemNavigator.pop();
          return true;
        }
        // Exit the app

        return false; // Allow the pop operation
      },
      child: isLodding
          ? Scaffold(
              body: Container(
                color: Colors.yellow,
                child: Text("aa"),
              ),
              bottomNavigationBar: PersistentTabView(
                context,
                controller: PersistentTabController(initialIndex: ind),
                screens: _pages(),
                items: _navBarItem(),
                decoration:
                    NavBarDecoration(borderRadius: BorderRadius.circular(1)),
                navBarStyle: NavBarStyle.style16,
              ),
            )
          : Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: s_color,
                ),
              ),
            ),
    );
  }
}
