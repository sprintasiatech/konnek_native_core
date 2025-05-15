import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module1/assets/assets.dart';
import 'package:flutter_module1/src/data/models/response/bot_payload_data_model.dart';
import 'package:flutter_module1/src/data/models/response/carousel_payload_data_model.dart';
import 'package:flutter_module1/src/data/models/response/csat_payload_data_model.dart';
import 'package:flutter_module1/src/data/models/response/get_config_response_model.dart';
import 'package:flutter_module1/src/data/models/response/get_conversation_response_model.dart';
import 'package:flutter_module1/src/presentation/controller/app_controller.dart';
import 'package:flutter_module1/src/presentation/widget/carousel_chat_bubble_widget.dart';
import 'package:flutter_module1/src/support/app_file_helper.dart';

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
    // Map<String, dynamic>? userData = await ChatLocalSource().getClientData();
    String name = "";
    String username = "";
    // if (userData != null) {
    name = AppController.nameUser;
    username = AppController.usernameUser;
    // AppLoggerCS.debugLog("AppController.nameUser ${AppController.nameUser}");
    // AppLoggerCS.debugLog("AppController.usernameUser ${AppController.usernameUser}");

    // }
    // if (datas.session?.agent?.id == "00000000-0000-0000-0000-000000000000" && datas.fromType == "1" && datas.user?.name == AppController.nameUser) {
    // if (datas.session?.agent?.id == "00000000-0000-0000-0000-000000000000" && datas.fromType == "1") {
    // if (!(datas.user?.name == name) && !(datas.user?.username == username)) {
    //  if (datas.createdBy == name) {
    // if (datas.user?.name == AppController.nameUser && datas.user?.username == AppController.usernameUser) {
    if (datas.fromType == "1") {
      return true;
    } else {
      return false;
    }
  }

  String handleIcon(int status) {
    // AppLoggerCS.debugLog('status: $status text: ${widget.data.text} messageId: ${widget.data.messageId}');
    // AppLoggerCS.debugLog('text: ${widget.data.text}');
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
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        widget.onChooseBotChat?.call(
                          botPayloadData.body![index],
                          widget.data,
                          // jsonDecode(widget.data.payload!),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        height: 40,
                        decoration: BoxDecoration(
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
              // Text(
              //   // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
              //   widget.data.text ?? "null",
              //   textAlign: TextAlign.left,
              //   style: GoogleFonts.lato(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          );
        } else {
          CsatPayloadDataModel csatPayloadData = CsatPayloadDataModel.fromJson(jsonDecode(widget.data.payload!));
          return Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
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
                      fontSize: 16,
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
              // Text(
              //   // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
              //   widget.data.text ?? "null",
              //   textAlign: TextAlign.left,
              //   style: GoogleFonts.lato(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
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
                fontSize: 16,
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
            // SizedBox.expand(
            // StatefulBuilder(builder: (context, setState) {
            //   int _currentPage = 0;
            //   PageController _pageController = PageController();
            //   return Stack(
            //     children: [
            //       SizedBox(
            //         // width: MediaQuery.of(context).size.width * 0.6,
            //         height: 350,
            //         child: PageView.builder(
            //           // child: ListView.separated(
            //           controller: _pageController,
            //           // shrinkWrap: true,
            //           scrollDirection: Axis.horizontal,
            //           itemCount: (carouselPayloadData.body == null || carouselPayloadData.body!.isEmpty) ? 0 : carouselPayloadData.body!.length,
            //           itemBuilder: (context, index) {
            //             return SingleChildScrollView(
            //               child: Column(
            //                 children: [
            //                   ClipRRect(
            //                     borderRadius: BorderRadius.circular(8.0),
            //                     child: Image.network(
            //                       "${carouselPayloadData.body?[index].mediaUrl}",
            //                       // AppFileHelper.getUrlName(widget.data.payload ?? ""),
            //                       // AppFileHelper.getUrlName(widget.data.payload ?? ""),
            //                       height: 200,
            //                       // width: 100,
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                   SizedBox(height: 10),
            //                   Text(
            //                     "${carouselPayloadData.body?[index].title}",
            //                     textAlign: TextAlign.center,
            //                     style: GoogleFonts.lato(
            //                       color: Colors.black87,
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w700,
            //                     ),
            //                   ),
            //                   SizedBox(height: 5),
            //                   Text(
            //                     "${carouselPayloadData.body?[index].description}",
            //                     textAlign: TextAlign.center,
            //                     style: GoogleFonts.lato(
            //                       color: Colors.black87,
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                   ),
            //                   SizedBox(height: 15),
            //                   InkWell(
            //                     onTap: () {
            //                       // AppController.isRoomClosed = false;
            //                       widget.onChooseCarousel?.call(
            //                         carouselPayloadData.body![index],
            //                         widget.data,
            //                       );
            //                     },
            //                     child: Container(
            //                       padding: EdgeInsets.symmetric(
            //                         vertical: 6,
            //                         horizontal: 12,
            //                       ),
            //                       height: 40,
            //                       decoration: BoxDecoration(
            //                         color: const Color(0xff203080).withOpacity(0.1),
            //                         borderRadius: BorderRadius.circular(8),
            //                       ),
            //                       child: Text(
            //                         "${carouselPayloadData.body?[index].title}",
            //                         textAlign: TextAlign.center,
            //                         style: GoogleFonts.lato(
            //                           color: Colors.black87,
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //           // separatorBuilder: (context, index) {
            //           //   return SizedBox(width: 10);
            //           // },
            //         ),
            //       ),
            //       Container(
            //         // color: Colors.red,
            //         height: 350,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             InkWell(
            //               onTap: () {
            //                 if (_pageController.hasClients) {
            //                   _pageController.previousPage(
            //                     duration: const Duration(milliseconds: 400),
            //                     curve: Curves.easeInOut,
            //                   );
            //                 }
            //               },
            //               child: Icon(
            //                 Icons.arrow_circle_left_outlined,
            //                 size: 50,
            //                 color: Colors.grey,
            //               ),
            //             ),
            //             InkWell(
            //               onTap: () {
            //                 if (_pageController.hasClients) {
            //                   _pageController.nextPage(
            //                     duration: const Duration(milliseconds: 400),
            //                     curve: Curves.easeInOut,
            //                   );
            //                 }
            //               },
            //               child: Icon(
            //                 Icons.arrow_circle_right_outlined,
            //                 size: 50,
            //                 color: Colors.grey,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   );
            // }),
            SizedBox(height: 5),
            // Text(
            //   // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
            //   widget.data.text ?? "null",
            //   textAlign: TextAlign.left,
            //   style: GoogleFonts.lato(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        );
      } else if (widget.data.type == "image" || widget.data.type == "document" || widget.data.type == "sticker") {
        if (AppImagePickerServiceCS().isImageFile(AppFileHelper.getFileNameFromUrl(widget.data.payload!))) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // crossAxisAlignment: chatCategoryValidation(widget.data) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    // "https://cms.shootingstar.id/74/main.jpg",
                    // jsonDecode(widget.data.payload ?? "")['url'],
                    AppFileHelper.getUrlName(widget.data.payload ?? ""),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  // "${widget.data.payload}",
                  AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                  textAlign: TextAlign.left,
                  // textAlign: chatCategoryValidation(widget.data) ? TextAlign.right : TextAlign.left,
                  style: GoogleFonts.lato(
                    color: Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
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
              // crossAxisAlignment: chatCategoryValidation(widget.data) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                  // "${widget.data.payload}",
                  AppFileHelper.getFileNameFromUrl(widget.data.payload ?? ""),
                  // textAlign: chatCategoryValidation(widget.data) ? TextAlign.right : TextAlign.left,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    color: Colors.black45,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
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
        // AppLoggerCS.debugLog("Panggil di sini: ${widget.data.text}");
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
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
              // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
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
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(width: 10),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: InkWell(
                onTap: () {
                  AppLoggerCS.debugLog("call here");
                  if (widget.data.payload != null || widget.data.payload != "") {
                    if (widget.data.type == "image" || widget.data.type == "document" || widget.data.type == "sticker") {
                      // if ((jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".jpg") || (jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".png")) {
                      // if (AppImagePickerServiceCS().isImageFile(getUrlName(widget.data.payload ?? ""))) {
                      widget.openImageCallback?.call(jsonDecode(widget.data.payload ?? "")['url']);
                      // }
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // color: Colors.purpleAccent.shade200.withOpacity(0.3),
                    color: const Color(0xff2a55a4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.end,
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
                              // Text(
                              //   // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
                              //   widget.data.text ?? "null",
                              //   textAlign: TextAlign.left,
                              //   style: GoogleFonts.lato(
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),
                              SizedBox(height: 5),
                              IntrinsicWidth(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    // "15:29",
                                    // "${DateTime.now().hour}:${DateTime.now().minute}",
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
          // SizedBox(width: 10),
          // Column(
          //   children: [
          //     SizedBox(height: 5),
          //     CircleAvatar(
          //       backgroundColor: Colors.purpleAccent,
          //       child: Text("FM"),
          //     ),
          //   ],
          // ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(width: 10),
          Column(
            children: [
              SizedBox(height: 5),
              (widget.dataGetConfig != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.memory(
                        AppController.dataGetConfigValue!.avatarImageBit!,
                        // Uri.parse(widget.dataGetConfig!.avatarImage!).data!.contentAsBytes(),
                        // base64Decode(dataGetConfig!.avatarImage!),
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
                AppLoggerCS.debugLog("call here 2");
                if (widget.data.payload != null || widget.data.payload != "") {
                  if (widget.data.type == "image" || widget.data.type == "document" || widget.data.type == "sticker") {
                    // if ((jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".jpg") || (jsonDecode(widget.data.payload ?? "")['url'] as String).endsWith(".png")) {
                    // if (AppImagePickerServiceCS().isImageFile(getUrlName(widget.data.payload ?? ""))) {
                    widget.openImageCallback?.call(jsonDecode(widget.data.payload ?? "")['url']);
                    // }
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // color: Colors.purpleAccent.shade200.withOpacity(0.3),
                  color: const Color(0xff203080).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    typeChatHandler(),
                    // Text(
                    //   widget.data.text ?? "null",
                    //   // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
                    //   style: GoogleFonts.lato(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    SizedBox(height: 5),
                    Text(
                      // "15:29",
                      // "${DateTime.now().hour}:${DateTime.now().minute}",
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
