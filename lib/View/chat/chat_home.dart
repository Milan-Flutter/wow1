import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:wow/constant.dart';
import '../../Controller/profile_data.dart';
import '../../services/push_notification.dart';
import 'room_chat.dart';

class chat_home extends StatefulWidget {
  const chat_home({Key? key}) : super(key: key);

  @override
  State<chat_home> createState() => _chat_homeState();
}

class HostLive {
  final String name;
  final String id;
  final String f_id;
  final String photo;
  final String email;

  HostLive(
      {required this.name,
      required this.id,
      required this.f_id,
      required this.photo,
      required this.email});
}

class _chat_homeState extends State<chat_home> {
  List<HostLive> hosts = [];
  List<HostLive> filteredHosts = [];
  var userMap;

  late Map planres;
  String? type;
  String? f_uid;
  String? uid;
  String? host_id;
  Future<void> plan1() async {
    print(uid.toString());
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/get_chat.php"),
        body: {'id': uid.toString()});
    if (response.statusCode == 200) {
      setState(() {
        planres = json.decode(response.body);
        print(planres.toString());
        for (int i = 0; i < planres['records'].length; i++) {
          HostLive host = HostLive(
            name: planres['records'][i]['name'].toString(),
            id: planres['records'][i]['id'].toString(),
            f_id: planres['records'][i]['f_id'].toString(),
            photo: planres['records'][i]['photo_url'].toString(),
            email: planres['records'][i]['email'].toString(),
          );
          hosts.add(host);
          print("yagugo8t");
          print(hosts.toString());
        }
      });
    }
  }

  profile_data controller = Get.put(profile_data());

  void filterHosts(String searchTerm) {
    setState(() {
      filteredHosts = hosts
          .where((host) =>
              host.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  String chatRoomId(String user1, String user2) {
    print("object" + user1.toString());
    print("object" + user2.toString());

    if (type == "0") {
      return "$user2$user1";
    } else {
      return "$user1$user2";
    }
  }

  @override
  void initState() {

    uid = controller.uid.toString();
    type = controller.type.toString();
    f_uid = controller.f_id.toString();
    plan1();
    filteredHosts = hosts;
    super.initState();
  }

  void onSearch(String Email, f_id) async {
    print("jzghskdryhdhtdt");
    print(f_id.toString());
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('users')
        .where("w_id", isEqualTo: f_id)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
      print("ujAFHLIS");
      print(userMap);
    });

    String roomId = chatRoomId(uid.toString(), f_id.toString());
    print("kiutvjorjg" + roomId.toString());

    pushNewScreen(
      context,
      screen: ChatRoom(
        chatRoomId: roomId,
        userMap: userMap!,
      ),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      hosts.clear();
      filteredHosts.clear();
      plan1();

      filteredHosts = hosts;
    });
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
        backgroundColor: Color(0xffFFE8EB),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: main_color,
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE8E6EA).withOpacity(.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          filterHosts(value);
                        },
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_sharp),
                          hintText: 'Search',
                          hintStyle:
                              TextStyle(fontSize: 12, color: Color(0xff3F2D20)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(
                                  0xffE8E6EA), // Set the border color when the TextField is focused
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(
                                  0xffE8E6EA), // Set the border color when the TextField is focused
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    itemCount: filteredHosts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return filteredHosts.length == 0
                          ? Container(
                              height: MediaQuery.of(context).size.height * .6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "User Not Found!",
                                    style: TextStyle(
                                        color: main_color,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * .06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: s_color.withOpacity(.3),
                              ),
                              child: InkWell(
                                onTap: () {
                                  onSearch(
                                      filteredHosts[index].email.toString(),
                                      filteredHosts[index].id.toString());
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        filteredHosts[index].photo == null?  CircleAvatar(
                                          radius:
                                              20.0, // Adjust the radius according to your desired size
                                    backgroundImage: AssetImage("assets/img_10.png"),
                                        ) :CircleAvatar(
                                          radius:
                                          20.0, // Adjust the radius according to your desired size
                                          backgroundImage: NetworkImage(
                                              filteredHosts[index]
                                                  .photo
                                                  .toString()),
                                        ) ,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .56,
                                          child: Text(
                                            filteredHosts[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor:
                                            s_color.withOpacity(.3),
                                        child: Image.asset(
                                          "assets/img_29.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                ],
              )),
        ));
  }
}
