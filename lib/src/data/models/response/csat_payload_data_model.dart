class CsatPayloadDataModel {
  List<BodyCsatPayload>? body;
  dynamic footer;
  dynamic header;

  CsatPayloadDataModel({
    this.body,
    this.footer,
    this.header,
  });

  factory CsatPayloadDataModel.fromJson(Map<String, dynamic> json) => CsatPayloadDataModel(
        body: json["body"] == null ? [] : List<BodyCsatPayload>.from(json["body"]!.map((x) => BodyCsatPayload.fromJson(x))),
        footer: json["footer"],
        header: json["header"],
      );

  Map<String, dynamic> toJson() => {
        "body": body == null ? [] : List<dynamic>.from(body!.map((x) => x.toJson())),
        "footer": footer,
        "header": header,
      };
}

class BodyCsatPayload {
  String? type;
  String? key;
  String? value;
  String? title;
  String? description;
  String? mediaUrl;
  String? url;

  BodyCsatPayload({
    this.type,
    this.key,
    this.value,
    this.title,
    this.description,
    this.mediaUrl,
    this.url,
  });

  factory BodyCsatPayload.fromJson(Map<String, dynamic> json) => BodyCsatPayload(
        type: json["type"],
        key: json["key"],
        value: json["value"],
        title: json["title"],
        description: json["description"],
        mediaUrl: json["media_url"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "key": key,
        "value": value,
        "title": title,
        "description": description,
        "media_url": mediaUrl,
        "url": url,
      };
}
