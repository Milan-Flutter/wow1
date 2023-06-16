import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/Model/bank.dart';





class bank1 {
  Future<bank> data(

      ) async {
    SharedPreferences SUId = await SharedPreferences.getInstance();
    var  id = SUId.getString('user_id').toString();
    print("object123"+id);
    var url = Uri.parse('https://mechodalgroup.xyz/whoclone/api/get_bank.php');
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

    final data = bank.fromJson(map);
    return data;
  }


}