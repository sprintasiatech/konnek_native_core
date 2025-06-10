class CarouselPayloadDataModel {
  List<BodyCarouselPayload>? body;
  FooterCarouselPayload? footer;
  HeaderCarouselPayload? header;

  CarouselPayloadDataModel({
    this.body,
    this.footer,
    this.header,
  });

  factory CarouselPayloadDataModel.fromJson(Map<String, dynamic> json) => CarouselPayloadDataModel(
        body: json["body"] == null ? [] : List<BodyCarouselPayload>.from(json["body"]!.map((x) => BodyCarouselPayload.fromJson(x))),
        footer: json["footer"] == null ? null : FooterCarouselPayload.fromJson(json["footer"]),
        header: json["header"] == null ? null : HeaderCarouselPayload.fromJson(json["header"]),
      );

  Map<String, dynamic> toJson() => {
        "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
        "footer": footer?.toJson(),
        "header": header?.toJson(),
      };
}

class BodyCarouselPayload {
  List<Action>? actions;
  String? description;
  String? mediaUrl;
  String? title;

  BodyCarouselPayload({
    this.actions,
    this.description,
    this.mediaUrl,
    this.title,
  });

  factory BodyCarouselPayload.fromJson(Map<String, dynamic> json) => BodyCarouselPayload(
        actions: json["actions"] == null ? [] : List<Action>.from(json["actions"]!.map((x) => Action.fromJson(x))),
        description: json["description"],
        mediaUrl: json["media_url"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "actions": actions == null ? [] : List<dynamic>.from(actions!.map((x) => x.toJson())),
        "description": description,
        "media_url": mediaUrl,
        "title": title,
      };
}

class Action {
  String? description;
  String? key;
  String? mediaUrl;
  Payload? payload;
  String? title;
  String? type;
  String? url;
  String? value;

  Action({
    this.description,
    this.key,
    this.mediaUrl,
    this.payload,
    this.title,
    this.type,
    this.url,
    this.value,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        description: json["description"],
        key: json["key"],
        mediaUrl: json["media_url"],
        payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
        title: json["title"],
        type: json["type"],
        url: json["url"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "key": key,
        "media_url": mediaUrl,
        "payload": payload?.toJson(),
        "title": title,
        "type": type,
        "url": url,
        "value": value,
      };
}

class Payload {
  String? key;
  String? menu;

  Payload({
    this.key,
    this.menu,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        key: json["key"],
        menu: json["menu"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "menu": menu,
      };
}

class FooterCarouselPayload {
  String? text;
  String? title;

  FooterCarouselPayload({
    this.text,
    this.title,
  });

  factory FooterCarouselPayload.fromJson(Map<String, dynamic> json) => FooterCarouselPayload(
        text: json["text"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "title": title,
      };
}

class HeaderCarouselPayload {
  String? mediaUrl;
  String? text;
  String? type;

  HeaderCarouselPayload({
    this.mediaUrl,
    this.text,
    this.type,
  });

  factory HeaderCarouselPayload.fromJson(Map<String, dynamic> json) => HeaderCarouselPayload(
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
