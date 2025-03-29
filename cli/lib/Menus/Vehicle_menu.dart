import 'dart:io';

import 'package:cli/Main_functions.dart';
import 'package:cli/Repositories/Person_repository.dart';
import 'package:cli/Repositories/Vehicle_repository.dart';
import 'package:shared/shared.dart';

import '../Tools.dart';

class vehicle_menu {
  static input_handler({String user_input = ''}) async{

    List main_options = ['1', '2', '3', '4', '5'];
    String? option;
    if(user_input.isNotEmpty){
      option = user_input;
    }
    else {
      stdout.writeln('\nDu har valt att hantera Fordon. Vad vill du göra?\n1. Lägg till nytt fordon\n2. Visa alla fordon\n3. Ändra fordon ägare\n4. Ta bort fordon\n5. Gå tillbaka till huvudmenyn');
      stdout.write('\nVälj ett alternativ (1-5): ');
      option = stdin.readLineSync();
    }

    if(option is String && option != null && option.isNotEmpty && main_options.contains(option)){

      // man ska kunna flytta till koden i varje case till egen funktion
      switch (option) {
        case '1': // Lägg till
          try{
            stdout.write('\nSkriv registrering nummer: ');
            String? reg_number = stdin.readLineSync();




            Vehicle? new_vehicle;
            if(reg_number != null && reg_number.isNotEmpty){
              dynamic vehicle = await VehicleRepository.get_vehicle(reg_number);

              if(vehicle != null && vehicle is Vehicle){
                print('\nFordonet existrerar redan, vänligen försök igen');
                input_handler(user_input: user_input);
              }

            }

            stdout.write('Skriv fordon typ: ');
            String? type = stdin.readLineSync();


            stdout.write('Skriv ägarens personnummer: ');
            String? person_number = stdin.readLineSync();

            new_vehicle =  Vehicle(id: Tools.generateId(), registration_number: reg_number ?? '', type: type ?? '', );
            bool success = await VehicleRepository.add(new_vehicle);
            if(success){
              print('Bilen är tillgad');
            }
            else {
              print('Kunde inte lägga bilen, vänligen försök igen');
              input_handler();
            }

            if(success && person_number != null && person_number.isNotEmpty){
              dynamic person = await PersonRepository.get_person(person_number);

              if(person != null && person is Person){
                new_vehicle.person_id = person.id;
                bool success =  await VehicleRepository.update(new_vehicle);
                if(success){
                  print('Ägaren är tillagd till bilen');
                }
                else {
                  print('Kunde inte ändra ägaren');
                }
              }
              else {
                print('Kunde inte hitta personen');
              }


              input_handler();
            }
            else {
              input_handler();
            }

          }
          catch(e){
            print('Ett fel har inträffat, vänligen försök igen \n');
            input_handler(user_input: option);
          }
        case '2': // Visa alla
          List vehicles_to_print = await VehicleRepository.get_all();
          if(vehicles_to_print.isNotEmpty){
            print("\nAlla fordon:");
            for (Vehicle vehicle in vehicles_to_print) {
              if(vehicle != null){
                print("Regnummer: ${vehicle.registration_number}, Typ: ${vehicle.type}");
                if(vehicle.person_id != null && vehicle.person_id!.isNotEmpty){
                  dynamic person = await PersonRepository.get_person(vehicle.person_id.toString());
                  if(person != null && person is Person){
                    print("Ägaersnamn: ${person.name}");
                  }
                }
              }
            }
            input_handler();
          }
          else {
            print("Inga bilar tillagda");
            input_handler();
          }
        case '3': // Uppdaera
          stdout.write('\nSkriv regnumret för fordonet du vill uppdatera: ');
          String? reg_number = stdin.readLineSync();

          if(reg_number != null && reg_number.isNotEmpty){
            Vehicle? vehicle = await VehicleRepository.get_vehicle(reg_number);

            if(vehicle != null){
              print('Bilen hittad');

              stdout.write('Skriv ägarens personnummer: ');
              String? person_number = stdin.readLineSync();

              if(person_number != null && person_number.isNotEmpty){
                dynamic person = await PersonRepository.get_person(person_number);
                if(person != null  && person is Person){
                  vehicle.person_id = person.id.toString();
                   bool success = await VehicleRepository.update(vehicle);
                   if(success) {
                     print('Ägarens ändrad');
                   }
                   else {
                     print('Kunde inte uppdatera fordonet, vänligen försök igen');
                   }
                }
                else {
                  print('Personen är inte registrerad i systemet');
                }

                input_handler();
              }
              else{
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta fordonet, vänligen försök igen');
              input_handler(user_input: option);
            }
          }

        case '4':   // Ta bort

          stdout.write('\nSkriv regnumret för fordonet du vill ta bort: ');
          String? reg_number = stdin.readLineSync();

          if(reg_number != null && reg_number.isNotEmpty){

            Vehicle? vehicle = await VehicleRepository.get_vehicle(reg_number);

            if(vehicle != null){

              bool result = await VehicleRepository.delete(vehicle.id);

              if(result == true){
                print(vehicle.registration_number + ' tog bort');
                input_handler();
              }
              else{
                print('Kunde inte radera bilen eller bilen kanske redan raderad, vänligen försök igen');
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta fordonet, vänligen försök igen');
              input_handler(user_input: option);
            }
          }


        case '5':
          main_functions.start_app();
        default:
          main_functions.start_app();
      }
    }
    else {
      input_handler();
    }


  }
}