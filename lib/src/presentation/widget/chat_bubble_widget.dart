import 'dart:convert';

import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_module1/src/data/models/response/get_config_response_model.dart';
import 'package:flutter_module1/src/data/models/response/get_conversation_response_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubbleWidget extends StatefulWidget {
  final ConversationList data;
  final DataGetConfig? dataGetConfig;

  const ChatBubbleWidget({
    required this.data,
    required this.dataGetConfig,
    super.key,
  });

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.session?.agent?.id == "00000000-0000-0000-0000-000000000000" && widget.data.fromType == "1") {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                // color: Colors.purpleAccent.shade200.withOpacity(0.3),
                color: const Color(0xff2a55a4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.data.payload != null && widget.data.payload != "")
                    Column(
                      children: [
                        Image.network(
                          // "https://cms.shootingstar.id/74/main.jpg",
                          jsonDecode(widget.data.payload ?? "")['url'],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  Text(
                    // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
                    widget.data.text ?? "null",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    // "15:29",
                    // "${DateTime.now().hour}:${DateTime.now().minute}",
                    DateFormat("hh:mm").format(widget.data.messageTime!.toLocal()),
                    style: GoogleFonts.lato(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
                  ? Image.memory(
                      Uri.parse(widget.dataGetConfig!.avatarImage!).data!.contentAsBytes(),
                      // base64Decode(dataGetConfig!.avatarImage!),
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      child: Text("FM"),
                    ),
            ],
          ),
          SizedBox(width: 10),
          Flexible(
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
                  if (widget.data.payload != null && widget.data.payload != "")
                    Column(
                      children: [
                        Image.network(
                          // "https://cms.shootingstar.id/74/main.jpg",
                          jsonDecode(widget.data.payload ?? "")['url'],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  Text(
                    widget.data.text ?? "null",
                    // (index.isEven) ? "Here we go $index" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    // "15:29",
                    "${DateTime.now().hour}:${DateTime.now().minute}",
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
        ],
      );
    }
  }
}
