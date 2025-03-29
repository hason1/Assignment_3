import 'dart:io';

import 'package:cli/Menus/Parking_menu.dart';
import 'package:cli/Menus/Parking_space_menu.dart';
import 'package:cli/Menus/Person_menu.dart';
import 'package:cli/Menus/Vehicle_menu.dart';

class main_functions {
  static start_app(){
    String? main_option_input = handle_main_options();

    if(main_option_input != null){
      handle_selected_option(option: main_option_input);
    }

  }


  static String? handle_main_options(){
    stdout.writeln('\nVälkommen till Parkeringsappen!\nVad vill du hantera?\n1. Personer\n2. Fordon\n3. Parkeringsplatser\n4. Parkeringar\n5. Avsluta');
    stdout.write('\nVälj ett alternativ (1-5): ');

    List main_options = ['1', '2', '3', '4', '5'];

    String? input = stdin.readLineSync();
    if(input is String && input != null && input.isNotEmpty && main_options.contains(input)){
      if(input == '5'){
        stdout.write('\nProgram avslutad');
        exit(0);
      }
      else {
        return input;
      }
    }
    else {
      stdout.write('\nVälj ett alternativ (1-5): ');
      handle_main_options();
    }


  }


  static handle_selected_option({required String option}) async{

    switch (option) {
      case '1':
        await person_menu.input_handler();
      case '2':
        await vehicle_menu.input_handler();
      case '3':
        await parking_space_menu.input_handler();
      case '4':
        await parking_menu.input_handler();
      default:
      //  executeUnknown();
    }
  }

}