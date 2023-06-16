import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wow/View/i_am.dart';
import 'package:wow/View/mobile_num.dart';
import 'package:wow/constant.dart';

class name extends StatefulWidget {
  const name(
      {Key? key, required this.mobile_num, required this.status, this.email})
      : super(key: key);
  final String? mobile_num;
  final String? status;
  final String? email;
  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * .06,
                        width: MediaQuery.of(context).size.width * .13,
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
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 28,
                          color: Color(0xff111A41),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .015,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Your Your Name',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintStyle:
                              TextStyle(fontSize: 12, color: Color(0xff3F2D20)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: main_color)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color:
                                  main_color, // Set the border color when the TextField is focused
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .57,
                    ),
                    Align(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffE32753),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: i_am(
                                        mobile_num:
                                            widget.mobile_num.toString(),
                                        status: widget.status.toString(),
                                        name: _controller.text,
                                      )));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .8,
                              child: Center(
                                child: Text(
                                  'Continue',
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
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
