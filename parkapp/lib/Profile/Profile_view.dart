import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkapp/Login/Login_view.dart';
import 'package:parkapp/Tools/App_bar.dart';
import 'package:parkapp/Tools/Bottom_bar.dart';
import 'package:parkapp/Tools/Constants.dart';
import 'package:parkapp/Tools/Shared_preferences.dart';
import 'package:parkapp/Tools/Style_class.dart';
import 'package:parkapp/Vehicle/Add_new_vehicle.dart';
import 'package:shared/shared.dart';
import '../State_mangement/Getx_Controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Vehicle/Vehicles_show_all.dart';

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
    return   Container(
      margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
      child: ElevatedButton(
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
        ), ),
    );
  }


  Widget profile_btn({required String text, required Icon icon, required dynamic target_page, }){
    return Container(
      width: MediaQuery.of(context).size.width.w,
      margin: EdgeInsets.only(top: 5.h, bottom: 10.h, right: 5.w, left: 5.w),
      child: ElevatedButton(
        onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => target_page), (Route<dynamic> route) => false);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Text(text, style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
          ],
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }


  Widget vehicle_buttons(){
    if(profile_view.controller.user!.role.toString() == constants.user_role && constants.user_permissions.contains(constants.edit_own_vehicles)){
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          title: Center(child: Text('Fordon', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white,),)),
          subtitle: Center(child: Text('Hantera dina fordon', style: TextStyle(fontSize: 14.sp, color: Colors.white,),)),
          leading: Icon(Icons.directions_car_sharp, color: Colors.white70, size: 22.w,),
          trailing: Icon(Icons.expand_more, color: Colors.white, size: 22.w,),
          backgroundColor: Colors.blueGrey[700],
          collapsedBackgroundColor: Colors.blueGrey[600],
          children: [

            profile_btn(text:'Lägg till fordon', icon: Icon(Icons.add, color: Colors.black, size: 20.w,), target_page: add_new_vehicle()),
            profile_btn(text:'Visa mina fordon', icon: Icon(Icons.directions_car, color: Colors.black, size: 20.w,), target_page: show_all_vehicles.vehicles_show_all()),
          ],
        ),
      );
    }
    else return SizedBox();
  }

  Widget parking_buttons(){
    if(profile_view.controller.user!.role.toString() == constants.user_role && constants.user_permissions.contains(constants.edit_own_parking)){
      return Container(
        margin: EdgeInsets.only(top: 15.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ExpansionTile(
            title: Center(child: Text('Parkeringar', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white,),)),
            subtitle: Center(child: Text('Hantera dina parkeringar', style: TextStyle(fontSize: 14.sp, color: Colors.white,),)),
            leading: Icon(Icons.local_parking, color: Colors.white70, size: 22.w,),
            trailing: Icon(Icons.expand_more, color: Colors.white, size: 22.w,),
            backgroundColor: Colors.brown[700],
            collapsedBackgroundColor: Colors.brown[600],
            children: [

              profile_btn(text:'Parkera fordon', icon: Icon(Icons.add, color: Colors.black, size: 20.w,), target_page: null),
              profile_btn(text:'Visa mina parkeringar', icon: Icon(Icons.directions_car, color: Colors.black, size: 20.w,), target_page: null),
              profile_btn(text:'Visa lediga parkeringsplatser', icon: Icon(Icons.space_dashboard_outlined, color: Colors.black, size: 20.w,), target_page: null),
            ],
          ),
        ),
      );
    }
    else return SizedBox();
  }

  Widget name_widget(){
    return Container(
      width: MediaQuery.of(context).size.width.w,
      margin: EdgeInsets.only(top: 10.h, bottom: 15.h),
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      alignment: Alignment.center,
      child: Text('Hej ' + profile_view.controller.user!.name.toString(), textScaler: TextScaler.linear(2.sp), style: TextStyle(color: Colors.black),),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(12),
      ),
   );
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
            backgroundColor: Colors.grey[300],
            body: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Column(
              children: [

                name_widget(),
                vehicle_buttons(),
                 parking_buttons(),

                logout_btn(),
              ]
              ),
            ));

      }});

}
}
