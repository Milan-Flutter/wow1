import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wow/View/name.dart';
import 'package:wow/View/sign_in.dart';
import 'package:wow/constant.dart';

class landing extends StatefulWidget {
  const landing({Key? key}) : super(key: key);

  @override
  State<landing> createState() => _landingState();
}

class _landingState extends State<landing> {
  final List<String> imagesList = [
    'assets/img_4.png',
    'assets/img_4.png',
    'assets/img_4.png',
  ];
  int _current = 0;
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/img_3.png', // replace with your image path
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .1),
                    CarouselSlider(
                      items: imagesList.map((imageUrl) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(
                                imageUrl,
                              ),
                              fit: BoxFit.fill,
                              // set the height to 200 pixels
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 17,
                        autoPlayInterval: Duration(seconds: 2),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        enableInfiniteScroll: true,
                        pauseAutoPlayOnTouch: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imagesList.map((imageUrl) {
                        int index = imagesList.indexOf(imageUrl);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current != index
                                ? Colors.white
                                : Color(0xffFF85A6),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .05),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: s_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: name(
                                    mobile_num: "",
                                    status: '2',
                                  )));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * .06,
                          width: MediaQuery.of(context).size.width * .7,
                          child: Center(
                            child: Text(
                              'Fast Login',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Text(
                      "OR",
                      style: TextStyle(color: Color(0xff73665C)),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: main_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: SignIn()));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * .06,
                          width: MediaQuery.of(context).size.width * .7,
                          child: Center(
                            child: Text(
                              'Already a member ? Login',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Terms of use",
                          style: TextStyle(color: s_color, fontSize: 12),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .09),
                        TextButton(
                          onPressed: () {
                            _launchURL('https://www.mechodal.com/');
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(color: s_color, fontSize: 12),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
