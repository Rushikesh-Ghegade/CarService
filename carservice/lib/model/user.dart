class GetUserinfo {
  String id;
  String name;
  String emial;
  String image;
  String phone;

  GetUserinfo(
      {required this.id,
      required this.name,
      required this.emial,
      required this.image,
      required this.phone});

  toJson() {
    return {
      "id": id,
      "name": name,
      "email": emial,
      "image": image,
      "phone": phone,
    };
  }
}
