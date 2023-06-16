import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/Api/story.dart';
import 'package:wow/View/sign_in.dart';
import 'package:wow/View/story_page.dart';
import 'package:http/http.dart' as http;
import 'package:wow/constant.dart';

import '../Api/All_Data.dart';
import '../Api/post.dart';

import '../Controller/profile_data.dart';
import '../Model/All_Data.dart';
import '../Model/post.dart';
import '../Model/story.dart';
import 'Edit_profile.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  File? _pickedImage;
  File? _compressedImage;
  final _picker = ImagePicker();
  String? uid;
  var planres;
  profile_data controller = Get.put(profile_data());

  getStory? getst;
  getpost? getpo;
  AllData? data1;

  bool st = false;
  bool po = false;
  bool all = false;
  bool abc = true;
  bool host = false;

  Future<void> sendPost(File imageFile) async {
    debugPrint("qq" + imageFile.toString());
    Uri apiUrl = Uri.parse('https://mechodalgroup.xyz/whoclone/api/post.php');
    var request = http.MultipartRequest('POST', apiUrl);

    request.files.add(
        await http.MultipartFile.fromPath('link', imageFile.path.toString()));
    request.fields['user_id'] = uid.toString();
    var response = await request.send();

    if (response.statusCode == 200) {
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);

      debugPrint('rrre' + responseData.toString());
      Fluttertoast.showToast(msg: "Add Post Succesfully");
      setState(() {
        gp();
      });
    } else {
      debugPrint('Error submitting form data: ${response.statusCode}');
      Fluttertoast.showToast(msg: "Post was not Added ");
    }
  }

  Future<void> sendStrory(File imageFile) async {
    debugPrint("qq" + imageFile.toString());
    Uri apiUrl = Uri.parse('https://mechodalgroup.xyz/whoclone/api/story.php');
    var request = http.MultipartRequest('POST', apiUrl);

    request.files.add(
        await http.MultipartFile.fromPath('link', imageFile.path.toString()));
    request.fields['user_id'] = uid.toString();
    var response = await request.send();

    if (response.statusCode == 200) {
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      setState(() {
        gs();
      });
      debugPrint('rrre' + responseData.toString());
      Fluttertoast.showToast(msg: "Add Strory Succesfully");
    } else {
      debugPrint('Error submitting form data: ${response.statusCode}');
      Fluttertoast.showToast(msg: "Strory was not Added ");
    }
  }

  Future<void> _getImage() async {
    debugPrint("objectlllllllllllllll");
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      sendPost(_pickedImage!);
    }
  }

  Future<void> _getImage1() async {
    debugPrint("objectlllllllllllllll");
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
      sendStrory(_pickedImage!);
    }
  }
  void gp() {
    getpost1().getpo().then((value) {
      getpo = value;
      setState(() {
        po = true;
        if (getpo!.data!.length == null) {
          setState(() {
            abc = true;
          });
        } else {
          setState(() {
            abc = false;
          });
        }
      });
    });
  }

  void gs() {
    getstory().getst().then((value) {
      getst = value;
      setState(() {
        st = true;
      });
    });
  }

  void profile() {
    userData().data().then((value) {
      data1 = value;
      setState(() {
        if (data1!.data![0].type.toString() == "0") {
          host = true;
        }

        all = true;
      });
    });
  }

  @override
  void initState() {
    uid = controller.uid.toString();
    profile();
    gs();
    gp();

    super.initState();
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    GoogleSignIn _googleSignIn = GoogleSignIn();
    FirebaseAuth.instance.signOut();

    _googleSignIn.signOut();
    Navigator.push(context,
        PageTransition(type: PageTransitionType.topToBottom, child: SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: all
          ? SafeArea(
              child: Stack(
              children: [
                Image.asset(
                  'assets/all.png', // replace with your image path
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  width:
                                      MediaQuery.of(context).size.width * .13,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xffFFFFFF)),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Color(0xffFF85A6),
                                    size: 15,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "ID: ",
                                    style: TextStyle(
                                        fontSize: 12, color: main_color),
                                  ),
                                  Text(
                                    uid.toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xff73665C)),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  logout();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  width:
                                      MediaQuery.of(context).size.width * .13,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xffFFFFFF)),
                                  child: Icon(
                                    Icons.logout,
                                    color: Color(0xffFF85A6),
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        Obx(() {
                          return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius:
                                      45.0, // Adjust the radius according to your desired size
                                  backgroundImage: NetworkImage(
                                      controller.photourl.toString()),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .025,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .01,
                                            ),
                                            Text(
                                              controller.name.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      controller.post
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      "Posts",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      controller.follow
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      "Followers",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      controller.following
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      "Following",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        host
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.topToBottom,
                                          child: host_edit()));
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  width: MediaQuery.of(context).size.width * .5,
                                  padding: EdgeInsets.only(right: 10, left: 5),
                                  decoration: BoxDecoration(
                                    color: main_color,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/img_24.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        Container(
                          height: 115,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Stories",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xffC7C7CC),
                                            width: 2.0,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            _getImage1();
                                          },
                                          child: CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "New",
                                        style:
                                            TextStyle(color: Color(0xff262626)),
                                      )
                                    ],
                                  ),
                                  st
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .73,
                                          child: Container(
                                            decoration: BoxDecoration(),
                                            height: 70,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: getst!.data!.length,
                                              /*        itemCount: 2,*/
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .topToBottom,
                                                            child:
                                                                story_view_page(
                                                              emg: getst!
                                                                  .data![index]
                                                                  .link
                                                                  .toString(),
                                                            )));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Color(
                                                                  0xffC7C7CC),
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(getst!
                                                                    .data![
                                                                        index]
                                                                    .link
                                                                    .toString()),
                                                            radius: 30,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text("Photos",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 2),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              /*itemCount: getpo!.data!.length +1,*/
                              itemCount: abc ? 1 : getpo!.data!.length + 1,
                              itemBuilder: (context, index) {
                                return GridTile(
                                    child: index == 0
                                        ? InkWell(
                                            onTap: () {
                                              _getImage();
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xffC7C7CC),
                                                    width: 2.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Color(0xff262626),
                                                  size: 100,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xffC7C7CC),
                                                  width: 2.0,
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(getpo!
                                                        .data![index - 1].link
                                                        .toString()),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ));
                              },
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ))
          : Center(
              child: CircularProgressIndicator(
              color: s_color,
            )),
    );
  }
}
