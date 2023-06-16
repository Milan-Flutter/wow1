import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wow/constant.dart';

import 'landing.dart';

class onbording extends StatefulWidget {
  const onbording({Key? key}) : super(key: key);

  @override
  State<onbording> createState() => _onbordingState();
}

class _onbordingState extends State<onbording> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/img.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Image.asset(
              'assets/img_3.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .1),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Text(
                            "Let’s do \nsomething together",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff333333)),
                          ),
                          Text(
                            "Star conversation Now with each other",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, color: Color(0xff333333)),
                          ),
                        ],
                      )),
                  SizedBox(height: MediaQuery.of(context).size.height * .02),
                  Image.asset("assets/img_2.png"),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: landing()));
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            s_color,
                            main_color,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

