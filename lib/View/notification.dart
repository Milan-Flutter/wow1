import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../constant.dart';

class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  late Map map;
  bool isloding = false;
  Future<void> GetDAta() async {
    var url = Uri.parse(
        'https://mechodalgroup.xyz/whoclone/api/get_notification.php');
    var response = await get(url);
    if (response.statusCode == 200) {
      setState(() {
        map = jsonDecode(response.body);
        isloding = true;
      });
    }
  }

  @override
  void initState() {
    GetDAta();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloding
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
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    color: s_color,
                                    size: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .02,
                              ),
                              Text(
                                "Notification",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          ListView.builder(
                            itemCount: map['notification'].length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: main_color.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      map['notification'][index]['title']
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: main_color),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      map['notification'][index]['discription']
                                          .toString(),
                                      maxLines: 7,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: s_color,
              ),
            ),
    );
  }
}
