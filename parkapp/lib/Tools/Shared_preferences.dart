import 'package:flutter/material.dart';
import 'package:parkapp/Login/Login_view.dart';
import 'package:parkapp/Profile/Profile_view.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../State_mangement/Getx_Controller.dart';


// Den här class sparar, hämtar eller tar bort info från enheten
class shared_preferences_helper{
  static String user_id_name = 'user_id';

  // kolla om det finns token i enheten
  static Future<String> get_value_from_device(String data) async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedToken = prefs.getString(data);

    if(savedToken == null || savedToken == false || savedToken.isEmpty) {
      return '';
    }
    else {
      return savedToken;
    }
  }


  static Future<bool> save_value_in_device({required String? key, required String value}) async{
    WidgetsFlutterBinding.ensureInitialized();

    if(key != null || key!.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);

      String Tokencheck = await get_value_from_device(value);
      if(Tokencheck == key) {
        return true;
      }
      else {
        return false;
      }
    }
    else {
      return false;
    }

  }



// tar bort data från enheten
  static Future<bool> remove_token_in_device(String value) async{
    WidgetsFlutterBinding.ensureInitialized();

    if(value != null || value.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(value);

      return true;
    }
    else {
      return false;
    }
  }


  static Future<bool> remove_all_data_from_device() async{
    WidgetsFlutterBinding.ensureInitialized();

    String userId = await get_value_from_device(user_id_name);


    if (userId.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      return true;
    }
    else{
      return false;
    }

  }


  static Future<Widget> set_user_view()async{
    WidgetsFlutterBinding.ensureInitialized();
     final controller = Get.put(Getx_Controller());

    String userId = await get_value_from_device(user_id_name);

    if (userId != null && userId.isNotEmpty) {
      Person? person = await PersonRepository.get_person(userId, host: Tools.emulator_host);
      if(person != null && person is Person && person.id != null){
        controller.user = person;
        return profile_view();
      }
      else{
        return login_view();
      }
    }
    else{
      return login_view();
    }
  }

  static logout_user({required BuildContext context}) async{
    await remove_token_in_device(user_id_name);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => login_view()), (Route<dynamic> route) => false);

    return true;
  }



}
