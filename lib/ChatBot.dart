import 'package:kj/services/constants.dart';

import 'feature_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
// import 'package:rive_animation/constants.dart';
// import 'package:rive_animation/screens/prompt_input_screen/components/feature_list_item.dart';
import 'message_baloon.dart';
import 'services/api_service.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  final openAIAPI = OpenAIAPI();
  final scrollController = ScrollController();
  final textEditingController = TextEditingController();

  String? generatedContent;
  String? generatedImageUrl;
  String? searchText;
  int animDelay = 129;
  List<MessageBaloon> messageList = <MessageBaloon>[];

  void clearInputBox() {
    setState(() {
      searchText = ''; // Clear the text
      controller.clear(); // Clear the text field controller
    });
  }

  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  // void addMessage(MessageBaloon message) {
  //   setState(() {
  //     messageList.add(message);
  //     messageList.add(SizedBox(height: 10)); // Add spacing between messages
  //     scrollDown();
  //   });
  // }

  void getAnswer() async {
    Future.delayed(const Duration(milliseconds: 392), () {
      setState(() {
        // messageList.add(MessageBaloon(
        //     backgroundColor: Pallete.whiteColor,
        //     text: "Loading...",
        //     isAI: true));
        // messageList.add(const MessageBaloon(
        //     backgroundColor: Colors.white,
        //     text: "Your response or AI answer",
        //     isAI: true));

        scrollDown();
      });
    });

    setState(() {});
    final searchTextRes = await openAIAPI.makeAPICall(prompt: searchText!);
    if (searchTextRes.contains('http')) {
      generatedImageUrl = searchTextRes;
      generatedContent = null;
      messageList.add(MessageBaloon(
        backgroundColor: Colors.white,
        imageUrl: generatedImageUrl,
        isAI: true,
        text: '',
      ));
      setState(() {
        scrollDown();
      });
    } else {
      generatedContent = searchTextRes;
      generatedImageUrl = null;
      setState(() {});
      messageList.add(MessageBaloon(
        backgroundColor: Colors.white,
        isAI: true,
        text: generatedContent!,
      ));
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 65),
        child: DecoratedBox(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/safe.png'),
                  fit: BoxFit.cover,
                  opacity: 0.5)),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.only(bottom: 129),
                child: Column(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: AppBar(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text("ChatBot",
                          style: TextStyle(
                            fontFamily:"Belanosima",
                            color: main1
                          ),
                          ),
                        ),
                          scrolledUnderElevation: 0,
                          elevation: 0,
                          centerTitle: true,
                          backgroundColor: Colors.transparent,
                          actions: [
                            Container(
                              margin: const EdgeInsets.only(right: 20, top: 5),
                              height: 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.black.withOpacity(0.3),
                              ),
                            )
                          ]),
                    ),
                    Container(
                      margin:
                      const EdgeInsets.only(top: 14.0, right: 14, left: 14),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          const FeatureListItem(
                            backgroundColor: Colors.white,
                            titleText: 'Your Virtual Guide:)',
                            descriptionText:
                            'Unlock your potential with the right knowledge.',
                          ),
                          const FeatureListItem(
                            backgroundColor: Color.fromARGB(255, 167, 199, 231),
                            titleText: 'Try Bobby',
                            descriptionText: 'Type a message to get started.',
                          ),
                          Column(
                            children: messageList,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: 20),
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontFamily: "Belanosima"
                        ),
                        onTap: () => scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease),
                        onTapAlwaysCalled: true,
                        controller: controller,
                        onChanged: (text) {
                          setState(() {
                            searchText = text;
                          });
                        },
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          filled: true,
                          labelText: "Type a message...",
                          labelStyle: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Belanosima',
                              color: main1),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(14)),
                              borderSide: BorderSide(color: main1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(14)),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () async {
                        if (searchText.toString().isNotEmpty &&
                            searchText != null) {
                          messageList.add(MessageBaloon(
                              backgroundColor: Colors.white,
                              text: searchText.toString(),
                              isAI: false));
                          getAnswer();
                          clearInputBox();
                        } else {
                          // Use the text from the input box as a prompt for the API call
                          final response = await openAIAPI.makeAPICall(
                              prompt: textEditingController.text);

                          // Process the API response and add it to the messageList
                          messageList.add(MessageBaloon(
                            backgroundColor: Colors.white,
                            text: response,
                            isAI: true,
                          ));
                          setState(() {
                            scrollDown();
                          });
                        }
                      },
                      backgroundColor: main1,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}