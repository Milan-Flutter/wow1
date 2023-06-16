import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/View/bottom_navigation.dart';
import 'package:wow/View/story_profile.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../Api/All_Data.dart';
import '../../Controller/profile_data.dart';
import '../../Model/All_Data.dart';

class MyCall extends StatefulWidget {
  const MyCall({
    Key? key,
    required this.callID,
    required this.Username,
    required this.userID,
    required this.privet,
  }) : super(key: key);
  final String callID;
  final String? Username;
  final String? userID;
  final bool privet;

  @override
  State<MyCall> createState() => _MyCallState();
}

class _MyCallState extends State<MyCall> {
  AllData? data1;
  bool all = false;
  late Map planres;
  String? messege;
  String? uid;
  AllData? data;
  String? hostId;
  String? type;
  bool host = true;
  profile_data controller = Get.put(profile_data());

  Future<void> getData() async {
    SharedPreferences SUId = await SharedPreferences.getInstance();
    setState(() {
      uid = SUId.getString('user_id');
    });
    uid = SUId.getString('user_id');
  }

  void profile1() {
    userData().data().then((value) {
      data = value;
      setState(() {
        type = data!.data![0].type.toString();
        if (type == "0") {
          host = false;
        }
      });
    });
  }

  void profile() {
    userData().data3(id: widget.callID.toString()).then((value) {
      data1 = value;
      print(data1);
      setState(() {
        all = true;
      });
    });
  }

  Future<void> plan1() async {
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_gift.php');
    var response = await post(url);
    if (response.statusCode == 200) {
      setState(() {
        planres = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    print("sdgbjkaeG");
    print("dfhgabvksdgahs" + widget.Username.toString());
    print(widget.userID.toString());
    print(widget.callID.toString());
    profile1();
    getData();
    profile();
    plan1();

    hostId = widget.callID.toString();
    print("IKxfgfyghfsdhjfsd" + hostId.toString());
    super.initState();
  }

  Future<void> change_status() async {
    if (widget.privet == true) {
      var response = await post(
          Uri.parse(
              "https://mechodalgroup.xyz/whoclone/api/update_register_status.php"),
          body: {'id': hostId.toString(), 'host_status': "deactive"});
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Privet Call End!!");
      }
    } else {
      var response = await post(
          Uri.parse(
              "https://mechodalgroup.xyz/whoclone/api/update_register_status.php"),
          body: {'id': hostId.toString(), 'host_status': "deactive"});
    }

    Get.to(botttom_navigate());
  }

  ZegoUIKitPrebuiltCallController _conroller =
      ZegoUIKitPrebuiltCallController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: all
          ? WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Stack(
                children: [
                  ZegoUIKitPrebuiltCall(
                      appID: 90784165,
                      appSign:
                          "21c11fc3e936a1afc11429fc2db77417cb41c247cc304b2f15b8df345d4ee2fb", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
                      userID: widget.userID.toString(),
                      userName: widget.Username.toString(),
                      callID: widget.callID.toString(),
                      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
                      onDispose: change_status),
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: st_profile(
                                  id: widget.callID,
                                )));
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius:
                                  20.0, // Adjust the radius according to your desired size
                              backgroundImage: NetworkImage(
                                  data1!.data![0].photoUrl.toString()),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              data1!.data![0].name.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  host
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 62),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  profile1();
                                });
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            void Function(void Function())
                                                setState) {
                                          Future<void> coin_transfer(
                                              String coin) async {
                                            var response = await post(
                                                Uri.parse(
                                                    "https://mechodalgroup.xyz/whoclone/api/coin.php"),
                                                body: {
                                                  'wallet_coin':
                                                      coin.toString(),
                                                  'user_id': uid.toString(),
                                                  'host_id':
                                                      widget.callID.toString()
                                                });
                                            if (response.statusCode == 200) {
                                              var data = jsonDecode(
                                                  response.body.toString());
                                              print("faudgdgdgdgdgdgkur");
                                              print(data);
                                              messege = (data['message']);

                                              if (messege ==
                                                  'Coins transferred successfully.') {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Coins transferred successfully");
                                                setState(() {
                                                  controller.harsh();
                                                  profile1();
                                                });
                                              } else if (messege ==
                                                  "Insufficient coins in the user's wallet.") {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Insufficient coins in the user's wallet");
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Please try again");
                                              }
                                            } else {
                                              print("Invalid Input");
                                            }
                                          }

                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .45,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 20),
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .06,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .28,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffE32753),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      15.0),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          15.0),
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Image.asset(
                                                                "assets/mo.png",
                                                                height: 30,
                                                                width: 30,
                                                              ),
                                                              Text(
                                                                data!.data![0]
                                                                    .walletCoin
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 30),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .37,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1,
                                                  color: Color(0xffEDEEF1),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    primary: true,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisSpacing: 5,
                                                      mainAxisSpacing: 5,
                                                      crossAxisCount: 4,
                                                      childAspectRatio:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  0.3),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                            vertical: 5),
                                                    itemCount:
                                                        planres['gift'].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GridTile(
                                                        child: InkWell(
                                                          onTap: () {
                                                            coin_transfer(
                                                                planres['gift'][
                                                                            index]
                                                                        ['coin']
                                                                    .toString());
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4,
                                                                    vertical:
                                                                        5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius:
                                                                      30, // Adjust the radius to control the size of the avatar
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white, // Set the background color of the avatar
                                                                  child:
                                                                      ClipOval(
                                                                    child: Image
                                                                        .network(
                                                                      planres['gift'][index]
                                                                              [
                                                                              'photo']
                                                                          .toString(),
                                                                      width: 60,
                                                                      height:
                                                                          60,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/mo.png",
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      planres['gift'][index]
                                                                              [
                                                                              'coin']
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    });
                              },
                              child: Image.asset(
                                "assets/img_19.png",
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
              color: Color(0xffFF85A6),
            )),
    );
  }
}
