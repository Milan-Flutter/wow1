import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/post.dart';





class getpost1 {
  Future<getpost> getpo() async {
    SharedPreferences SUId = await SharedPreferences.getInstance();
    var  id = SUId.getString('user_id').toString();
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_post.php');
    var response = await http.post(url,
        body: ({
          'user_id': id,
        }),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        });
    Encoding.getByName('utf-8');

    Map<String, dynamic> map = await jsonDecode(response.body);

    print(response.body);

    final data = getpost.fromJson(map);
    print("ddd"+data.toString());
    return data;
  }
  Future<getpost> getpo1({    required String id,
  }) async {
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_post.php');
    var response = await http.post(url,
        body: ({
          'user_id': id,
        }),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        });
    Encoding.getByName('utf-8');

    Map<String, dynamic> map = await jsonDecode(response.body);

    print(response.body);

    final data = getpost.fromJson(map);
    print("ddd"+data.toString());
    return data;
  }


}
