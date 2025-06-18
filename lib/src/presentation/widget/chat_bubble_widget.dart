import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:konnek_native_core/assets/assets.dart';
import 'package:konnek_native_core/src/data/models/response/bot_payload_data_model.dart';
import 'package:konnek_native_core/src/data/models/response/carousel_payload_data_model.dart';
import 'package:konnek_native_core/src/data/models/response/csat_payload_data_model.dart';
import 'package:konnek_native_core/src/data/models/response/get_config_response_model.dart';
import 'package:konnek_native_core/src/data/models/response/get_conversation_response_model.dart';
import 'package:konnek_native_core/src/presentation/controller/app_controller.dart';
import 'package:konnek_native_core/src/presentation/widget/carousel_chat_bubble_widget.dart';
import 'package:konnek_native_core/src/support/app_file_helper.dart';
import 'package:konnek_native_core/src/support/app_image_picker.dart';
import 'package:konnek_native_core/src/support/app_logger.dart';

class ChatBubbleWidget extends StatefulWidget {
  final ConversationList data;
  final DataGetConfig? dataGetConfig;
  final void Function(String srcImage)? openImageCallback;
  final void Function(BodyCsatPayload csatData, ConversationList chatData)? onChooseCsat;
  final void Function(BodyBotPayload botData, ConversationList chatData)? onChooseBotChat;
  final void Function(BodyCarouselPayload carouselData, ConversationList chatData)? onChooseCarousel;

  const ChatBubbleWidget({
    required this.data,
    required this.dataGetConfig,
    this.openImageCallback,
    this.onChooseCsat,
    this.onChooseBotChat,
    this.onChooseCarousel,
    super.key,
  });

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  bool chatCategoryValidation(ConversationList datas) {
    if (datas.fromType == "1") {
      return true;
    } else {
      return false;
    }
  }

  String handleIcon(int status) {
    if (status > 0) {
      return Assets.icDoubleTick;
    } else {
      return Assets.icClock;
    }
  }

  Widget typeChatHandler() {
    if (widget.data.payload != null && widget.data.payload != "") {
      if (widget.data.type == "button") {
        if (widget.data.session!.botStatus!) {
          BotPayloadDataModel botPayloadData = BotPayloadDataModel.fromJson(jsonDecode(widget.data.payload!));
          return Column(
            crossAxisAlignment: chatCategoryValidation(widget.data) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                "${widget.data.text}",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: (botPayloadData.body == null || botPayloadData.body!.isEmpty) ? 0 : botPayloadData.body!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        widget.onChooseBotChat?.call(
                          botPayloadData.body![index],
                          widget.data,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        height: 40,
                        decoration: BoxDecoration(
                          // color: const Color(0xff203080).withValues(alpha: 0.1),
                          color: const Color(0xff203080).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${botPayloadData.body?[index].title}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 8);
                  },
                ),
              ),
              SizedBox(height: 5),
            ],
          );
        } else {
          CsatPayloadDataModel csatPayloadData = CsatPayloadDataModel.fromJson(jsonDecode(widget.data.payload!));
          return Column(
            crossAxisAlignment: chatCategoryValidation(widget.data) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 5),
              IntrinsicWidth(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.data.text}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              IntrinsicWidth(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: (csatPayloadData.body == null || csatPayloadData.body!.isEmpty) ? 0 : csatPayloadData.body!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            widget.onChooseCsat?.call(
                              csatPayloadData.body![index],
                              widget.data,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            height: 40,
                            decoration: BoxDecoration(
                              // color: const Color(0xff203080).withValues(alpha: 0.1),
                              color: const Color(0xff203080).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${csatPayloadData.body?[index].title}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          );
        }
      } else if (widget.data.type == "carousel") {
        CarouselPayloadDataModel? carouselPayloadData = CarouselPayloadDataModel.fromJson(jsonDecode(widget.data.payload!));
        return Column(
          crossAxisAlignment: chatCategoryValidation(widget.data) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              "${widget.data.text}",
              // "here",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            CarouselChatBubbleWidget(
              data: widget.data,
              carouselPayloadData: carouselPayloadData,
              onChooseCarousel: (carouselData, conversationList) {
                widget.onChooseCarousel?.call(
                  carouselData,
                  conversationList,
                );
              },
            ),
            SizedBox(height: 5),
          ],
        );
      } else if (widget.data.type == "image" || widget.data.type == "document" || widget.data.type == "sticker" || widget.data.type == "audio" || widget.data.type == "video") {
        if (AppImagePickerServiceCS().isImageFile(AppFileHelper.getFileNameFromUrl(widget.data.payload!))) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    AppFileHelper.getUrlName(widget.data.payload ?? ""),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    color: Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.data.text ?? "null",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Icon(
                    Icons.file_copy_rounded,
                    color: Colors.black54,
                    size: 100,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    color: Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.data.text ?? "null",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        // Type: text
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.text ?? "null",
                textAlign: TextAlign.left,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.text ?? "null",
              textAlign: TextAlign.left,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chatCategoryValidation(widget.data)) {
      // Client
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: InkWell(
                onTap: () {
                  AppLoggerCS.debugLog("call here");
                  if (widget.data.payload != null || widget.data.payload != "") {
                    if (widget.data.type == "image" || widget.data.type == "document" || widget.data.type == "sticker" || widget.data.type == "audio" || widget.data.type == "video") {
                      widget.openImageCallback?.call(jsonDecode(widget.data.payload ?? "")['url']);
                    }
                  }
                },
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: "${widget.data.text}"));
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 500),
                      backgroundColor: Colors.grey.shade900,
                      content: Text(
                        "Text Copied",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xff2a55a4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              typeChatHandler(),
                              SizedBox(height: 5),
                              IntrinsicWidth(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    DateFormat("hh:mm").format(widget.data.messageTime!.toLocal()),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                      color: Colors.white54,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        handleIcon(widget.data.status ?? 0),
                        color: Colors.white54,
                        height: 15,
                        width: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Admin
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: 5),
              (widget.dataGetConfig != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.memory(
                        AppController.dataGetConfigValue!.avatarImageBit!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      child: Text("SZ"),
                    ),
            ],
          ),
          SizedBox(width: 10),
          Flexible(
            child: InkWell(
              onTap: () {
                if (widget.data.payload != null || widget.data.payload != "") {
                  if (widget.data.type == "image" || widget.data.type == "document" || widget.data.type == "sticker" || widget.data.type == "audio" || widget.data.type == "video") {
                    widget.openImageCallback?.call(jsonDecode(widget.data.payload ?? "")['url']);
                  }
                }
              },
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: "${widget.data.text}"));
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 500),
                    backgroundColor: Colors.grey.shade900,
                    content: Text(
                      "Text Copied",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: const Color(0xff203080).withValues(alpha: 0.2),
                  color: const Color(0xff203080).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    typeChatHandler(),
                    SizedBox(height: 5),
                    Text(
                      DateFormat("hh:mm").format(widget.data.messageTime!.toLocal()),
                      style: GoogleFonts.lato(
                        color: Colors.black45,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
