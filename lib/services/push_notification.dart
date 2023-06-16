
import 'dart:convert';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../Controller/profile_data.dart';
import '../View/Video_Call/call_page.dart';
import '../View/Video_Call/calloing_page.dart';
import '../View/bottom_navigation.dart';

class Notificationservices{
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  final FlutterLocalNotificationsPlugin  _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin ();
  FirebaseMessaging messaging=FirebaseMessaging.instance;

  Future<String>  getDevicesToken() async{
    String? token=await messaging.getToken();
    return token!;
  }


  reqPermission()async{
    NotificationSettings settings =await messaging.requestPermission(
      alert: true,
      sound: true,
      provisional: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print("user permission granted");
    }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print("user provisional permission granted");
    }else{
      AppSettings.openNotificationSettings();
      print("user provisional permission declined");
    }
  }

  void Tokenrefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
    // return token!;
  }

  void inittLocalNotification(BuildContext context,RemoteMessage message)async{

    print("jAF 2");
    var androidInitializationSettings=AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings=DarwinInitializationSettings();

    var initializationSettings =InitializationSettings(android: androidInitializationSettings,iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (paylode){
        print("paylode:"+paylode.toString());

        },



    );
  }

  void handleNotification(RemoteMessage message,BuildContext context) {
    // Handle the notification and open the desired screen
    // For example, you can use Navigator to navigate to a specific screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PickupCallPage()),
    );
  }

  Future<void> showNotification(RemoteMessage message, BuildContext context)async{
    inittLocalNotification(context, message);
    Future.delayed(
        Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title.toString(),
          message.notification!.body.toString(),

          NotificationDetails(
            android: AndroidNotificationDetails(
              Random.secure().nextInt(100000).toString(),
              "High Impotence Notification",
              channelDescription: "channel Description",
              importance: Importance.high,
              playSound: true,
              icon:'@mipmap/ic_launcher',

            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),

          payload: message.data.toString()
      );
    }

    );
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => PickupCallPage(
    //       hostid: message.data['user_id'].toString(),
    //     )));
    _showDialog(context,message.data['user_id'].toString());
  }

  _showDialog(BuildContext context,String id)
  async
  {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState)
            {
              profile_data controller = Get.put(profile_data());

              Api(String type) async {
                try {
                  var response = await post(
                      Uri.parse(
                          "https://mechodalgroup.xyz/whoclone/api/add_call_history.php"),
                      body: {
                        'user_id': controller.uid.toString(),
                        'miss_id': id.toString(),
                        'type': type.toString(),
                      });
                  print({
                    'user_id': controller.uid.toString(),
                    'miss_id': id.toString(),
                    'type': type.toString(),
                  });
                  if (response.statusCode == 200) {
                    var messege;
                    var data = jsonDecode(response.body.toString());
                    print(data.toString());
                    messege = (data["message"]);
                    Fluttertoast.showToast(msg: messege);
                    if (messege == 'Video call history recorded successfully.') {
                      if (type == "miss call") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => botttom_navigate()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => botttom_navigate()),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyCall(
                            Username: controller.name.toString(),
                            userID: controller.uid.toString(),
                            callID: controller.uid.toString(),
                            privet: true,
                          ),),
                        );

                      }
                    } else {
                      print(data);
                    }
                  } else {
                    print("Invalid Input");
                  }
                } catch (e) {
                  print("login failled");
                  print('error' + e.toString());
                }
              }
              return  Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/all.png', // replace with your image path
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: MediaQuery.of(context).size.height * .08),
                            Text(
                              'Incoming Call',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * .18),
                            CircleAvatar(
                              radius: 80.0,
                              backgroundImage: AssetImage(
                                'assets/img_11.png',
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * .03),
                            Text(
                              'John Doe',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * .1),
                            Text(
                              'Incoming Call',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * .1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FloatingActionButton(
                                  onPressed: () {

                                    Api("attend call");



                                  },
                                  child: Icon(
                                    Icons.video_call,
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                  Api("miss call");
                                    },
                                  child: Icon(Icons.call_end),
                                  backgroundColor: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

 /* Future<void> harsh()
  async {
     CallKitParams callKitParams = CallKitParams(
      id: "1",
      nameCaller: 'Hien Nguyen',
      appName: 'Callkit',
      avatar: 'https://i.pravatar.cc/100',
      handle: '0123456789',
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      duration: 30000,
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: 'https://i.pravatar.cc/500',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call"
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }*/

}