import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../../Api/All_Data.dart';
import '../../Model/All_Data.dart';

class live_Stream extends StatefulWidget {
  const live_Stream(
      {Key? key,
      required this.id,
      required this.name,
      required this.liveid,
      required this.host})
      : super(key: key);

  final String? id;
  final String? name;
  final String? liveid;
  final bool host;
  @override
  State<live_Stream> createState() => _live_StreamState();
}

class _live_StreamState extends State<live_Stream> {
  AllData? data;
  String? type;
  bool isloding = false;
  bool gift = false;
  late Map planres;
  void profile1() {
    userData().data3(id: widget.id.toString()).then((value) {
      data = value;
      setState(() {
        type = data!.data![0].type.toString();
        if (type == "1") {
          gift1();
          gift = true;
        }

        isloding = true;
      });
    });
  }

  Future<void> gift1() async {
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_gift.php');
    Response response = await post(url);
    if (response.statusCode == 200) {
      setState(() {
        planres = json.decode(response.body);
      });
    }
  }

  void data1() {
    setState(() async {
      if (type == "0") {
        Response response = await post(
            Uri.parse(
                "https://mechodalgroup.xyz/whoclone/api/update_register_host_status.php"),
            body: {'id': widget.id.toString(), 'host_streem': "deactive"});
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          print("jkvbf;lsdhnsdthsd");
          print(data);
          var messege = (data['message']);
          if (messege == "Updated successfully") {
          } else {
            Fluttertoast.showToast(msg: "Please try again..");
          }
        }
      }
    });
  }

  @override
  void initState() {
    profile1();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloding
            ? WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: SafeArea(
                    child: Stack(
                  children: [
                    ZegoUIKitPrebuiltLiveStreaming(
                      appID: 444698846,
                      appSign:
                          'e61a178307c20d0092a1e5de9d6eb65344bc38da424b2ae073c27610133b2025',
                      userID: widget.id.toString(),
                      userName: widget.name.toString(),
                      liveID: widget.liveid.toString(),
                      config: widget.host
                          ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                          : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
                      onDispose: data1,
                    ),
                    gift
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 62, right: 16),
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
                                              Response response = await post(
                                                  Uri.parse(
                                                      "https://mechodalgroup.xyz/whoclone/api/coin.php"),
                                                  body: {
                                                    'wallet_coin':
                                                        coin.toString(),
                                                    'user_id':
                                                        widget.id.toString(),
                                                    'host_id':
                                                        widget.liveid.toString()
                                                  });
                                              if (response.statusCode == 200) {
                                                var data = jsonDecode(
                                                    response.body.toString());
                                                print("faudgdgdgdgdgdgkur");
                                                print(data);
                                                var messege = (data['message']);

                                                if (messege ==
                                                    'Coins transferred successfully.') {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Coins transferred successfully");
                                                  setState(() {
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
                                                            const EdgeInsets
                                                                    .only(
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
                                                                bottomRight: Radius
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 30),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .37,
                                                    width:
                                                        MediaQuery.of(context)
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
                                                            MediaQuery.of(
                                                                        context)
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
                                                      itemCount: planres['gift']
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GridTile(
                                                          child: InkWell(
                                                            onTap: () {
                                                              coin_transfer(planres[
                                                                          'gift']
                                                                      [
                                                                      index]['coin']
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
                                                                        planres['gift'][index]['photo']
                                                                            .toString(),
                                                                        width:
                                                                            60,
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
                                                                      Image
                                                                          .asset(
                                                                        "assets/mo.png",
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            30,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        planres['gift'][index]['coin']
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white),
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
                        : Container()
                  ],
                )),
              )
            : Center(
                child: CircularProgressIndicator(
                color: Color(0xffFF85A6),
              )));
  }
}
