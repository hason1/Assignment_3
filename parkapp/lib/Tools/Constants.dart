class constants {

  // Permissions
  static String user_role = 'user';
  static String admin_role = 'admin';

  static String edit_own_vehicles = 'edit_own_vehicles';
  static String edit_own_parking = 'edit_own_parking';

  static List user_permissions = [edit_own_vehicles, edit_own_parking];

  // Vehicle
  static String person_car = 'Personbil';
  static String taxi = 'Taxi';
  static String bus = 'Buss';
  static List<String> vehicle_types = [person_car, taxi, bus];




}