import 'dart:io';

import 'package:cli/Main_functions.dart';
import 'package:cli/Repositories/Person_repository.dart';
import 'package:cli/Tools.dart';
import 'package:shared/shared.dart';

class person_menu {
  static input_handler({String user_input = ''}) async{
    List main_options = ['1', '2', '3', '4', '5'];
    String? option;
    if(user_input.isNotEmpty){
      option = user_input;
    }
    else {
      stdout.writeln('\nDu har valt att hantera Personer. Vad vill du göra?\n1. Lägg till ny person\n2. Visa alla personer\n3. Uppdatera person\n4. Ta bort person\n5. Gå tillbaka till huvudmenyn');
      stdout.write('\nVälj ett alternativ (1-5): ');
      option = stdin.readLineSync();
    }

    if(option is String && option != null && option.isNotEmpty && main_options.contains(option)){
      switch (option) {
        case '1': // Skapa ny
          try{
            stdout.write('\nSkriv person namn: ');
            String? person_name = stdin.readLineSync();
            stdout.write('Skriv personnummer: ');
            String? person_number = stdin.readLineSync();

            if(person_name != null && person_name.isNotEmpty && person_number != null && person_number.isNotEmpty){
              dynamic person = await PersonRepository.get_person(person_number);

              if(person != null && person is Person){
                print('$person_name existerar redan');
              }
              else {
                bool success = await PersonRepository.add(Person(id: Tools.generateId(), name: person_name ?? '', person_number: person_number ?? ''));
                if(success) {
                  print('$person_name tillagd');
                }
                else {
                  print('Ett fel har inträffat, vänligen försök igen \n');
                  input_handler(user_input: option);
                }
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
          List persons_to_print = await PersonRepository.getAll();
          if(persons_to_print.isNotEmpty){
            print("\nAlla personer:");
            for (var person in persons_to_print) {
              print("Namn: ${person.name}, Personnummer: ${person.person_number}");
            }
            input_handler();
          }
          else {
            print("Inga personer skapade");
            input_handler();
          }

        case '3': // Uppdaera
          stdout.write('Skriv personnummeret för personen du vill uppdatera: ');
          String? person_number = stdin.readLineSync();

          if(person_number != null && person_number.isNotEmpty){
            Person? person = await PersonRepository.get_person(person_number);

            if(person != null){
              stdout.write('\nPerson hittad, Skriv person namn: ');
              String? name = stdin.readLineSync();

              if(name != null && name.isNotEmpty){
                person.name = name ?? '';
                bool success = await PersonRepository.update(person);
                if(success){
                  print('Person ändrad');
                }
                else {
                  print('Kunde inte uppdatera personen, vänligen försök igen \n');
                }
                input_handler();
              }
              else{
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta personen, vänligen försök igen \n');
              input_handler(user_input: option);
            }
          }

        case '4':   // Ta bort

          stdout.write('Skriv personnummeret för personen du vill ta bort: ');
          String? person_number = stdin.readLineSync();

          if(person_number != null && person_number.isNotEmpty){

            Person? person = await PersonRepository.get_person(person_number);

            if(person != null){

              bool result = await PersonRepository.delete(person.id);

              if(result == true){
                print(person.name + ' tog bort');
                input_handler();
              }
              else{
                print('Ett fel har inträffat, vänligen försök igen \n');
                input_handler(user_input: option);
              }

            }
            else {
              print('Kunde inte hitta personen, vänligen försök igen \n');
              input_handler(user_input: option);
            }
          }


        case '5':
          main_functions.start_app();;
        default:
          input_handler();
      }
    }
    else {
      input_handler();
    }


  }

}