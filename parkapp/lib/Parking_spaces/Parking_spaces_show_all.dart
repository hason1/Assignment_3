import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkapp/Login/Login_view.dart';
import 'package:parkapp/Tools/App_bar.dart';
import 'package:parkapp/Tools/Bottom_bar.dart';
import 'package:parkapp/Tools/Constants.dart';
import 'package:parkapp/Tools/Shared_preferences.dart';
import 'package:parkapp/Tools/Show_dialog_view.dart';
import 'package:parkapp/Tools/Style_class.dart';
import 'package:parkapp/Vehicle/Add_new_vehicle.dart';
import 'package:shared/shared.dart';
import '../State_mangement/Getx_Controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class parking_spaces_show_all extends StatefulWidget {

  bool only_available = false;

  parking_spaces_show_all({this.only_available = false});

  static Future? get_data_future;
  static final controller = Get.put(Getx_Controller());
  static List<ParkingSpace> filtered_parking_spaces = [];
  static List<ParkingSpace> parking_spaces = [];

  Future<dynamic> downloadData() async {
    try {
      List<ParkingSpace> all_parking_spaces = await ParkingSpaceRepository.get_all(host: Tools.emulator_host);

      if(only_available){
        List<Parking> all_parkings = await ParkingRepository.getAll(host: Tools.emulator_host);
        List used_parking_spaces_ids = [];

        all_parkings.forEach((parking){
          used_parking_spaces_ids.add(parking.parking_space_id);
        });

        all_parking_spaces.forEach((parking_space){
          if(!used_parking_spaces_ids.contains(parking_space.id)){
            filtered_parking_spaces.add(parking_space);
          }
        });
      }
      else {
        filtered_parking_spaces = all_parking_spaces;
      }

      parking_spaces = filtered_parking_spaces;

    } catch(e){

    }

    return Future.value('success');
  }

  @override
  State<parking_spaces_show_all> createState() => _parking_spaces_show_allState();
}

class _parking_spaces_show_allState extends State<parking_spaces_show_all> {

  final TextEditingController search_controller = TextEditingController();

  get_download(){
    parking_spaces_show_all.filtered_parking_spaces = [];
    parking_spaces_show_all.get_data_future = widget.downloadData().then((value) {
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

  @override
  void dispose() {
    search_controller.dispose();
    super.dispose();
  }



  Widget parking_spaces_show(){
    if(parking_spaces_show_all.filtered_parking_spaces.isNotEmpty){
      return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: parking_spaces_show_all.filtered_parking_spaces.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(5.w),
              margin: EdgeInsets.only(top: 5.h, bottom: 5.h),

              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(parking_spaces_show_all.filtered_parking_spaces[index].address, textScaler: TextScaler.linear(1.5.sp), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  Text(parking_spaces_show_all.filtered_parking_spaces[index].number ?? '', textScaler: TextScaler.linear(1.sp), style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),
                  Text(parking_spaces_show_all.filtered_parking_spaces[index].price + ' kr', textScaler: TextScaler.linear(1.sp), style: TextStyle(fontWeight: FontWeight.normal, color: Colors.yellow),),


                ],
              ),
            );
          }
      );
    }
    else return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Parkeringsplatser saknas', textScaler: TextScaler.linear(1.4),),

      ],
    ),);
  }

  Widget search_widget(){
    return SearchBar(
      controller: search_controller,
      hintText: 'Sök parkeringsplatser...',
      onChanged: (value) {
        setState(() {
          search_in_list();
        });
      },
      leading: Icon(Icons.search),
      trailing: [
        if (search_controller.text.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              search_controller.clear();
              setState(() {
                search_in_list();
              });
            },
          ),
      ],
    );
  }


  search_in_list(){
    parking_spaces_show_all.filtered_parking_spaces = [];
    if(search_controller.text.isNotEmpty){
      for(int i=0; i<parking_spaces_show_all.parking_spaces.length; i++){
        if(parking_spaces_show_all.parking_spaces[i].address.toLowerCase().contains(search_controller.text.toLowerCase())
            || parking_spaces_show_all.parking_spaces[i].number.toLowerCase().contains(search_controller.text.toLowerCase())
            || parking_spaces_show_all.parking_spaces[i].price.toLowerCase().contains(search_controller.text.toLowerCase())){
          parking_spaces_show_all.filtered_parking_spaces.add(parking_spaces_show_all.parking_spaces[i]);
        }
      }
    }
    else {
      parking_spaces_show_all.filtered_parking_spaces = parking_spaces_show_all.parking_spaces;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: parking_spaces_show_all.get_data_future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return style_class.scaffold_loading(context,  'Parkeringsplatser');
          } else if (snapshot.hasError) {
            return style_class.scaffold_loading(context,  'Parkeringsplatser');
          } else {
            return Scaffold(
                bottomNavigationBar: bottom_bar.bottom_bar_widget( context, 'parking_spaces'),
                appBar: app_bar_class.app_bar_widget(context: context, title: (widget.only_available ? 'Lediga parkeringsplatser': 'Parkeringsplatser') , show_back_btn: true),
                backgroundColor: Colors.grey[300],
                body: Column(
                  children: [
                    search_widget(),
                    Expanded(child: parking_spaces_show()),
                  ],
                ));

          }});

  }
}
