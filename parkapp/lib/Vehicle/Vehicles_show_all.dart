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

class vehicles_show_all extends StatefulWidget {

  static Future? get_data_future;
  static final controller = Get.put(Getx_Controller());
  static List<Vehicle> filtered_own_vehicles = [];
  static List<Vehicle> own_vehicles = [];

  Future<dynamic> downloadData() async {
    try {
      List<Vehicle> vehicles = await VehicleRepository.get_all(host: Tools.emulator_host);

      vehicles.forEach((vehicle){
        if(vehicle.person_id == controller.user!.id.toString()){
          filtered_own_vehicles.add(vehicle);
        }
      });

      own_vehicles = filtered_own_vehicles;
    } catch(e){

    }
    
    return Future.value('success');
  }

  @override
  State<vehicles_show_all> createState() => _vehicles_show_allState();
}

class _vehicles_show_allState extends State<vehicles_show_all> {

  final TextEditingController search_controller = TextEditingController();

  get_download(){
    vehicles_show_all.own_vehicles = [];
    vehicles_show_all.filtered_own_vehicles = [];
    vehicles_show_all.get_data_future = widget.downloadData().then((value) {
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

  
  Widget vehicles_show(){
    if(vehicles_show_all.filtered_own_vehicles.isNotEmpty){
      return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: vehicles_show_all.filtered_own_vehicles.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.all(5.w),
              margin: EdgeInsets.only(top: 5.h, bottom: 5.h),

              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicles_show_all.filtered_own_vehicles[index].registration_number, textScaler: TextScaler.linear(1.5.sp), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  Text(vehicles_show_all.filtered_own_vehicles[index].type ?? '', textScaler: TextScaler.linear(1.sp), style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),),

                  Divider(height: 5.h, color: Colors.grey,),
                  ElevatedButton(
                    onPressed: () async {

                      await show_dialog_view(
                        context: context,
                        title: "Är du säker?",
                        content: "Vill du verkligen ta bort fordon?",
                        confirmText: "Ja",
                        cancelText: "Avbryt",
                        onResult: (confirmed) async {
                          if (confirmed) {
                            await VehicleRepository.delete(vehicles_show_all.filtered_own_vehicles[index].id, host: Tools.emulator_host);
                            setState(() {
                              get_download();
                            });
                          } else {
                            print("User cancelled.");
                          }
                        },
                      );

                    }, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_forever, size: 20.w, color: Colors.white,),
                      Text(' Ta bort', textScaler: TextScaler.linear(1.sp), style: TextStyle(color: Colors.white),)
                    ],
                  ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ), ),


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
        Text('Fordon saknas', textScaler: TextScaler.linear(1.4),),

        Container(
          width: MediaQuery.of(context).size.width.w,
          margin: EdgeInsets.only(top: 5.h, bottom: 10.h, right: 5.w, left: 5.w),
          child: ElevatedButton(
            onPressed: (){
              add_vehicle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.black, size: 20.w,),
                Text('Lägg till fordon', style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
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
        )
      ],
    ),);
  }

  Widget search_widget(){
   return SearchBar(
      controller: search_controller,
      hintText: 'Sök fordon...',
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
    vehicles_show_all.filtered_own_vehicles = [];
    if(search_controller.text.isNotEmpty){
      for(int i=0; i<vehicles_show_all.own_vehicles.length; i++){
        if(vehicles_show_all.own_vehicles[i].registration_number.toLowerCase().contains(search_controller.text.toLowerCase())
            || vehicles_show_all.own_vehicles[i].type.toLowerCase().contains(search_controller.text.toLowerCase())){
          vehicles_show_all.filtered_own_vehicles.add(vehicles_show_all.own_vehicles[i]);
        }
      }
    }
    else {
      vehicles_show_all.filtered_own_vehicles = vehicles_show_all.own_vehicles;
    }
  }

  void add_vehicle() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => add_new_vehicle()));
  }

  Widget add_new_btn(){
    return InkWell(
        onTap: (){
          add_vehicle();
        },
        child: Padding(
          padding:  EdgeInsets.only(left: 8.w, right: 8.w),
          child: Icon(Icons.add, size: 25.w, color: Colors.white,),
        ));
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: vehicles_show_all.get_data_future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return style_class.scaffold_loading(context,  'Mina fordon');
          } else if (snapshot.hasError) {
            return style_class.scaffold_loading(context,  'Mina fordon');
          } else {
            return Scaffold(
                bottomNavigationBar: bottom_bar.bottom_bar_widget( context, 'vehicles'),
                appBar: app_bar_class.app_bar_widget(context: context, title: 'Mina fordon', show_back_btn: true, extra_widgets: add_new_btn()),
                backgroundColor: style_class.Body_color,
                body: Column(
                  children: [
                    search_widget(),
                    Expanded(child: vehicles_show()),
                  ],
                ));

          }});

  }
}

