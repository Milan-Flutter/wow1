import 'package:flutter/material.dart';
import 'package:wow/constant.dart';

class story_view_page extends StatefulWidget {
  const story_view_page({Key? key,required this.emg}) : super(key: key);
  final String? emg;

  @override
  State<story_view_page> createState() => _story_view_pageState();
}

class _story_view_pageState extends State<story_view_page>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
 String? img;
  @override
  void initState() {
    super.initState();
    img=widget.emg.toString();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    startLoading();
  }

  void startLoading() {
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(img!.toString()),
                fit: BoxFit.cover
              )
            ),

    ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .05,),
                LinearProgressIndicator(
                  value: _animationController.value,
                  color: main_color,
                  backgroundColor: s_color,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
