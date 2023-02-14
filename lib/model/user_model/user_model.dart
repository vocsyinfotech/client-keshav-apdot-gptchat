class UserModel {
  UserModel({
    this.isPremium = false,
    this.textCount = 0,
    this.imageCount = 0,
    this.planExpiryDate = "2023-01-01",
    required this.isActive,
    required this.email,
    required this.imageUrl,
    required this.uniqueId,
    required this.name,
    required this.phoneNumber,
  });

  bool isActive;
  bool isPremium;
  String planExpiryDate;
  String email;
  String imageUrl;
  String uniqueId;
  String name;
  String phoneNumber;
  int textCount;
  int imageCount;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        isPremium: json["isPremium"],
        isActive: json["isActive"],
        email: json["email"],
        imageUrl: json["image_url"],
        uniqueId: json["unique_id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        textCount: json["textCount"],
        imageCount: json["imageCount"],
        planExpiryDate: json["planExpiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "isPremium": isPremium,
        "isActive": isActive,
        "email": email,
        "image_url": imageUrl,
        "unique_id": uniqueId,
        "name": name,
        "phoneNumber": phoneNumber,
        "textCount": textCount,
        "imageCount": imageCount,
        "planExpiryDate" : planExpiryDate,
      };
}
