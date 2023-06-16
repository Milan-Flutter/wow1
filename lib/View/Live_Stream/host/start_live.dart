import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:wow/View/profile_page.dart';
import '../../../Api/All_Data.dart';
import '../../../Model/All_Data.dart';
import '../live_stream_page.dart';

class live_page_host extends StatefulWidget {
  const live_page_host({Key? key}) : super(key: key);

  @override
  State<live_page_host> createState() => _live_page_hostState();
}

class _live_page_hostState extends State<live_page_host>
    with SingleTickerProviderStateMixin {
  AllData? data;
  int i = 1;
  bool isloding = false;
  String? coin;
  int count = 0;
  String? id;
  String? messege;
  String? name;

  @override
  void initState() {
    super.initState();
    profile1();
  }

  void profile1() {
    userData().data().then((value) {
      data = value;
      setState(() {
        coin = data!.data![0].walletCoin.toString();
        id = data!.data![0].id.toString();
        name = data!.data![0].name.toString();
        isloding = true;
      });
    });
  }

  Future<void> Stream() async {
    Response response = await post(
        Uri.parse(
            "https://mechodalgroup.xyz/whoclone/api/update_register_host_status.php"),
        body: {'id': id.toString(), 'host_streem': "active"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print("jkvbf;lsdhnsdthsd");
      print(data);
      messege = (data['message']);
      if (messege == "Updated successfully") {
        pushNewScreen(
          context,
          screen: live_Stream(
            id: id.toString(),
            name: name.toString(),
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloding
          ? WillPopScope(
              onWillPop: () async {
                print("object");
                SystemNavigator.pop(); // Exit the app
                return true;
              },
              child: SafeArea(
                child: Stack(
                  children: [
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
                                      pushNewScreen(
                                        context,
                                        screen: profile(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      width: MediaQuery.of(context).size.width *
                                          .45,
                                      padding: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFFFFF),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          bottomRight: Radius.circular(15.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                    onTap: () {},
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .06,
                                      width: MediaQuery.of(context).size.width *
                                          .28,
                                      padding:
                                          EdgeInsets.only(right: 10, left: 5),
                                      decoration: BoxDecoration(
                                        color: Color(0xffE32753),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          bottomRight: Radius.circular(15.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            "assets/mo.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                          Text(
                                            coin.toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {},
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
                          height: MediaQuery.of(context).size.height * .15,
                        ),
                        InkWell(
                            onTap: () {},
                            child: Image.asset("assets/img_10.png")),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffE32753),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              Stream();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .08,
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
              ),
            )
          : Center(
              child: CircularProgressIndicator(
              color: Color(0xffFF85A6),
            )),
    );
  }
}
