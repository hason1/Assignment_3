
import 'dart:io';

class Tools {
  static String? get_valid_time_user_input({required String text}) {
    final RegExp timePattern = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$'); // Format ska vara HH:mm

    while (true) {
      stdout.write('Skriv ' + text + ' : ');
      String? input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        print("Fel: Du måste ange en tid.");
        continue;
      }

      if (!timePattern.hasMatch(input)) {
        print("Fel: Ange en giltig tid i formatet HH:mm (t.ex. 16:00).");
        continue;
      }

      return input;
    }
  }

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
