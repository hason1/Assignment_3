import 'dart:io';


String? calculate() {
   stdout.writeln('Type something');
  final input = stdin.readLineSync();
  stdout.writeln('You typed: $input');
  return input;
}
