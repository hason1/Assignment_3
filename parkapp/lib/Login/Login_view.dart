import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parkapp/Login/Register_view.dart';
import 'package:parkapp/Profile/Profile_view.dart';
import 'package:parkapp/Tools/App_bar.dart';
import 'package:parkapp/Tools/App_text_field.dart';
import 'package:parkapp/Tools/Shared_preferences.dart';
import 'package:parkapp/Tools/Style_class.dart';
import 'package:shared/shared.dart';

import '../State_mangement/Getx_Controller.dart';

class login_view extends StatefulWidget {
   String person_number = '';
   String password = '';
   login_view({super.key, this.person_number = '', this.password = ''});

   static final controller = Get.put(Getx_Controller());

   @override
  State<login_view> createState() => _login_viewState();
}

class _login_viewState extends State<login_view> {

  final TextEditingController person_number_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();

  void set_intial_data(){
    if(widget.person_number != null && widget.person_number.isNotEmpty){
      person_number_controller.text = widget.person_number;
    }

    if(widget.password != null && widget.password.isNotEmpty){
      password_controller.text = widget.password;
    }
  }


  @override
  void initState() {
    set_intial_data();
    super.initState();
  }

  @override
  void dispose() {
    person_number_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }



  Widget login_btn(){
   return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: ElevatedButton(
        onPressed: () async {

          if(person_number_controller.text.isNotEmpty && password_controller.text.isNotEmpty){
            dynamic person = await PersonRepository.get_person(person_number_controller.text, host: Tools.emulator_host);

            if(person != null && person is Person && person.id != null && person.id.isNotEmpty && person.password.toString() == password_controller.text){
              style_class.showSnackBar('Inloggning pågår...', context, duration_count: 5);
              bool success = await shared_preferences_helper.save_value_in_device(key: shared_preferences_helper.user_id_name, value: person.id);
              login_view.controller.user = person;
              if(success) {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => profile_view()), (Route<dynamic> route) => false);

              }
              else {
                style_class.showSnackBar('Ett fel har inträffat, användaren inte existerar. Vänligen försök igen', context);
              }

            }
            else {
              style_class.showSnackBar('Ett fel har inträffat, användaren inte existerar. Vänligen försök igen', context);
            }
          }
          else {
            style_class.showSnackBar('Vänligen fyll i samtliga fält och försök igen', context);
          }

        }, child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.login, size: 22.w, color: Colors.white,),
          Text(' Logga in', textScaler: TextScaler.linear(1.sp), style: TextStyle(color: Colors.white),)
        ],
      ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ), ),
    );
  }


  Widget register_btn(){
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => register_view()), (Route<dynamic> route) => false);

        }, child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.person_add_alt, size: 20.w, color: Colors.white,),
          Text(' Registrera', textScaler: TextScaler.linear(1.sp), style: TextStyle(color: Colors.white),)
        ],
      ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
        ), ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: style_class.Body_color,
          appBar: app_bar_class.app_bar_widget(context: context, title: 'Login', show_back_btn: false),
          body: ListView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children: [

              App_text_field(
                title: 'Personnummer',
                controller: person_number_controller,
              ),

              App_text_field(
                title: 'Lösenord',
                controller: password_controller,
                isPassword: true,
              ),

              login_btn(),

              register_btn(),



            ],
          ),

        ));
  }
}
