import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../Controller/profile_data.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;

class host_edit extends StatefulWidget {
  const host_edit({Key? key}) : super(key: key);

  @override
  State<host_edit> createState() => _host_editState();
}

class _host_editState extends State<host_edit> {
  final _picker = ImagePicker();
  profile_data controller = Get.put(profile_data());
  File? _pickedImage;
  var peakimg;

  bool img = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _agecontroller = TextEditingController();
  TextEditingController _aboutController = TextEditingController();

  Future<void> _getImage() async {
    debugPrint("objectlllllllllllllll");
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        img = true;
      });
    }
  }

  Future<void> sendPost(File imageFile) async {
    debugPrint("gfKasughfkluyh");
    debugPrint(controller.uid.toString());
    debugPrint(_nameController.text.toString());

    debugPrint("qq" + imageFile.toString());
    Uri apiUrl = Uri.parse(
        'https://mechodalgroup.xyz/whoclone/api/host_profile_update.php');
    var request = http.MultipartRequest('POST', apiUrl);

    request.fields['id'] = controller.uid.toString();
    img
        ? request.files.add(await http.MultipartFile.fromPath(
            'photo_url', imageFile.path.toString()))
        : null;
    request.fields['name'] = _nameController.text.toString();
    request.fields['age_verification'] = _agecontroller.text.toString();
    request.fields['about'] = _aboutController.text.toString();
    var response = await request.send();
    debugPrint("KLSJDfbharhad");
    if (response.statusCode == 200) {
      var res = await http.Response.fromStream(response);
      debugPrint(res.body.toString());
      var data = jsonDecode(res.body.toString());
      debugPrint(data.toString());
      if (data['message'] == "Updated successfully") {
        Fluttertoast.showToast(msg: "Edit profile Succesfully");
        controller.harsh();
        Navigator.pop(context);
      }
    } else {
      print('Error submitting form data: ${response.statusCode}');
      Fluttertoast.showToast(msg: "Post was not Added ");
    }
  }

  @override
  void initState() {
    _nameController.text = controller.name.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      return SafeArea(
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
                          width: MediaQuery.of(context).size.width * .3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ID: ",
                              style: TextStyle(fontSize: 12, color: main_color),
                            ),
                            Text(
                              controller.uid.toString(),
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff73665C)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          child: Stack(
                            children: [
                              img
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(_pickedImage!),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          controller.photourl.toString()),
                                    ),
/*
                                NetworkImage(controller.photourl.toString())
*/
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 70,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _getImage();
                                      },
                                      child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 20,
                                          child: Icon(
                                            Icons.edit,
                                            color: main_color,
                                          )),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Your Name',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff3F2D20)),
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
                            controller: _agecontroller,
                            decoration: InputDecoration(
                              hintText: 'Your Age',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff3F2D20)),
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
                            controller: _aboutController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'About Me',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              hintStyle: TextStyle(
                                  fontSize: 12, color: Color(0xff3F2D20)),
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
                          height: MediaQuery.of(context).size.height * .12,
                        ),
                        Align(
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 50, left: 10, right: 10),
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: main_color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  sendPost(_pickedImage!);
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .06,
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
          ],
        ),
      );
    }));
  }
}
