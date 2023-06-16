import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../Api/All_Data.dart';
import '../../../Controller/profile_data.dart';
import '../../../Model/All_Data.dart';
import '../../../constant.dart';
import '../../bottom_navigation.dart';
import '../live_stream_page.dart';

class live_page_user extends StatefulWidget {
  const live_page_user({Key? key}) : super(key: key);

  @override
  State<live_page_user> createState() => _live_page_userState();
}

class HostLive {
  final String name;
  final String id;
  final String photo;



  HostLive({required this.name, required this.id,required this.photo});
}

class _live_page_userState extends State<live_page_user> {
  List<HostLive> hosts = [];
  profile_data controller=Get.put(profile_data());
  List<HostLive> filteredHosts = [];
  late Map planres;

  String? coin;
  String? uid;
  String? uname;
  String? LiveId;
  Future<void> plan1() async {
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_host_active.php');
    var response = await post(url);
    if (response.statusCode == 200) {
      setState(() {
        planres=json.decode(response.body);
        for (int i = 0; i < planres['active'].length; i++) {
          HostLive host = HostLive(
            name: planres['active'][i]['name'].toString(),
            id: planres['active'][i]['id'].toString(),
            photo: planres['active'][i]['photo_url'].toString(),
          );
          hosts.add(host);
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




  _popUpEnter() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (BuildContext context) {
          return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .6,
                    margin: EdgeInsets.symmetric(horizontal: 16,),
                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: 25),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      color: Color(0xffE32753)
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black38,
                                radius: 20,
                                child: Center(
                                  child: Icon(Icons.close,color: Colors.white,),
                                ),
                              ),
                            )
                          ],
                        ),
                        Image.asset("assets/img_22.png",height: 200,width: 200,),
                        Text("This Stream may be appropriate for some viewer ",textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w500),),
                        Image.asset("assets/img_23.png",height: 90,width: 60,),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton
                                .styleFrom(
                              primary:
                              Color(0xffE32753),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(20),
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              joinLive();
                            },
                            child: Container(
                              height: MediaQuery.of(
                                  context)
                                  .size
                                  .height *
                                  .05,
                              width: MediaQuery.of(
                                  context)
                                  .size
                                  .width *
                                  .5,
                              child: Center(
                                child: Text(
                                  'Send And Enter',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                    Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Other child widgets here
                  ),
                ),
              );

        });
  }


  @override
  void initState() {

    coin=controller.coin.toString();
    uid=controller.uid.toString();
    uname=controller.name.toString();
    plan1();
    filteredHosts = hosts;


    super.initState();
  }


  Future<void> joinLive()
  async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/coin.php"),
        body: {'wallet_coin': "90",'user_id':uid.toString() , 'host_id': LiveId.toString()});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print("faudgdgdgdgdgdgkur");
      print(data);
      var messege = (data['message']);


      if (messege == 'Coins transferred successfully.')
      {
        setState(() {

          pushNewScreen( context,
            screen: live_Stream(id: uid.toString(), name: uname.toString(), liveid: LiveId.toString(), host: false,),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation .cupertino,
          );
        });

      }
      else if(messege =="Insufficient coins in the user's wallet.")
      {
        
        Fluttertoast.showToast(msg: "Insufficient coins in the user's wallet");
     }
      else {
        Fluttertoast.showToast(msg: "Please try again");
      }

    } else {
      print("Invalid Input");
    }
  }
  Future<void> _refreshData() async
  {  hosts.clear();
  filteredHosts.clear();
    plan1();
    filteredHosts = hosts;
    setState(() {

    });


  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFE8EB),
        body:  RefreshIndicator(
          onRefresh: _refreshData,
          color: main_color,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .1,),
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
                          hintStyle: TextStyle(fontSize: 12, color: Color(0xff3F2D20)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xffE8E6EA), // Set the border color when the TextField is focused
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(0xffE8E6EA), // Set the border color when the TextField is focused
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                      child: GridView.builder(
                        shrinkWrap: true,
                        primary: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width/(MediaQuery.of(context).size.height /1.5),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        /*itemCount: getpo!.data!.length +1,*/
                        itemCount: filteredHosts.length,
                        itemBuilder: (context, index) {
                          return GridTile(
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    LiveId=filteredHosts[index].id.toString();
                                    _popUpEnter();
                                  });

                                  },
                                child: Stack(
                                  children: [
                                    Container(

                                      width: 170,
                                      height: 242,

                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4.0,

                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(filteredHosts[index].photo.toString()), // Replace with your photo path
                                            fit: BoxFit.cover,
                                          ),



                                          borderRadius: BorderRadius.circular(20)
                                      ),

                                    ),
                                    Container(

                                      width: 170,
                                      height: 242,

                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4.0,

                                          ),
                                          gradient: LinearGradient(
                                            begin:  Alignment(.7,1),
                                              colors: [main_color,Colors.transparent]

                                          ),


                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 16),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 5,
                                                      backgroundColor: Colors.red,
                                                    ),
                                                    SizedBox(width: 5,),
                                                    Text("Live",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white),)
                                                  ],
                                                ),
                                                SizedBox(height: 120,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(filteredHosts[index].name,maxLines:1,


                                                      style:TextStyle(fontWeight: FontWeight.w600,fontSize: 17,color: Colors.white),),
                                                    Text("Available",style:TextStyle(fontSize: 12,color: Colors.white),)
                                                  ],
                                                )

                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          );
                        },
                      ))

                ],
              ),
          ),
        )

      ),
    );
  }
}
/*
Padding(
padding: const EdgeInsets.all(16.0),
child: TextField(
onChanged: (value) {
filterHosts(value);
},
decoration: InputDecoration(
labelText: 'Search',
border: OutlineInputBorder(),
),
),
),
Expanded(
child: ListView.builder(
itemCount: filteredHosts.length,
itemBuilder: (BuildContext context, int index) {
return ListTile(
title: Text(
filteredHosts[index].name,
),
subtitle: Text(
'ID: ${filteredHosts[index].id}',
),
);
},
),
),*/
