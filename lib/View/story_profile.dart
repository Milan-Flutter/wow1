import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/Api/story.dart';
import 'package:wow/View/story_page.dart';
import 'package:wow/constant.dart';
import '../Api/All_Data.dart';
import '../Api/post.dart';
import '../Controller/profile_data.dart';
import '../Model/All_Data.dart';
import '../Model/post.dart';
import '../Model/story.dart';
import 'Video_Call/call_page.dart';

class st_profile extends StatefulWidget {
  const st_profile({Key? key,required this.id}) : super(key: key);
  final String? id;

  @override
  State<st_profile> createState() => _st_profileState();
}
class Story {
  final String imageUrl;


  Story({required this.imageUrl});
}
class _st_profileState extends State<st_profile> {

  String? uid;
  var planres;
  getStory? getst;
  getpost? getpo;
  AllData? data1;

  String? name;
  bool st = false;
  bool po=false;
  bool all=false;
  bool abc=true;
  String? messege;
  bool follow = true;
  bool chat=false;
  profile_data controller=Get.put(profile_data());

  void gp()
  {
    getpost1().getpo1(id: widget.id.toString()).then((value) {
      getpo=value;
      setState(() {

        if( getpo!.data!.length == null)
        {
          debugPrint("llslsjsj");
          abc=true;
        }
        else
        {
          po=true;
          debugPrint("llslsjsj1");
        }

      });
    });

  }



  void gs()
  {
    getstory().getst1(id: widget.id.toString()).then((value) {
      getst=value;
      setState(() {
        st=true;
      });
    });
  }

  void profile()
  {

    userData().data3(id: widget.id.toString()).then((value) {
      data1=value;
      setState(() {
        all=true;

      });

    });

  }



  Future<void> Follow()
  async {
    debugPrint("object"+uid.toString());
    debugPrint("object"+widget.id.toString());

  var response = await post(
      Uri.parse("https://mechodalgroup.xyz/whoclone/api/follower.php"),
      body: {'follower_id': uid.toString(), 'following_id': widget.id.toString()});
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body.toString());
    print(data);
    messege = (data['message']);


