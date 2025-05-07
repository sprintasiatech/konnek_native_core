import 'package:flutter/material.dart';
import 'package:flutter_module1/src/data/models/response/carousel_payload_data_model.dart';
import 'package:flutter_module1/src/data/models/response/get_conversation_response_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselChatBubbleWidget extends StatefulWidget {
  final ConversationList data;
  final CarouselPayloadDataModel carouselPayloadData;
  final void Function(BodyCarouselPayload carouselData, ConversationList conversationList)? onChooseCarousel;

  const CarouselChatBubbleWidget({
    super.key,
    required this.data,
    required this.carouselPayloadData,
    required this.onChooseCarousel,
  });

  @override
  State<CarouselChatBubbleWidget> createState() => _CarouselChatBubbleWidgetState();
}

class _CarouselChatBubbleWidgetState extends State<CarouselChatBubbleWidget> {
  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          // width: MediaQuery.of(context).size.width * 0.6,
          height: 350,
          child: PageView.builder(
            // child: ListView.separated(
            controller: _pageController,
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: (widget.carouselPayloadData.body == null || widget.carouselPayloadData.body!.isEmpty) ? 0 : widget.carouselPayloadData.body!.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        "${widget.carouselPayloadData.body?[index].mediaUrl}",
                        // AppFileHelper.getUrlName(widget.data.payload ?? ""),
                        // AppFileHelper.getUrlName(widget.data.payload ?? ""),
                        height: 200,
                        // width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${widget.carouselPayloadData.body?[index].title}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${widget.carouselPayloadData.body?[index].description}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        // AppController.isRoomClosed = false;
                        widget.onChooseCarousel?.call(
                          widget.carouselPayloadData.body![index],
                          widget.data,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xff203080).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${widget.carouselPayloadData.body?[index].actions?[0].title}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            // separatorBuilder: (context, index) {
            //   return SizedBox(width: 10);
            // },
          ),
        ),
        Container(
          // color: Colors.red,
          height: 350,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (_pageController.hasClients) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Icon(
                  Icons.arrow_circle_left_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  if (_pageController.hasClients) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Icon(
                  Icons.arrow_circle_right_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
