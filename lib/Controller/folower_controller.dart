import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:wow/Controller/profile_data.dart';

class follwer extends GetxController
{

  profile_data controller = Get.put(profile_data());

  Future<void> getData()
  async
  {
    var response = await post(
        Uri.parse(
            "https://mechodalgroup.xyz/whoclone/api/get_following_id.php"),
        body: {'id': controller.uid.toString()});
    if(response.statusCode == 200)
      {
        print("Follwer Data");
        print(response.body);
      }
  }

}