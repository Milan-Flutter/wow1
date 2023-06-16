import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/All_Data.dart';



class userData {
  Future<AllData> data(

  ) async {
    SharedPreferences SUId = await SharedPreferences.getInstance();
   var  id = SUId.getString('user_id').toString();
   print("object123"+id);
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_user_detail.php');
    var response = await http.post(url,
        body: ({
          'user_id': id,
        }),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        });
    Encoding.getByName('utf-8');

    Map<String, dynamic> map = await jsonDecode(response.body);
print("object123");
    print(response.body);

    final data = AllData.fromJson(map);
    return data;
  }
  Future<AllData> data3({
    required String id,

  }) async {
    print("abcgkjfdabl"+id.toString());

    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_user_detail.php');
    var response = await http.post(url,
        body: ({
          'user_id': id.toString(),
        }),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        });
    Encoding.getByName('utf-8');

    Map<String, dynamic> map = await jsonDecode(response.body);

    print(response.body);

    final data = AllData.fromJson(map);
    return data;
  }


}