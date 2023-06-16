import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:wow/Controller/folower_controller.dart';
import 'package:wow/View/story_profile.dart';

import '../Api/All_Data.dart';
import '../Controller/profile_data.dart';
import '../Model/All_Data.dart';
import '../constant.dart';

class followe_page extends StatefulWidget {
  const followe_page({Key? key}) : super(key: key);

  @override
  State<followe_page> createState() => _followe_pageState();
}

class HostLive {
  final String name;
  final String id;
  final String photo;

  HostLive({required this.name, required this.id, required this.photo});
}

class _followe_pageState extends State<followe_page> {
  List<HostLive> hosts = [];
  List<HostLive> filteredHosts = [];
  late Map planres;

  String? uid;
  profile_data controller = Get.put(profile_data());
  follwer controller1=Get.put(follwer());

  Future<void> plan1() async {
    print(uid.toString());
    var response = await post(
        Uri.parse(
            "https://mechodalgroup.xyz/whoclone/api/get_following_id.php"),
        body: {'id': uid.toString()});
    if (response.statusCode == 200) {
      setState(() {
        planres = json.decode(response.body);
        print(planres.toString());
        print("dhjbadgmsdg" + planres['records'].length.toString());
        if (planres['records'].length == 1) {
          fo = true;
        } else {
          for (int i = 0; i < planres['records'].length; i++) {
            HostLive host = HostLive(
              name: planres['records'][i]['name'].toString(),
              id: planres['records'][i]['id'].toString(),
              photo: planres['records'][i]['photo_url'].toString(),
            );
            hosts.add(host);
            print("yagugo8t");
            print(hosts.toString());
          }
        }
      });
    }
  }

  void filterHosts(String searchTerm) {
    setState(() {
      filteredHosts = hosts
          .where((host) =>
              host.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  bool fo = false;
  Future<void> _refreshData() async {
    hosts.clear();
    filteredHosts.clear();
    plan1();
    filteredHosts = hosts;
    setState(() {});
  }

  @override
  void initState() {
    plan1();
    uid = controller.uid.toString();
    filteredHosts = hosts;
    controller1.getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                            hintStyle: TextStyle(
                                fontSize: 12, color: Color(0xff3F2D20)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xffE8E6EA),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Color(0xffE8E6EA),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    fo
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
                            child: GridView.builder(
                            shrinkWrap: true,
                            primary: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 18,
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.5),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemCount: filteredHosts.length,
                            itemBuilder: (context, index) {
                              return index == filteredHosts.length - 1
                                  ? Container()
                                  : GridTile(
                                      child: InkWell(
                                      onTap: () {
                                        pushNewScreen(
                                          context,
                                          screen: st_profile(
                                            id: filteredHosts[index]
                                                .id
                                                .toString(),
                                          ),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      },
                                      child: Container(
                                        width: 170,
                                        height: 235,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 16),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4.0,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(filteredHosts[
                                                      index]
                                                  .photo
                                                  .toString()), // Replace with your photo path
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 3,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 3,
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 3,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 130,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  filteredHosts[index].name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Available",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                            },
                          ))
                  ],
                )),
          )),
    );
  }
}
