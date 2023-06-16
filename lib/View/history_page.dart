import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:wow/constant.dart';

import '../Controller/profile_data.dart';
import '../services/push_notification.dart';

class history extends StatefulWidget {
  const history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _historyState();
}

class HostLive {
  final String name;
  final String id;
  final String photo;
  final String msg;
  HostLive(
      {required this.name,
      required this.id,
      required this.photo,
      required this.msg});
}

class _historyState extends State<history> {
  profile_data controller = Get.put(profile_data());
  var misscall;
  List<HostLive> hosts = [];

  int i = 1;
  bool miss = false;
  late Map data1;
  bool isloding = false;

  List<HostLive> filteredHosts = [];
  Future<void> plan1() async {
    print({'user_id', controller.uid.toString()});
    var response = await post(
        Uri.parse(
            "https://mechodalgroup.xyz/whoclone/api/video_history_user_id.php"),
        body: {'user_id': controller.uid.toString()});
    if (response.statusCode == 200) {
      setState(() {
        data1 = jsonDecode(response.body);
        print(data1);
        for (int i = 0; i < data1['data']['user_details'].length; i++) {
          HostLive host = HostLive(
            name: data1['data']['user_details'][i]['name'].toString(),
            id: data1['data']['user_details'][i]['id'].toString(),
            photo: data1['data']['user_details'][i]['photo_url'].toString(),
            msg: data1['data']['history'][i]['type'].toString(),
          );
          hosts.add(host);
          print("yagugo8t");
          print(hosts.toString());
          if (data1['data']['history'][i]['type'].toString() == "misscall") {
            filteredHosts.add(host);
          }
        }
        print("dkfhsedgsHgs");
        print(hosts.length);
        isloding = true;
      });
    }
  }

  @override
  void initState() {
    plan1();
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
      body: Stack(
        children: [
          Image.asset(
            'assets/all.png', // replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          isloding
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .07,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        i = 1;
                                        miss = false;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .07,
                                      decoration: BoxDecoration(
                                        color:
                                            i == 1 ? main_color : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          bottomLeft: Radius.circular(15.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "All",
                                          style: TextStyle(
                                              color: i == 1
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        i = 2;
                                        miss = true;
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .07,
                                      decoration: BoxDecoration(
                                        color:
                                            i == 2 ? main_color : Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15.0),
                                          bottomRight: Radius.circular(15.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Missed",
                                          style: TextStyle(
                                              color: i == 2
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
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
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        itemCount: miss ? filteredHosts.length : hosts.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          bool abc = false;

                          return miss
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  height:
                                      MediaQuery.of(context).size.height * .07,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: s_color.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            hosts[index].photo.toString()),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hosts[index].name,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          Text(
                                            "Missed Call",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.red),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  height:
                                      MediaQuery.of(context).size.height * .07,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: s_color.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            hosts[index].photo.toString()),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hosts[index].name,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          data1['data']['history'][index]
                                                      ['type'] ==
                                                  "misscall"
                                              ? Text(
                                                  "Missed Call",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red),
                                                )
                                              : Text(
                                                  "attendcall",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xff111A41)),
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                  "Data Not Found",
                  style: TextStyle(
                      color: main_color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
        ],
      ),
    );
  }
}
