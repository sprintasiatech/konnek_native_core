import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konnek_native_core/assets/assets.dart';
import 'package:konnek_native_core/inter_module.dart';
import 'package:konnek_native_core/src/data/models/response/get_conversation_response_model.dart';
import 'package:konnek_native_core/src/data/source/local/chat_local_source.dart';
import 'package:konnek_native_core/src/presentation/controller/app_controller.dart';
import 'package:konnek_native_core/src/presentation/controller/chat_controller.dart';
import 'package:konnek_native_core/src/presentation/widget/chat_bubble_widget.dart';
import 'package:konnek_native_core/src/presentation/widget/show_image_widget.dart';
import 'package:konnek_native_core/src/support/app_file_picker.dart';
import 'package:konnek_native_core/src/support/app_image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  TextEditingController textController = TextEditingController();
  bool isTextFieldFocused = false;
  bool isTextFieldEmpty = true;

  bool isLoading = false;

  late List<ChatItem> _chatItems;

  final ValueNotifier<bool> _showToggleButton = ValueNotifier(false);

  void scrollListenerFunc() {
    if (_scrollController.position.pixels > 100.0) {
      _showToggleButton.value = true;
    } else {
      _showToggleButton.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListenerFunc);
    _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);

    // AppController.isRoomClosed = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _scrollToBottom();

      if (AppController.isWebSocketStart == false) {
        AppController.onSocketChatCalled = () async {
          // AppLoggerCS.debugLog("[onSocketChatStatusCalled]");
          await ChatLocalSource().setSocketReady(true);
          AppController.socketReady = true;
          _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          if (mounted) {
            setState(() {});
          }
        };
        AppController.onSocketChatStatusCalled = () {
          // AppLoggerCS.debugLog("[onSocketChatStatusCalled]");
          _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          if (mounted) {
            setState(() {});
          }
          if (AppController.isRoomClosed == RoomCloseState.closeWaiting) {
            AppController.isWebSocketStart = false;
            AppController.isRoomClosed = RoomCloseState.close;
            Future.delayed(Duration(milliseconds: 500), () {
              AppController.clearRoomClosed();
              // AppController.disconnectSocket();
            });
          }
        };
        AppController.onSocketRoomHandoverCalled = () {
          // AppLoggerCS.debugLog("[onSocketRoomHandoverCalled]");
          // _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          // if (mounted) {
          //   setState(() {});
          // }
        };
        AppController.onSocketRoomClosedCalled = () {
          // AppLoggerCS.debugLog("[onSocketRoomClosedCalled]");
          // _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          if (mounted) {
            setState(() {});
          }
        };
        AppController.onSocketCSATCalled = () {
          // AppLoggerCS.debugLog("[onSocketCSATCalled]");
          _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          if (AppController.isAnyCompletionMessage) {
            AppController.isCSATOpen = false;
            AppController.isRoomClosed = RoomCloseState.close;
          } else {
            AppController.isCSATOpen = true;
            AppController.isRoomClosed = RoomCloseState.open;
          }
          // AppController.isRoomClosed = false;
          if (mounted) {
            setState(() {});
          }
        };
        AppController.onSocketCSATCloseCalled = () {
          // AppLoggerCS.debugLog("[onSocketCSATCloseCalled]");
          _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          AppController.isCSATOpen = false;
          AppController.isRoomClosed = RoomCloseState.close;
          // AppController.isRoomClosed = true;
          if (mounted) {
            setState(() {});
          }
          Future.delayed(Duration(milliseconds: 1000), () {
            AppController.clearRoomClosed();
            // AppController.disconnectSocket();
          });
        };
        AppController.onSocketCustomerIsBlockedCalled = () {
          // AppLoggerCS.debugLog("[onSocketCustomerIsBlockedCalled]");
          _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          if (mounted) {
            setState(() {});
          }
        };
        AppController.onSocketDisconnectCalled = () {
          // AppLoggerCS.debugLog("[onSocketDisconnectCalled]");
          _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
          if (mounted) {
            setState(() {});
          }
        };
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  RefreshController refreshController = RefreshController(initialRefresh: false);

  File? uploadFile;
  String metaFile = "";
  String fileName = "";
  double fileSize = 0;

  bool openImage = false;
  String srcImage = "";

  @override
  void dispose() {
    super.dispose();
    _showToggleButton.dispose();
    _scrollController.dispose();
    AppController.disconnectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (openImage && srcImage != "") ? false : true,
      onPopInvokedWithResult: (didPop, result) async {
        if (openImage && srcImage != "") {
          setState(() {
            openImage = false;
            srcImage = "";
          });
        } else {
          isLoading = false;
          AppController.clear();
          await ChatLocalSource.localServiceHive.user.clear();
          setState(() {});
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: AppController.headerBackgroundColor,
                      // forceMaterialTransparency: true,
                      leadingWidth: 70,
                      leading: Center(
                        child: (AppController.dataGetConfigValue != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: (AppController.dataGetConfigValue!.avatarImageBit != null)
                                    ? Image.memory(
                                        AppController.dataGetConfigValue!.avatarImageBit!,
                                        // Uri.parse(AppController.dataGetConfigValue!.avatarImage!).data!.contentAsBytes(),
                                        // base64Decode(dataGetConfig!.avatarImage!),
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.grey,
                                      ),
                              )
                            : Text(
                                "App!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      centerTitle: false,
                      title: Text(
                        (AppController.dataGetConfigValue != null)
                            ? (AppController.dataGetConfigValue?.avatarName != null)
                                ? "${AppController.dataGetConfigValue?.avatarName}"
                                : "Cust Service"
                            : "Cust Service",
                        style: GoogleFonts.inter(
                          color: AppController.headerTextColor,
                          // color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      actions: [
                        InkWell(
                          onTap: () {
                            AppController.clear();
                            ChatLocalSource.localServiceHive.user.clear();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    body: Stack(
                      children: [
                        SmartRefresher(
                          reverse: true,
                          controller: refreshController,
                          scrollController: _scrollController,
                          enablePullUp: true,
                          enablePullDown: false,
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.ShowWhenLoading,
                          ),
                          onLoading: () async {
                            await AppController().loadMoreConversation(
                              onSuccess: () {
                                // refreshController.loadComplete();
                                _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
                                setState(() {});
                              },
                              onFailed: (errorMessage) {
                                // refreshController.loadComplete();
                                setState(() {});
                              },
                            ).then((value) {
                              refreshController.loadComplete();
                            });
                          },
                          child: SingleChildScrollView(
                            // controller: _scrollController,
                            // physics: const NeverScrollableScrollPhysics(),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      ListView.builder(
                                        reverse: false,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        // controller: _scrollController,
                                        itemCount: _chatItems.length,
                                        padding: EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          final item = _chatItems[index];

                                          if (item is DateSeparator) {
                                            return Center(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                ),
                                                child: Text(
                                                  item.label,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (item is ConversationList) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 5,
                                              ),
                                              child: ChatBubbleWidget(
                                                onChooseBotChat: (botData, chatData) {
                                                  AppController().emitBotChat(
                                                    botDataChosen: botData,
                                                    chatData: chatData,
                                                    // plainData: plainData,
                                                    onSent: () {
                                                      _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    },
                                                  );
                                                },
                                                onChooseCsat: (csatData, chatPayload) {
                                                  AppController().emitCsat(
                                                    postbackDataChosen: csatData,
                                                    chatData: chatPayload,
                                                    onSent: () {
                                                      _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    },
                                                    onFailed: () {
                                                      AppController.clear();
                                                      ChatLocalSource.localServiceHive.user.clear();
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                                onChooseCarousel: (carouselData, chatPayload) {
                                                  AppController().emitCarousel(
                                                    carouselDataChosen: carouselData,
                                                    chatData: chatPayload,
                                                    onSent: () {
                                                      _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    },
                                                  );
                                                },
                                                openImageCallback: (src) async {
                                                  if (src != "") {
                                                    if (AppImagePickerServiceCS().isImageFile(src)) {
                                                      setState(() {
                                                        openImage = true;
                                                        srcImage = src;
                                                      });
                                                    } else {
                                                      await AppController.launchUrlChat(src);
                                                    }
                                                  }
                                                },
                                                data: item,
                                                dataGetConfig: AppController.dataGetConfigValue,
                                              ),
                                            );
                                          }

                                          return SizedBox.shrink();
                                        },
                                      ),
                                      // if (isLoading)
                                      //   Container(
                                      //     width: MediaQuery.of(context).size.width,
                                      //     height: MediaQuery.of(context).size.height,
                                      //     color: Colors.black38,
                                      //     child: Center(
                                      //       child: SizedBox(
                                      //         height: 50,
                                      //         width: 50,
                                      //         child: CircularProgressIndicator(),
                                      //       ),
                                      //     ),
                                      //   ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: kToolbarHeight + 30 + ((uploadFile != null) ? 90 : 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _showToggleButton,
                          builder: (context, show, child) {
                            if (_showToggleButton.value) {
                              return Positioned(
                                bottom: 20,
                                right: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _scrollToBottom();
                                      },
                                      child: SizedBox(
                                        // color: Colors.blue,
                                        // margin: EdgeInsets.all(20),
                                        height: 50,
                                        width: 50,
                                        child: CircleAvatar(
                                          // backgroundColor: const Color(0xff2a55a4).withValues(alpha: 0.6),
                                          backgroundColor: const Color(0xff2a55a4).withOpacity(0.6),
                                          child: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            size: 35,
                                            color: Colors.white,
                                            // color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      // color: Colors.purple,
                                      // height: 100,
                                      height: kToolbarHeight + 30 + ((uploadFile != null) ? 90 : 0),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                    resizeToAvoidBottomInset: true,
                    bottomSheet: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (uploadFile != null)
                          Container(
                            // color: Colors.amber,
                            color: Colors.grey.shade300,
                            width: MediaQuery.of(context).size.width,
                            // height: 90,
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image.network(
                                //   "https://images.unsplash.com/photo-1575936123452-b67c3203c357?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D",
                                //   height: 60,
                                //   width: 60,
                                //   fit: BoxFit.cover,
                                // ),
                                SizedBox(width: 16),
                                Image.file(
                                  uploadFile!,
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Icon(
                                        Icons.file_copy_rounded,
                                        size: 60,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'File Name: ',
                                          style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' $fileName',
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          text: 'File Size: ',
                                          style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: ' ${fileSize.toStringAsFixed(4)} MB',
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      uploadFile = null;
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                              ],
                            ),
                          ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // AppController.isRoomClosed
                              AppController.isRoomClosed == RoomCloseState.close
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          // AppController.isRoomClosed = !AppController.isRoomClosed;
                                          if (AppController.isRoomClosed == RoomCloseState.close) {
                                            InterModule.accessToken = "";
                                            AppController.isRoomClosed = RoomCloseState.open;
                                            AppController.isAnyCompletionMessage = false;
                                          } else {
                                            AppController.isRoomClosed = RoomCloseState.close;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff2a55a4),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Start Chat",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: SizedBox(
                                            height: 50,
                                            child: FocusScope(
                                              child: Focus(
                                                onFocusChange: (focus) {
                                                  setState(() {
                                                    isTextFieldFocused = focus;
                                                  });
                                                },
                                                child: TextField(
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  controller: textController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (value == "" && uploadFile == null) {
                                                        isTextFieldEmpty = true;
                                                      } else {
                                                        isTextFieldEmpty = false;
                                                      }
                                                    });
                                                  },
                                                  onSubmitted: (value) {
                                                    textFieldInputAction();
                                                  },
                                                  decoration: InputDecoration(
                                                    suffixIcon: (isTextFieldFocused && !isTextFieldEmpty)
                                                        ? InkWell(
                                                            onTap: () {
                                                              textFieldInputAction();
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.all(8),
                                                              child: CircleAvatar(
                                                                backgroundColor: Colors.white,
                                                                radius: 20,
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.send,
                                                                    size: 16,
                                                                    color: isTextFieldFocused ? Colors.green : Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : null,
                                                    hintText: "Type something...",
                                                    hintStyle: GoogleFonts.lato(
                                                      color: Colors.black38,
                                                      fontSize: 14,
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.grey.shade300,
                                                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (AppController.isWebSocketStart) ...[
                                          // SizedBox(width: 12),
                                          InkWell(
                                            onTap: () async {
                                              uploadFile = await AppImagePickerServiceCS().getImageAsFile(
                                                imageQuality: 85,
                                                onFileName: (fileNameValue) {
                                                  fileName = fileNameValue;
                                                },
                                                onSizeFile: (sizeFileValue) {
                                                  fileSize = sizeFileValue;
                                                },
                                              );
                                              metaFile = "File Name: $fileName\nSize File: ${fileSize.toStringAsFixed(3)} MB";
                                              buttonValidation();
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              child: Icon(
                                                Icons.image,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(width: 12),
                                          InkWell(
                                            onTap: () async {
                                              uploadFile = await AppFilePickerServiceCS().pickFiles(
                                                fileMaxSize: 30,
                                                onFailed: (errorMessage) {
                                                  toastFailedUploadMedia(errorMessage);
                                                },
                                                onFileName: (fileNameValue) {
                                                  fileName = fileNameValue;
                                                },
                                                onSizeFile: (sizeFileValue) {
                                                  fileSize = sizeFileValue;
                                                },
                                              );
                                              buttonValidation();
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              child: Icon(
                                                // Icons.send,
                                                Icons.attach_file_rounded,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(width: 12),
                                        ] else ...[
                                          SizedBox(width: 12),
                                        ],
                                      ],
                                    ),
                              SizedBox(height: 5),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Chat By",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Image.asset(
                                      Assets.icKonnek,
                                      height: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black38,
                      child: Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (openImage && srcImage != "")
              Material(
                color: Colors.transparent,
                child: Container(
                  color: Colors.black54,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ShowImageWidget(
                            image: srcImage,
                            confirmDismiss: (direction) async {
                              setState(() {
                                openImage = false;
                                srcImage = "";
                              });
                              return false;
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 50,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              openImage = false;
                              srcImage = "";
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.grey.shade200,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void buttonValidation() {
    if (uploadFile == null && textController.text.isEmpty) {
      isTextFieldFocused = false;
      isTextFieldEmpty = true;
    } else {
      isTextFieldFocused = true;
      isTextFieldEmpty = false;
    }
  }

  void toastFailedUploadMedia(String errorMessage) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        backgroundColor: Colors.red.shade500,
        content: Text(
          errorMessage,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void textFieldInputAction() {
    if (AppController.isCSATOpen) {
      if (uploadFile != null) {
        AppController().uploadMedia(
          text: textController.text,
          mediaData: uploadFile!,
          onLoading: (bool loadingIndicator) {
            setState(() {
              isLoading = loadingIndicator;
            });
          },
          onSuccess: () {
            uploadFile = null;
            _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
            setState(() {});
          },
          onFailed: (errorMessage) {
            uploadFile = null;
            toastFailedUploadMedia(errorMessage);
            setState(() {});
          },
        );
      } else {
        AppController().emitCsatText(
          text: textController.text,
          onSent: () {
            _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
            if (mounted) {
              setState(() {});
            }
          },
          onFailed: () async {
            AppController.clear();
            ChatLocalSource.localServiceHive.user.clear();
            Navigator.pop(context);
          },
        );
      }
    } else {
      if (uploadFile != null) {
        AppController().uploadMedia(
          text: textController.text,
          mediaData: uploadFile!,
          onLoading: (bool loadingIndicator) {
            setState(() {
              isLoading = loadingIndicator;
            });
          },
          onSuccess: () {
            uploadFile = null;
            _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
            setState(() {});
          },
          onFailed: (errorMessage) {
            uploadFile = null;
            toastFailedUploadMedia(errorMessage);
            setState(() {});
          },
        );
      } else {
        if (AppController().isOnlySpaces(textController) || textController.text.isEmpty) {
          //
        } else {
          AppController().sendChat(
            text: textController.text,
            onSuccess: () async {
              _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
              setState(() {});
            },
            onChatSentFirst: () {
              _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
              setState(() {});
            },
            onGreetingsFailed: (value) {
              setState(() {
                _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
                isTextFieldFocused = true;
                isTextFieldEmpty = false;
                String valueGreetings = value.message!.split(' ').last;
                textController.text = valueGreetings;
              });
            },
            onCustomerBlockedFailed: () {
              _chatItems = ChatController.buildChatListWithSeparators(AppController.conversationList);
              setState(() {});
            },
          );
        }
      }
    }

    textController.clear();
    isTextFieldEmpty = true;
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
