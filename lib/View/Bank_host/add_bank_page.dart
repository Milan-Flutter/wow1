import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../../Controller/profile_data.dart';
import '../../constant.dart';

class add_bank extends StatefulWidget {
  const add_bank({Key? key, required this.status}) : super(key: key);
  final String? status;

  @override
  State<add_bank> createState() => _add_bankState();
}

class _add_bankState extends State<add_bank> {
  TextEditingController _bankname = TextEditingController();
  TextEditingController _account_number = TextEditingController();
  TextEditingController _verfiye = TextEditingController();
  TextEditingController _ifsc = TextEditingController();
  TextEditingController _accountname = TextEditingController();

  String? uid;
  profile_data controller = Get.put(profile_data());
  bool update = false;

  Future<void> add_Bank() async {
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/bank.php"),
        body: {
          'user_id': uid.toString(),
          'name': _accountname.text,
          'acc_number': _account_number.text,
          'ifsc': _ifsc.text,
          'bank_name': _bankname.text
        });

    print({
      'user_id': uid.toString(),
      'name': _accountname.text,
      'acc_number': _account_number.text,
      'ifsc': _ifsc.text,
      'bank_name': _bankname.text
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print("faudgdgdgdgdgdgkur");
      print(data);
      var messege = (data['message']);
      if (messege == "Bank Addedd successfull") {
        Fluttertoast.showToast(msg: "Bank Addedd successfull");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Bank Add Failed");
      }
    }
  }

  Future<void> update_bank() async {
    print({
      'user_id': uid.toString(),
      'name': _accountname.text.toString(),
      'acc_number': _account_number.text.toString(),
      'ifsc': _ifsc.text.toString(),
      'bank_name': _bankname.text.toString()
    });
    var response = await post(
        Uri.parse("https://mechodalgroup.xyz/whoclone/api/bank_update.php"),
        body: {
          'user_id': uid.toString(),
          'name': _accountname.text.toString(),
          'acc_number': _account_number.text.toString(),
          'ifsc': _ifsc.text.toString(),
          'bank_name': _bankname.text.toString()
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['message'] == "Updated successfully") {
        Fluttertoast.showToast(msg: "Updated successfully");
        controller.bank_details();
        Navigator.pop(context);
      }
    }
  }

  void edit() {
    _accountname.text = controller.b_u_name.toString();
    _account_number.text = controller.account_number.toString();
    _bankname.text = controller.b_name.toString();
    _ifsc.text = controller.ifsc.toString();
    _verfiye.text = controller.account_number.toString();
  }

  @override
  void initState() {
    uid = controller.uid.toString();
    if (widget.status == "1") {
      edit();
      update = true;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        height: MediaQuery.of(context).size.height * .06,
                        width: MediaQuery.of(context).size.width * .13,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xffFFFFFF)),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Color(0xffFF85A6),
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Add Bank Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Please Add your bank details. This account is used for withdrove coins",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _accountname,
                        decoration: InputDecoration(
                          hintText: 'Name on Bank Account',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintStyle:
                              TextStyle(fontSize: 12, color: Color(0xff3F2D20)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xffE32753))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Color(
                                  0xffE32753), // Set the border color when the TextField is focused
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _account_number,
                        decoration: InputDecoration(
                          hintText: 'Enter Account No.',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _verfiye,
                        decoration: InputDecoration(
                          hintText: 'Verify Account No.',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _ifsc,
                        decoration: InputDecoration(
                          hintText: 'IFSC Code',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _bankname,
                        decoration: InputDecoration(
                          hintText: 'Bank Name',
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
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                    Align(
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: 50, left: 10, right: 10),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: main_color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              if (_account_number.text == _verfiye.text) {
                                update ? update_bank() : add_Bank();
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Account Number and Verify Account Not Mathch");
                              }
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * .06,
                              width: MediaQuery.of(context).size.width * .8,
                              child: Center(
                                child: Text(
                                  'Save',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
