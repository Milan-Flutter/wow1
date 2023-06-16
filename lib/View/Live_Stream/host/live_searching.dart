import 'package:flutter/material.dart';

import '../../../Api/All_Data.dart';
import '../../../Model/All_Data.dart';
import '../../bottom_navigation.dart';

class host_live_searching extends StatefulWidget {
  const host_live_searching({Key? key}) : super(key: key);

  @override
  State<host_live_searching> createState() => _host_live_searchingState();
}

class _host_live_searchingState extends State<host_live_searching> {
  AllData? data;
  bool all = false;

  void profile1() {
    userData().data().then((value) {
      data = value;
      setState(() {
        all = true;
      });
    });
  }

  @override
  void initState() {
    profile1();
    super.initState();
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: MediaQuery.of(context).size.height * .06,
                            width: MediaQuery.of(context).size.width * .28,
                            padding: EdgeInsets.only(right: 10, left: 5),
                            decoration: BoxDecoration(
                              color: Color(0xffE32753),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/mo.png",
                                  height: 30,
                                  width: 30,
                                ),
                                Text(
                                  data!.data![0].walletCoin
                                      .toString()
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      InkWell(
                          onTap: () {},
                          child: Image.asset("assets/img_12.png")),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      Center(
                        child: Text(
                          "Searching..... ",
                          style: TextStyle(
                            color: Color(0xff73665C),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .04,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffE32753),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: () {
                            setState(() {});
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => botttom_navigate(
                                        button: "0",
                                      )),
                            );
                            // Navigator.pop(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .06,
                            width: MediaQuery.of(context).size.width * .3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Leave',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.logout)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
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