    if (messege == 'Follower added successfully')
    {
      setState(() {
        follow=false;
        profile();

      });

    }else {
      Fluttertoast.showToast(msg: "Please try again");
    }

  } else {
    debugPrint("Invalid Input");
  }
}

  Future<void> coin_chat()
  async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/coin.php"),
        body: {'wallet_coin': "90",'user_id':uid.toString() , 'host_id': widget.id.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      debugPrint("faudgdgdgdgdgdgkur");
      print(data);
      var messege = (data['message']);


      if (messege == 'Coins transferred successfully.')
      {
        add_Chat();
        controller.harsh();
      }
      else if(messege =="Insufficient coins in the user's wallet.")
      {
        Fluttertoast.showToast(msg: "Insufficient coins in the user's wallet");
        Navigator.pop(context);
      }
      else {
        Fluttertoast.showToast(msg: "Please try again");
      }

    } else {
      debugPrint("Invalid Input");
    }
  }

  Future<void> coin_call()
  async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/coin.php"),
        body: {'wallet_coin': "120",'user_id':uid.toString() , 'host_id': widget.id.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      var messege = (data['message']);


      if (messege == 'Coins transferred successfully.')
      {
        Fluttertoast.showToast(msg: "Coins transferred successfully.");
        controller.harsh();
        Add_call();

      }
      else if(messege =="Insufficient coins in the user's wallet.")
      {
        Fluttertoast.showToast(msg: "Insufficient coins in the user's wallet");
        Navigator.pop(context);
      }
      else {
        Fluttertoast.showToast(msg: "Please try again");
      }

    } else {
      debugPrint("Invalid Input");
    }
  }


  Future<void> Add_call()
  async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/video_history.php"),
        body: {'user_id': uid.toString(), 'host_id': widget.id.toString()});

    if(response.statusCode == 200)
      {
        var data = jsonDecode(response.body.toString());
        print(data);
        debugPrint("lkhhznjfhfnzdn");
        messege = (data['message']);
        if(messege ==  " added successfully. Notification sent.")
          {
            Navigator.of(context);


            pushNewScreen( context,
              screen:MyCall(
                Username: name.toString(),
                userID: uid.toString(),
                callID: widget.id.toString(),
                privet: true,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation .cupertino,
            );
          }
        else
          {
            Fluttertoast.showToast(msg: "User are not Online!!");
          }

      }

  }


  _chatDailog()
  async {
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
                  padding: EdgeInsets.only(top: 22,bottom: 15),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Scaffold(
                    body: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width * .3,
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 7),
                              decoration: BoxDecoration(
                                color: main_color,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "My Coins",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/mo.png",height: 25,width: 25,),
                                      SizedBox(width: 10,),
                                      Text(controller.coin.toString(), style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 35,),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [


                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30),
                                    child: Column(
                                      children: [
                                        Text("Buy more coins to send more message",style: TextStyle(

                                            color: Color(0xff333333),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),textAlign: TextAlign.center,),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "When you send message each New",
                                          style: TextStyle(
                                            color: main_color,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: 60),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Person costs ",
                                                style: TextStyle(
                                                  color: main_color,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Image.asset("assets/mo.png",height: 15,width: 15,),
                                              Text(
                                                "90 Coin",
                                                style: TextStyle(
                                                  color: main_color,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 50,),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(
                                          color:s_color,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // Do something
                                    },
                                    child: Container(
                                      height:
                                      MediaQuery.of(context).size.height * .05,
                                      width: MediaQuery.of(context).size.width * .25,

                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: s_color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(
                                          color:main_color,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      coin_chat();
                                      Navigator.pop(context); // Do something
                                    },
                                    child: Container(
                                      height:
                                      MediaQuery.of(context).size.height * .05,
                                      width: MediaQuery.of(context).size.width * .25,

                                      child: Center(
                                        child: Text(
                                          'Purchase',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: main_color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  _callDailog()
  async {
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
                  padding: EdgeInsets.only(top: 22,bottom: 15),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Scaffold(
                    body: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width * .3,
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 7),
                              decoration: BoxDecoration(
                                color: main_color,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "My Coins",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/mo.png",height: 25,width: 25,),
                                      SizedBox(width: 10,),
                                      Text(controller.coin.toString(), style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage("assets/img_31.png"),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      children: [
                                        Text("PRIVATE CALL",style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "It Costs ",
                                              style: TextStyle(
                                                color: main_color,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Row(

                                              children: [
                                                Image.asset("assets/mo.png",height: 15,width: 15,),
                                                Text(
                                                  "120 / Minute",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              " to make a private",
                                              style: TextStyle(
                                                color: main_color,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: 20),
                                          child: Text("call. Calls shorter than one minute are rounded to one minute",      textAlign: TextAlign.center,style: TextStyle(
                                            color: main_color,
                                            fontSize: 12,
                                          ),),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(
                                          color:s_color,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // Do something
                                    },
                                    child: Container(
                                      height:
                                      MediaQuery.of(context).size.height * .05,
                                      width: MediaQuery.of(context).size.width * .25,

                                      child: Center(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: s_color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        side: BorderSide(
                                          color:main_color,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      coin_call();
                                    },
                                    child: Container(
                                      height:
                                      MediaQuery.of(context).size.height * .05,
                                      width: MediaQuery.of(context).size.width * .25,

                                      child: Center(
                                        child: Text(
                                          'Continue',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: main_color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Future<void> Unfollow()
  async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/un_follower.php"),
        body: {'follower_id': widget.id.toString(), 'following_id': uid.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      messege = (data['message']);


      if (messege == 'User unfollowed successfully')
      {
        setState(() {
          follow=true;
          profile();

        });

      }else {
        Fluttertoast.showToast(msg: "Please try again");
      }

    } else {
      debugPrint("Invalid Input");
    }
  }

  Future<void> add_Chat()
  async {

    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/add_chat.php"),
        body: {'followerId': uid.toString(), 'followingId': widget.id.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      var messege = (data['message']);


      if (messege == 'Chat added successfully')
      {
        setState(() {
          chat=false;
        });
        Fluttertoast.showToast(msg: "This Account is Added for Chat");


      }else if(messege == "Chat already exists")
      {


      }


    } else {
      debugPrint("Invalid Input");
    }





  }


  Future<void> check_Chat()
  async {

   debugPrint("dvjdvdsga;sD");
   debugPrint(uid.toString());
   debugPrint(widget.id.toString());

   var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/check_chat.php"),
        body: {'followerId': widget.id.toString(), 'followingId': uid.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      debugPrint("HAFJKAFafAW");
      print(data);
      var messege = (data['message']);


      if (messege == 'Alredey Exist')
      {
        setState(() {
          chat=false;
        });

      }else if(messege == "User is not Exist")
      {
        setState(() {
            chat=true;
        });

      }


    } else {
      debugPrint("Invalid Input");
    }


   check_followe();


  }

  Future<void> check_followe()
  async {

    debugPrint("khadhd");
    debugPrint(uid.toString());
    debugPrint(widget.id.toString());

    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/check_follower.php"),
        body: {'user_id': uid.toString(), 'host_id': widget.id.toString()});
    print({'user_id': uid.toString(), 'host_id': widget.id.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      debugPrint("HAFJKAFafAW");
      print(data);
      var messege = (data['status']);



      if (messege == 'success')
      {
        setState(() {
          follow=false;
        });

      }else if(messege == "error")
      {
        setState(() {
          follow=true;
        });

      }

  }

    @override
    void initState() {
      uid=controller.uid.toString();
      check_Chat();
      check_followe();
      profile();
      gs();
      gp();



      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body:  all ? SafeArea(
            child:Stack(
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
                        SizedBox(height: MediaQuery.of(context).size.height * .05,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: MediaQuery.of(context).size.height * .06,
                                  width: MediaQuery.of(context).size.width *.13,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xffFFFFFF)

                                  ),
                                  child: Icon(Icons.arrow_back_ios_new_outlined,color: s_color,size: 15,),
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * .3,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("ID: ",style:TextStyle(fontSize: 12,color: main_color),),
                                  Text(data1!.data![0].id.toString(),style: TextStyle(fontSize: 12,color: Color(0xff73665C)),),

                                ],),

                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .03,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [

                              CircleAvatar(
                                radius: 45.0, // Adjust the radius according to your desired size
                                backgroundImage: NetworkImage(data1!.data![0].photoUrl.toString()),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * .025,),
                              Expanded(
                                child: Container(


                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,                              children: [
                                    Row(
                                      children: [
                                        SizedBox(width: MediaQuery.of(context).size.height * .01,),
                                        Text(data1!.data![0].name.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Container(

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(

                                            child: Column(
                                              children: [
                                                Text(data1!.data![0].totalPost.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                                Text("Posts",style: TextStyle(fontSize: 12),)
                                              ],
                                            ),
                                          ),
                                          Container(


                                            child: Column(
                                              children: [
                                                Text(data1!.data![0].follower.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                                Text("Followers",style: TextStyle(fontSize: 12),)
                                              ],
                                            ),
                                          ),

                                          Container(
                                            child: Column(
                                              children: [
                                                Text(data1!.data![0].following.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                                Text("Following",style: TextStyle(fontSize: 12),)
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
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .03,),
                        Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: (){
                                  _callDailog();
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height * .06,
                                  width: MediaQuery.of(context).size.width* .55,
                                  padding: EdgeInsets.only(right: 10,left: 5),
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
                                      Image.asset("assets/img_16.png",height: 30,width: 30,),
                                      SizedBox(width: 10,),
                                      Text("Video Chat",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                              chat?InkWell(
                                onTap: (){
                                  _chatDailog();
                                },
                                child: Image.asset("assets/img_17.png",height: 50,width: 50,),
                              ):Image.asset("assets/img_33.png",height: 50,width: 50,),

                              follow ?InkWell(
                                onTap: (){
                                  Follow();
                                },
                                child: Image.asset("assets/img_18.png",height: 50,width: 50,),
                              ) :InkWell(
                                onTap: (){
                                  Unfollow();
                                },
                                child: Image.asset("assets/img_10.png",height: 50,width: 50,),
                              )

                            ],
                          ),
                        ),


                        SizedBox(height: MediaQuery.of(context).size.height * .03,),

                        Container(
                          height: 115,
                          margin: EdgeInsets.symmetric(horizontal: 16),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Stories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  st ?Container(
                                    width: MediaQuery.of(context).size.width * .9,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      height: 70,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: getst!.data!.length,
                                        /*        itemCount: 2,*/
                                        itemBuilder: (BuildContext context, int index) {
                                          return InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType.topToBottom,
                                                      child: story_view_page(emg: getst!.data![index].link.toString(),)));
                                            } ,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Color(0xffC7C7CC),
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(2),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                      NetworkImage(getst!.data![index].link.toString()),
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
                                  ) : Container(),
                                ],
                              ),
                            ],
                          ),

                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * .01,),
                        Container(   margin: EdgeInsets.symmetric(horizontal: 16),child: Text("Photos",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))),
                        SizedBox(height: MediaQuery.of(context).size.height * .01,),

                        po ?Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              primary: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio: MediaQuery.of(context).size.width/(MediaQuery.of(context).size.height /2),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                              itemCount: getpo!.data!.length,
                              itemBuilder: (context, index) {
                                return GridTile(
                                    child:Container(

                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xffC7C7CC),
                                            width: 2.0,

                                          ),
                                          image: DecorationImage(
                                              image: NetworkImage(getpo!.data![index].link.toString()),
                                              fit: BoxFit.cover



                                          ),
                                          borderRadius: BorderRadius.circular(20)
                                      ),

                                    )
                                )  ;
                              },
                            )):
                        Container()






                      ],
                    ),
                  ),
                )

              ],
            )
        ) :Center(
            child: CircularProgressIndicator(
              color: s_color,
            )),
      );
    }
  }

  @override
  void initState()
  {
    uid=controller.uid.toString();
    check_Chat();
    profile();
    gs();
    gp();



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body:  all ? SafeArea(
          child:Stack(
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
                      SizedBox(height: MediaQuery.of(context).size.height * .05,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                height: MediaQuery.of(context).size.height * .06,
                                width: MediaQuery.of(context).size.width *.13,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xffFFFFFF)

                                ),
                                child: Icon(Icons.arrow_back_ios_new_outlined,color: s_color,size: 15,),
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * .3,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("ID: ",style:TextStyle(fontSize: 12,color: main_color),),
                                Text(data1!.data![0].id.toString(),style: TextStyle(fontSize: 12,color: Color(0xff73665C)),),

                              ],),

                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .03,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [

                            CircleAvatar(
                              radius: 45.0, // Adjust the radius according to your desired size
                              backgroundImage: NetworkImage(data1!.data![0].photoUrl.toString()),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * .025,),
                            Expanded(
                              child: Container(


                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,                              children: [
                                  Row(
                                    children: [
                                      SizedBox(width: MediaQuery.of(context).size.height * .01,),
                                      Text(data1!.data![0].name.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Container(

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(

                                          child: Column(
                                            children: [
                                              Text(data1!.data![0].totalPost.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                              Text("Posts",style: TextStyle(fontSize: 12),)
                                            ],
                                          ),
                                        ),
                                        Container(


                                          child: Column(
                                            children: [
                                              Text(data1!.data![0].follower.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                              Text("Followers",style: TextStyle(fontSize: 12),)
                                            ],
                                          ),
                                        ),

                                        Container(
                                          child: Column(
                                            children: [
                                              Text(data1!.data![0].following.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                              Text("Following",style: TextStyle(fontSize: 12),)
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
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .03,),
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                _callDailog();
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * .06,
                                width: MediaQuery.of(context).size.width* .55,
                                padding: EdgeInsets.only(right: 10,left: 5),
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
                                    Image.asset("assets/img_16.png",height: 30,width: 30,),
                                    SizedBox(width: 10,),
                                    Text("Video Chat",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),)
                                  ],
                                ),
                              ),
                            ),
                            chat?InkWell(
                              onTap: (){
                                _chatDailog();
                              },
                              child: Image.asset("assets/img_17.png",height: 50,width: 50,),
                            ):Image.asset("assets/img_33.png",height: 50,width: 50,),

                            follow ?InkWell(
                              onTap: (){
                                Follow();
                              },
                              child: Image.asset("assets/img_18.png",height: 50,width: 50,),
                            ) :InkWell(
                              onTap: (){
                                Unfollow();
                              },
                              child: Image.asset("assets/img_10.png",height: 50,width: 50,),
                            )

                          ],
                        ),
                      ),


                      SizedBox(height: MediaQuery.of(context).size.height * .03,),

                      Container(
                        height: 115,
                        margin: EdgeInsets.symmetric(horizontal: 16),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Stories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                st ?Container(
                                  width: MediaQuery.of(context).size.width * .9,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    height: 70,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: getst!.data!.length,
                                      /*        itemCount: 2,*/
                                      itemBuilder: (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType.topToBottom,
                                                    child: story_view_page(emg: getst!.data![index].link.toString(),)));
                                          } ,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color(0xffC7C7CC),
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(2),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(getst!.data![index].link.toString()),
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
                                ) : Container(),
                              ],
                            ),
                          ],
                        ),

                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .01,),
                      Container(   margin: EdgeInsets.symmetric(horizontal: 16),child: Text("Photos",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))),
                      SizedBox(height: MediaQuery.of(context).size.height * .01,),

                      po ?Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            primary: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context).size.width/(MediaQuery.of(context).size.height /2),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                            itemCount: getpo!.data!.length,
                            itemBuilder: (context, index) {
                              return GridTile(
                                  child:Container(

                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xffC7C7CC),
                                          width: 2.0,

                                        ),
                                        image: DecorationImage(
                                            image: NetworkImage(getpo!.data![index].link.toString()),
                                            fit: BoxFit.cover



                                        ),
                                        borderRadius: BorderRadius.circular(20)
                                    ),

                                  )
                              )  ;
                            },
                          )):
                      Container()






                    ],
                  ),
                ),
              )

            ],
          )
      ) :Center(
          child: CircularProgressIndicator(
            color: s_color,
          )),
    );
  }
}

