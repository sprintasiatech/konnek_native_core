class SendChatRequestModel {
  String name;
  String? text;
  String username;

  SendChatRequestModel({
    required this.name,
    this.text,
    required this.username,
  });

  factory SendChatRequestModel.fromJson(Map<String, dynamic> json) => SendChatRequestModel(
        name: json["name"],
        text: json["text"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "text": text,
        "username": username,
      };

  Map<String, dynamic> toJson2() => {
        "name": name,
        "username": username,
      };
}
