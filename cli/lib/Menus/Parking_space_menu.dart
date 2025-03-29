import 'dart:io';

import 'package:cli/Main_functions.dart';
import 'package:cli/Tools.dart';
import 'package:cli/Repositories/Parking_space_repository.dart';
import 'package:shared/shared.dart';

class parking_space_menu {
  static input_handler({String user_input = ''}) async{

    List main_options = ['1', '2', '3', '4', '5'];
    String? option;
    if(user_input.isNotEmpty){
      option = user_input;
    }
    else {
      stdout.writeln('\nDu har valt att hantera parkeringsplatser. Vad vill du göra?\n1. Lägg till ny parkeringsplats\n2. Visa alla parkeringsplatser\n3. Uppdatera parkeringsplats\n4. Ta bort parkeringsplats\n5. Gå tillbaka till huvudmenyn');
      stdout.write('\nVälj ett alternativ (1-5): ');
      option = stdin.readLineSync();
    }

    if(option is String && option != null && option.isNotEmpty && main_options.contains(option)){

      // man ska kunna flytta till koden i varje case till egen funktion
      switch (option) {
        case '1': // Lägg till
          try{
            stdout.write('\nSkriv parkeringsplats adress: ');
            String? address = stdin.readLineSync();

            stdout.write('Skriv parkeringsplats pris: ');
            String? price = stdin.readLineSync();

            stdout.write('Skriv parkeringsplats nummer: ');
            String? number = stdin.readLineSync();



            ParkingSpace? new_parking_space;
            if(address != null &&  address.isNotEmpty && address.isNotEmpty && price != null && price.isNotEmpty && number != null && number.isNotEmpty){
              new_parking_space =  ParkingSpace(id: Tools.generateId(),  address: address ?? '', number: number ?? '', price: price ?? '', );

              var old_parking_space = await ParkingSpaceRepository.get(number);
              if(old_parking_space != null && old_parking_space is ParkingSpace){
                print('Parkiringsplatsen existerar redan, vänligen försök igen \n');
                input_handler(user_input: option);
              }


            }
            else {
              print('Ett fel har inträffat, vänligen försök igen \n');
              input_handler(user_input: option);
            }


            if(new_parking_space != null){
              bool success =  await ParkingSpaceRepository.add(new_parking_space);
              if(success){
                print('Parkeringsplatsen är tillagd \n');
              }
              else {
                print('Ett fel har inträffat, vänligen försök igen \n');
              }

              input_handler();
            }
            else {
              print('Ett fel har inträffat, vänligen försök igen \n');
              input_handler(user_input: option);
            }
          }
          catch(e){
            print('Ett fel har inträffat, vänligen försök igen \n');
            input_handler(user_input: option);
          }
        case '2': // Visa alla
          List parking_spaces_to_print = await ParkingSpaceRepository.get_all();
          if(parking_spaces_to_print.isNotEmpty){
            print("\nAlla parkeringsplatser:");
            for (var park_space in parking_spaces_to_print) {
              if(park_space != null){
                print("Nummer: ${park_space.number}, Adress: ${park_space.address}, Pris: ${park_space.price}\n");
              }
            }
            input_handler();
          }
          else {
            print("Inga parkeringsplatser tillagda");
            input_handler();
          }
        case '3': // Uppdaera
          stdout.write('\nSkriv numret för parkeringsplatsen du vill uppdatera: ');
          String? number = stdin.readLineSync();

          if(number != null && number.isNotEmpty){
            ParkingSpace? parking = await ParkingSpaceRepository.get(number);

            if(parking != null){
              stdout.write('\nParkeringsplats hittad, Ändra adress: ');
              String? address = stdin.readLineSync();


              if(address != null && address.isNotEmpty){
                parking.address = address ?? '';
                bool success = await ParkingSpaceRepository.update(parking);
                if(success){
                  print('Parkeringsplats ändrad');
                }
                else {
                  print('Kunde inte uppdatera parkeringsplatsen, vänligen försök igen');
                }
                input_handler();
              }
              else{
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta parkeringsplatsen, vänligen försök igen');
              input_handler(user_input: option);
            }
          }

        case '4':   // Ta bort

          stdout.write('\nSkriv numret för parkeringsplatsen du vill ta bort: ');
          String? number = stdin.readLineSync();

          if(number != null && number.isNotEmpty){

            ParkingSpace? parking = await ParkingSpaceRepository.get(number);

            if(parking != null){

              bool result = await ParkingSpaceRepository.delete(parking.id);

              if(result == true){
                print('Parkeringen med numret ' + parking.number + ' togs bort');
                input_handler();
              }
              else{
                print('Ett fel har inträffat, vänligen försök igen');
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta parkeringsplatsen, vänligen försök igen');
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