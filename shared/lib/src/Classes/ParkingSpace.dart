class ParkingSpace {
  String id;
  String address;
  String number;
  String price;

  ParkingSpace({required this.id, required this.address, required this.number, required this.price});

  Map<String, dynamic> toJson() {
    return {"id": id, "address": address, "number": number, "price": price};
  }

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'] ?? '',
      address: json['address'] ?? '',
      number: json['number'] ?? '',
      price: json['price'] ?? '',
    );
  }
}