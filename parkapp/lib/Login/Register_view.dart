import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parkapp/Login/Login_view.dart';
import 'package:parkapp/Tools/App_bar.dart';
import 'package:parkapp/Tools/App_text_field.dart';
import 'package:parkapp/Tools/Permissions.dart';
import 'package:parkapp/Tools/Style_class.dart';
import 'package:shared/shared.dart';

class register_view extends StatefulWidget {
  const register_view({super.key});

  @override
  State<register_view> createState() => _register_viewState();
}

class _register_viewState extends State<register_view> {

  final TextEditingController person_number_controller = TextEditingController();
  final TextEditingController password_controller = TextEditingController();
  final TextEditingController name_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    person_number_controller.dispose();
    password_controller.dispose();
    name_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: style_class.Body_color,
          appBar: app_bar_class.app_bar_widget(context: context, title: 'Registrera konto'),
          body: ListView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            children: [

              App_text_field(
                title: 'Personnummer',
                controller: person_number_controller,
              ),

              App_text_field(
                title: 'Namn',
                controller: name_controller,
              ),


              App_text_field(
                title: 'Lösenord',
                controller: password_controller,
                isPassword: true,
              ),

              
              ElevatedButton(
                  onPressed: () async {
                if(person_number_controller.text.isNotEmpty && password_controller.text.isNotEmpty && name_controller.text.isNotEmpty){
                  dynamic person = await PersonRepository.get_person(person_number_controller.text, host: Tools.emulator_host);

                  if(person != null && person is Person){
                    style_class.showSnackBar('Personen med denna personnummer: ' + person_number_controller.text + ' existerar redan', context, duration_count: 5);
                  }
                  else {
                    bool success = await PersonRepository.add(Person(id: Tools.generateId(), name: name_controller.text ?? '', person_number: person_number_controller.text ?? '',
                        password: password_controller.text, role: permissions.user_role), host: Tools.emulator_host);

                   print(success);
                    if(success) {
                      style_class.showSnackBar(name_controller.text + '  tillagd', context);
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => login_view(person_number: person_number_controller.text, password: password_controller.text,)), (Route<dynamic> route) => false);

                    }
                    else {
                      style_class.showSnackBar('Ett fel har inträffat, vänligen försök igen', context);
                    }
                  }

                }
                else {
                  style_class.showSnackBar('Vänligen fyll i samtliga fält och försök igen', context);
                }
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ), ),

            ],
          ),

    ));
  }
}
