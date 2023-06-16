import 'package:get/get.dart';
import 'package:wow/Api/bank.dart';


import '../Api/All_Data.dart';
import '../Model/All_Data.dart';
import '../Model/bank.dart';

class profile_data extends GetxController
{
 RxString name="".obs;
 RxString coin="".obs;
 RxString follow="0".obs;
 RxString following="0".obs;
 RxString type="".obs;
 RxString post="0".obs;
 RxString uid="".obs;


 RxString photourl="".obs;
 RxString user_status="".obs;

 RxString host_status="".obs;
 RxString  f_id="".obs;


 RxString b_u_name="".obs;
 RxString b_name="".obs;
 RxString account_number="".obs;
 RxString ifsc="".obs;


  void harsh()
  {
    print("djFJMSEGGnl.gSFV.a");
    userData().data().then((value1) {
      AllData? data1=value1;
      name?.value=data1!.data![0].name.toString();
      uid?.value=data1!.data![0].id.toString();
      coin?.value=data1!.data![0].walletCoin.toString();
      photourl?.value=data1!.data![0].photoUrl.toString();
      follow?.value=data1!.data![0].follower.toString();
      following?.value=data1!.data![0].following.toString();
      type?.value=data1!.data![0].type.toString();
      user_status?.value=data1!.data![0].user_status.toString();
      host_status?.value=data1!.data![0].host_status.toString();
      post?.value=data1!.data![0].totalPost.toString();
      print(data1!.data![0].id.toString());




    });
    print("djFJMSEGGnl.gSFV.a");
    print(uid.toString());
    print(photourl.toString());
    print(coin.toString());
    print(type.toString());
  }

void bank_details()
{
  print("jhvbjNGGG");
  bank1().data().then((value3) {
    bank? data2=value3;
    b_u_name?.value=data2!.data!.bank![0].name.toString();
    b_name?.value=data2!.data!.bank![0].bankName.toString();
    account_number?.value=data2!.data!.bank![0].accNumber.toString();
    ifsc?.value=data2!.data!.bank![0].ifsc.toString();
 });

  print(b_u_name.toString());
  print(b_name.toString());
}



}