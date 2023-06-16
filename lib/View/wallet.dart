import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:wow/constant.dart';
import '../Controller/profile_data.dart';

class wallet extends StatefulWidget {
  const wallet({Key? key}) : super(key: key);

  @override
  State<wallet> createState() => _walletState();
}

class _walletState extends State<wallet> {
  int? count;
  int i = 1;

  bool isloding = false;
  bool ispayment = false;
  Razorpay _razorpay = Razorpay();
  String? money;
  String? uid;
  String? coin;
  late Map planres;

  Future<void> plan1() async {
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_plan.php');
    var response = await post(url);
    if (response.statusCode == 200) {
      setState(() {
        planres = json.decode(response.body);
        print("dsgjasr");
        print(planres);
        isloding = true;
      });
    }
  }

  Future<void> addCoin() async {
    print("fhkljsadfsejhngsgskjdg");
    print(coin.toString());
    int old = int.parse(controller.coin.toString());
    int newc = int.parse(coin.toString());
    var finalc = old + newc;

    var response = await post(
        Uri.parse(
            "https://mechodalgroup.xyz/whoclone/api/update_user_wallate.php"),
        body: {'id': uid.toString(), 'wallet_coin': finalc.toString()});
    print("object");
    if (response.statusCode == 200) {
      print(response.body.toString());
    }
    controller.harsh();
  }

  @override
  void initState() {
    uid = controller.uid.toString();
    plan1();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  profile_data controller = Get.put(profile_data());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloding
          ? WillPopScope(
              onWillPop: () async {
                return true; // Allow the pop operation
              },
              child: Stack(
                children: [
                  Image.asset(
                    'assets/all.png', // replace with your image path
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                            Obx(() {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                width: MediaQuery.of(context).size.width * .7,
                                decoration: BoxDecoration(
                                  color: main_color,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "My Coins :",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      "assets/mo.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      controller.coin.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                        ListView.builder(
                          itemCount: planres['plan'].length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            bool abc = false;

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  count = index;
                                  abc = true;
                                  ispayment = true;
                                  money = planres['plan'][index]['price']
                                      .toString();
                                  print("dkAGBIOdfhmnhmnhmnhmnhmngrd");
                                  coin =
                                      planres['plan'][index]['coin'].toString();
                                  print(coin.toString());
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                margin: EdgeInsets.only(right: 16, top: 10),
                                height:
                                    MediaQuery.of(context).size.height * .06,
                                width: MediaQuery.of(context).size.width * .9,
                                decoration: BoxDecoration(
                                    color: count == index
                                        ? Color(0xffE32753).withOpacity(.2)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: count == index
                                            ? Color(0xffE32753)
                                            : Colors.white)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/mo.png",
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          planres['plan'][index]['coin']
                                              .toString(),
                                          style: TextStyle(
                                            color: Color(0xff3F2D20),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "₹ " +
                                          planres['plan'][index]['price']
                                              .toString(),
                                      style: TextStyle(
                                          color: main_color, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
              color: s_color,
            )),
      bottomSheet: ispayment
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: main_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {
                  openCheckout();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * .06,
                  width: MediaQuery.of(context).size.width * .9,
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
            )
          : Container(
              height: 2,
            ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_G68KUDEoy0nBMB',
      'amount': int.parse(money.toString()) * 100,
      'description': 'Payment',
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(response.paymentId.toString());
    print(response.orderId.toString());
    print(response.signature.toString());
    print(controller.coin.toString());
    addCoin();

    Fluttertoast.showToast(msg: "Transaction SUCCESS");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message.toString());
    print(response.code.toString());
    print(response.error.toString());
    Fluttertoast.showToast(msg: "Transaction Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName.toString());
    Fluttertoast.showToast(msg: "WALLET:-" + response.walletName.toString());
  }
}
