import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:parkapp/Tools/App_bar.dart';
import 'package:parkapp/Tools/App_text_field.dart';
import 'package:parkapp/Tools/Bottom_bar.dart';
import 'package:parkapp/Tools/Constants.dart';
import 'package:parkapp/Tools/Style_class.dart';
import 'package:parkapp/Vehicle/Vehicles_show_all.dart';
import 'package:shared/shared.dart';

import '../State_mangement/Getx_Controller.dart';

class add_new_vehicle extends StatefulWidget {
  const add_new_vehicle({super.key});
  static final controller = Get.put(Getx_Controller());

  @override
  State<add_new_vehicle> createState() => _add_new_vehicleState();
}

class _add_new_vehicleState extends State<add_new_vehicle> {

  TextEditingController registration_number_controller = TextEditingController();
  String selected_vehicle_type = constants.person_car;

  @override
  void initState() {
    registration_number_controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    registration_number_controller.dispose();
    super.dispose();
  }


  Widget vehicle_types_dropdown(){
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fordonstyp*',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8.h),

          Container(
            width: MediaQuery.of(context).size.width.w,
            child: DropdownButton<String>(
              value: selected_vehicle_type,
              hint: Text('Välj fordonstyp', textScaler: TextScaler.linear(1.sp),),
              items: constants.vehicle_types.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selected_vehicle_type = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget save_btn(){
    return   Container(
      margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
      child: ElevatedButton(
        onPressed: () async {

          add_vehicle();

        }, child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check, size: 20.w, color: Colors.white,),
          Text(' Lägg till', textScaler: TextScaler.linear(1.sp), style: TextStyle(color: Colors.white),)
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

  void add_vehicle() async{
    if(registration_number_controller != null && registration_number_controller.text.isNotEmpty){
      Vehicle? new_vehicle;
      dynamic vehicle = await VehicleRepository.get_vehicle(registration_number_controller.text, host: Tools.emulator_host);

      if(vehicle != null && vehicle is Vehicle){
        style_class.showSnackBar('Fordonet existrerar redan, vänligen ändra regnumret och försök igen', context, duration_count: 5);
      }

      new_vehicle =  Vehicle(id: Tools.generateId(), registration_number: registration_number_controller.text ?? '', type: selected_vehicle_type ?? '', person_id: add_new_vehicle.controller.user!.id );
      bool success = await VehicleRepository.add(new_vehicle, host: Tools.emulator_host);
      if(success){
        style_class.showSnackBar('Bilen är tillgad', context, duration_count: 5);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => vehicles_show_all()), (Route<dynamic> route) => false);

      }
      else {
        style_class.showSnackBar('Kunde inte lägga bilen, vänligen försök igen', context, duration_count: 5);
      }
    }
    else {
      style_class.showSnackBar('Vänligen fyll i samtliga fält och försök igen', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        bottomNavigationBar: bottom_bar.bottom_bar_widget( context, 'new_vehicle'),
        appBar: app_bar_class.app_bar_widget(context: context, title: 'Lägg till fordon', show_back_btn: true),
        backgroundColor: style_class.Body_color,
        body: ListView(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            children: [

              App_text_field(
                title: 'Registreringsnummer*',
                controller: registration_number_controller,
              ),

              vehicle_types_dropdown(),

              save_btn(),
            ]
        ));
  }
}
