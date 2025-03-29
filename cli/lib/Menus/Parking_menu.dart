import 'dart:io';

import 'package:cli/Main_functions.dart';
import 'package:cli/Repositories/Person_repository.dart';
import 'package:cli/Tools.dart';
import 'package:cli/Repositories/Parking_repository.dart';
import 'package:cli/Repositories/Vehicle_repository.dart';
import 'package:shared/shared.dart';
import '../Repositories/Parking_space_repository.dart';

class parking_menu {
  static input_handler({String user_input = ''}) async{

    List main_options = ['1', '2', '3', '4', '5', '6'];
    String? option;
    if(user_input.isNotEmpty){
      option = user_input;
    }
    else {
      stdout.writeln('\nDu har valt att hantera Parkeringar. Vad vill du göra?\n1. Lägg till ny parkering\n2. Visa alla parkeringar\n3. Ändra parkeringsplats\n4. Ändra fordon\n5. Ändra start och slut\n6. Ta bort parkering\n6. Gå tillbaka till huvudmenyn');
      stdout.write('\nVälj ett alternativ (1-7): ');
      option = stdin.readLineSync();
    }

    if(option is String && option != null && option.isNotEmpty && main_options.contains(option)){

      // man ska kunna flytta till koden i varje case till egen funktion
      switch (option) {
        case '1': // Lägg till
          try{

            stdout.write('Skriv fordonet registreringsnummer: ');
            String? reg_number = stdin.readLineSync();

            stdout.write('Skriv parkeringsplats nummer: ');
            String? park_space_number = stdin.readLineSync();

            stdout.write('Skriv personnummeret: ');
            String? person_number = stdin.readLineSync();

            Vehicle? vehicle;
            ParkingSpace? parking_space;
            Person? person;
            if(reg_number != null && reg_number.isNotEmpty && park_space_number != null && park_space_number.isNotEmpty && person_number != null && person_number.isNotEmpty){
              parking_space =  await ParkingSpaceRepository.get(park_space_number);
              vehicle = await VehicleRepository.get_vehicle(reg_number);
              person = await PersonRepository.get_person(person_number);
            }
            else {
              print('Fyll i parkeringsplatsnummer, fordonsnummer eller personnumret, vänligen försök igen \n');
              input_handler(user_input: option);
            }

            if(parking_space == null || vehicle == null){
              print('Parkeringsplatsen, fordonet eller personen existerar inte, fordon och parkering platsen måste existera för att lägga parkeringen. vänligen försök igen \n');
              input_handler();
            }


            String? start_time = Tools.get_valid_time_user_input(text: 'starttid (t.ex. 16:00)');
            String? end_time = Tools.get_valid_time_user_input(text: 'sluttid (t.ex. 17:30)');


            if(vehicle != null && parking_space != null && person != null && start_time != null && start_time.isNotEmpty && end_time != null && end_time.isNotEmpty ){
              Parking parking = Parking(id: Tools.generateId(), parking_number: Tools.generateId().substring(0, 5), vehicle_id: vehicle.id, parking_space_id: parking_space.id, person_id: person.id, start_time: start_time, end_time: end_time);
              bool success = await ParkingRepository.add(parking);
              if(success){
                print('\nParkeringen är skapad \n');
              }
              else {
                print('\n Ett fel har inträffat, vänligen försök igen \n');
                input_handler(user_input: option);
              }


              input_handler();
            }
            else {
              print('\n Ett fel har inträffat, vänligen försök igen \n');
              input_handler(user_input: option);
            }
          }
          catch(e){
            print('\n Ett fel har inträffat, vänligen försök igen \n');
            input_handler(user_input: option);
          }
        case '2': // Visa alla
          List parkings_to_print = await ParkingRepository.getAll();
          if(parkings_to_print.isNotEmpty){
            print("\nAlla parkeringar:");
            for (Parking parking in parkings_to_print) {
              print("Parkerings nummer: ${parking.parking_number}");

              if(parking.vehicle_id != null){
                Vehicle? vehicle = await VehicleRepository.get_vehicle(parking.vehicle_id);
                if(vehicle != null && vehicle is Vehicle){
                  print("Fordonet: Regnummer: ${vehicle.registration_number}, Typ: ${vehicle.type}");
                }
                else {
                  print('OBS: kunde inte hitta fordonet i systemet');
                }
              }

              if(parking.parking_space_id != null){
                ParkingSpace? parking_space =  await ParkingSpaceRepository.get(parking.parking_space_id);

                if(parking_space != null && parking_space is ParkingSpace){
                  print("Parkeringplatsen: Adress: ${parking_space.address}, Pris: ${parking_space.price}, Nummer: ${parking_space.number}");
                }
                else {
                  print('OBS: kunde inte hitta parkeringsplatsen i systemet');
                }
              }


              if(parking.person_id != null){
                Person? person = await PersonRepository.get_person(parking.person_id);

                if(person != null && person is Person){
                  print("Person: Namn: ${person.name}, Personnummer: ${person.person_number}");
                }
                else {
                  print('OBS: kunde inte hitta personen i systemet');
                }
              }


              if(parking.start_time != null && parking.end_time != null){
                print("Starttid: ${parking.start_time}, Sluttid: ${parking.end_time}\n");
              }


            }
            input_handler();
          }
          else {
            print("Inga parkeringar tillagda");
            input_handler();
          }

        case '3':
          stdout.write('Skriv numret för parkeringen du vill uppdatera: ');
          String? number = stdin.readLineSync();

          if(number != null && number.isNotEmpty){
            Parking? parking = await ParkingRepository.get_parking(number);

            if(parking != null){
              stdout.write('Skriv parkeringsplats nummeret du vill ändra till: ');
              String? park_space_number = stdin.readLineSync();

              if(park_space_number != null && park_space_number.isNotEmpty){
                ParkingSpace? parking_space =  await ParkingSpaceRepository.get(park_space_number);

                if(parking_space == null){
                  print('Parkeringsplatsen existerar inte, vänligen försök igen \n');

                }
                else {
                  parking.parking_space_id = parking_space.id;
                  bool success =  await ParkingRepository.update(parking);
                  if(success){
                    print('Parkeringsplatsen ändrad');
                  }
                  else{
                    print('Kunde inte ändra parkeringsplatsen, vänligen försök igen \n');
                  }
                }

                input_handler();

              }
              else{
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta parkeringen, vänligen försök igen \n');
              input_handler(user_input: option);
            }
          }

        case '4':
          stdout.write('Skriv numret för parkeringen du vill uppdatera: ');
          String? number = stdin.readLineSync();

          if(number != null && number.isNotEmpty){
            Parking? parking = await ParkingRepository.get_parking(number);

            if(parking != null){
              stdout.write('Skriv fordonets regnummer du vill ändra till: ');
              String? vehicle_number = stdin.readLineSync();

              if(vehicle_number != null && vehicle_number.isNotEmpty){
                Vehicle? vehicle =  await VehicleRepository.get_vehicle(vehicle_number);

                if(vehicle == null){
                  print('Fordonet existerar inte, vänligen försök igen \n');

                }
                else {
                  parking.vehicle_id = vehicle.id;
                  bool success =  await ParkingRepository.update(parking);
                  if(success){
                    print('Fordonet ändrades');
                  }
                  else{
                    print('Kunde inte ändra fordonet, vänligen försök igen \n');
                  }
                }

                input_handler();

              }
              else{
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta parkeringen, vänligen försök igen \n');
              input_handler(user_input: option);
            }
          }

        case '5':
          stdout.write('Skriv numret för parkeringen du vill uppdatera: ');
          String? number = stdin.readLineSync();

          if(number != null && number.isNotEmpty){
            Parking? parking = await ParkingRepository.get_parking(number);

            if(parking != null){
              String? start_time = Tools.get_valid_time_user_input(text: 'starttid (t.ex. 16:00)');
              String? end_time = Tools.get_valid_time_user_input(text: 'sluttid (t.ex. 17:30)');

              if(start_time != null && start_time.isNotEmpty && end_time != null && end_time.isNotEmpty){
                parking.start_time = start_time;
                parking.end_time = end_time;
                bool success =  await ParkingRepository.update(parking);
                if(success){
                  print('Tiden ändrades');
                }
                else{
                  print('Kunde inte ändra tiden, vänligen försök igen \n');
                }

                input_handler();
              }
              else {
                print('Kunde inte hitta parkeringen, vänligen försök igen \n');
                input_handler(user_input: option);
              }


            }
            else {
              print('Kunde inte hitta parkeringen, vänligen försök igen \n');
              input_handler(user_input: option);
            }
          }

        case '6':
            stdout.write('Skriv numret för parkeringen du vill ta bort: ');
            String? number = stdin.readLineSync();

            if(number != null && number.isNotEmpty){
              Parking? parking = await ParkingRepository.get_parking(number);

              if(parking != null){
                bool success =  await ParkingRepository.delete(parking.id);
                if(success){
                  print('Parkeringsplatsen ' + parking.parking_number.toString() + ' tog');
                }
                else{
                  print('Kunde inte ta bort parkeringsplatsen, vänligen försök igen \n');
                }

                  input_handler();

                }
                else{
                  input_handler(user_input: option);
                }

              }
              else {
                print('Kunde inte hitta parkeringen, vänligen försök igen \n');
                input_handler(user_input: option);
              }
        case '7':
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