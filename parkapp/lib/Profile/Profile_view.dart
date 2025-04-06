import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkapp/Login/Login_view.dart';
import 'package:parkapp/Tools/App_bar.dart';
import 'package:parkapp/Tools/Bottom_bar.dart';
import 'package:parkapp/Tools/Shared_preferences.dart';
import 'package:parkapp/Tools/Style_class.dart';
import 'package:shared/shared.dart';
import '../State_mangement/Getx_Controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class profile_view extends StatefulWidget {
  const profile_view({super.key});

  static Future? get_data_future;
  static final controller = Get.put(Getx_Controller());

  Future<dynamic> downloadData() async {

    if(controller.user == null || controller.user!.id == null){
      return Future.value('no_permission');
    }
    return Future.value('success');
  }

  @override
  State<profile_view> createState() => _profile_viewState();
}

class _profile_viewState extends State<profile_view> {

  get_download(){
    profile_view.get_data_future = widget.downloadData().then((value) {
      if(value=='no_permission'){
        shared_preferences_helper.logout_user(context: context);
      }
      else {

      }
    } );
  }


  @override
  void initState() {
    get_download();

    super.initState();
  }

  Widget logout_btn(){
    return   ElevatedButton(
      onPressed: () async {
        await shared_preferences_helper.logout_user(context: context);

        style_class.showSnackBar('Användaren loggades ut', context, duration_count: 5);

      }, child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.logout, size: 20.w, color: Colors.white,),
        Text(' Logga ut', textScaler: TextScaler.linear(1.sp), style: TextStyle(color: Colors.white),)
      ],
    ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ), );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: profile_view.get_data_future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
      // AsyncSnapshot<Your object type>
      if (snapshot.connectionState == ConnectionState.waiting) {
        return style_class.scaffold_loading(context,  'Profile');
      } else if (snapshot.hasError) {
        return style_class.scaffold_loading(context,  'Profile');
      } else {
        return Scaffold(
            bottomNavigationBar: bottom_bar.bottom_bar_widget( context, 'profile'),
            appBar: app_bar_class.app_bar_widget(context: context, title: 'Min profil', show_back_btn: false),
            body: ListView(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
            children: [

              Center(child: Text('Hej ' + profile_view.controller.user!.name.toString(), textScaler: TextScaler.linear(2.sp),)),

              logout_btn(),
          ]
        ));

      }});

}
}
