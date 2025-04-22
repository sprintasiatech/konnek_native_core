class GetConfigResponseModel {
  MetaGetConfig? meta;
  DataGetConfig? data;

  GetConfigResponseModel({
    this.meta,
    this.data,
  });

  factory GetConfigResponseModel.fromJson(Map<String, dynamic> json) => GetConfigResponseModel(
        meta: json["meta"] == null ? null : MetaGetConfig.fromJson(json["meta"]),
        data: json["data"] == null ? null : DataGetConfig.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
      };
}

class DataGetConfig {
  String? avatarImage;
  String? avatarName;
  String? background;
  String? backgroundStatus;
  String? buttonColor;
  String? companyId;
  String? greetingMessage;
  String? headerBackgroundColor;
  String? headerTextColor;
  String? preview;
  bool? status;
  String? textButton;
  String? textButtonColor;
  String? widgetIcon;

  DataGetConfig({
    this.avatarImage,
    this.avatarName,
    this.background,
    this.backgroundStatus,
    this.buttonColor,
    this.companyId,
    this.greetingMessage,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.preview,
    this.status,
    this.textButton,
    this.textButtonColor,
    this.widgetIcon,
  });

  factory DataGetConfig.fromJson(Map<String, dynamic> json) => DataGetConfig(
        avatarImage: json["avatar_image"],
        avatarName: json["avatar_name"],
        background: json["background"],
        backgroundStatus: json["background_status"],
        buttonColor: json["button_color"],
        companyId: json["company_id"],
        greetingMessage: json["greeting_message"],
        headerBackgroundColor: json["header_background_color"],
        headerTextColor: json["header_text_color"],
        preview: json["preview"],
        status: json["status"],
        textButton: json["text_button"],
        textButtonColor: json["text_button_color"],
        widgetIcon: json["widget_icon"],
      );

  Map<String, dynamic> toJson() => {
        "avatar_image": avatarImage,
        "avatar_name": avatarName,
        "background": background,
        "background_status": backgroundStatus,
        "button_color": buttonColor,
        "company_id": companyId,
        "greeting_message": greetingMessage,
        "header_background_color": headerBackgroundColor,
        "header_text_color": headerTextColor,
        "preview": preview,
        "status": status,
        "text_button": textButton,
        "text_button_color": textButtonColor,
        "widget_icon": widgetIcon,
      };
}

class MetaGetConfig {
  bool? status;
  int? code;
  String? message;
  String? logId;
  dynamic errors;

  MetaGetConfig({
    this.status,
    this.code,
    this.message,
    this.logId,
    this.errors,
  });

  factory MetaGetConfig.fromJson(Map<String, dynamic> json) => MetaGetConfig(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        logId: json["log_id"],
        errors: json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "log_id": logId,
        "errors": errors,
      };
}
