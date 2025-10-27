class BotPayloadDataModel {
  List<BodyBotPayload>? body;
  FooterBotPayload? footer;
  HeaderBotPayload? header;

  BotPayloadDataModel({
    this.body,
    this.footer,
    this.header,
  });

  factory BotPayloadDataModel.fromJson(Map<String, dynamic> json) => BotPayloadDataModel(
        body: json["body"] == null ? [] : List<BodyBotPayload>.from(json["body"]!.map((x) => BodyBotPayload.fromJson(x))),
        footer: json["footer"] == null ? null : FooterBotPayload.fromJson(json["footer"]),
        header: json["header"] == null ? null : HeaderBotPayload.fromJson(json["header"]),
      );

  Map<String, dynamic> toJson() => {
        "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
        "footer": footer?.toJson(),
        "header": header?.toJson(),
      };
}

class BodyBotPayload {
  String? description;
  String? key;
  String? mediaUrl;
  dynamic payload;
  String? title;
  String? type;
  String? url;
  String? value;

  BodyBotPayload({
    this.description,
    this.key,
    this.mediaUrl,
    this.payload,
    this.title,
    this.type,
    this.url,
    this.value,
  });

  factory BodyBotPayload.fromJson(Map<String, dynamic> json) => BodyBotPayload(
        description: json["description"],
        key: json["key"],
        mediaUrl: json["media_url"],
        payload: json["payload"],
        title: json["title"],
        type: json["type"],
        url: json["url"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "key": key,
        "media_url": mediaUrl,
        "payload": payload,
        "title": title,
        "type": type,
        "url": url,
        "value": value,
      };
}

class FooterBotPayload {
  String? text;
  String? title;

  FooterBotPayload({
    this.text,
    this.title,
  });

  factory FooterBotPayload.fromJson(Map<String, dynamic> json) => FooterBotPayload(
        text: json["text"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "title": title,
      };
}

class HeaderBotPayload {
  String? mediaUrl;
  String? text;
  String? type;

  HeaderBotPayload({
    this.mediaUrl,
    this.text,
    this.type,
  });

  factory HeaderBotPayload.fromJson(Map<String, dynamic> json) => HeaderBotPayload(
        mediaUrl: json["media_url"],
        text: json["text"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "media_url": mediaUrl,
        "text": text,
        "type": type,
      };
}
