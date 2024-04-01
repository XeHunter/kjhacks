import 'package:animate_do/animate_do.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:rive_animation/constants.dart';

class MessageBaloon extends StatefulWidget {
  final Color backgroundColor;
  final String text;
  final String? imageUrl;
  final bool isAI;

  const MessageBaloon({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.isAI,
    this.imageUrl,
  });

  @override
  State<MessageBaloon> createState() => _MessageBaloonState();
}

class _MessageBaloonState extends State<MessageBaloon> {
  bool isLiked = false;
  bool isDisliked = false;
  bool isCopied = false;
  double getBaloonWidth() {
    if (widget.imageUrl != null) {
      return 372;
    } else if (widget.text.length < 29) {
      return 192;
    } else if (widget.text.length < 92) {
      return 329;
    } else {
      return 372;
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<ScaffoldState>();
    return FadeInRight(
      child: Visibility(
        child: Align(
          child: Row(children: [
            if (!widget.isAI) const Spacer(),
            if (widget.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(left: 14),
                  width: 372,
                  color: const Color.fromARGB(255, 229, 229, 233),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(widget.imageUrl!)),
                  ),
                ),
              ),
            if (widget.imageUrl == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    child: BubbleSpecialThree(
                      text: widget.text,
                      color: widget.isAI
                          ? const Color.fromARGB(255, 229, 229, 233)
                          : const Color.fromARGB(255, 0, 122, 255),
                      tail: true,
                      isSender: widget.isAI ? false : true,
                      textStyle: TextStyle(
                        color: widget.isAI ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  widget.isAI
                      ? Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            isLiked = !isLiked;
                          }),
                          child: Icon(
                            isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            isDisliked = !isDisliked;
                          }),
                          child: Icon(
                            isDisliked
                                ? Icons.thumb_down
                                : Icons.thumb_down_off_alt_outlined,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            Clipboard.setData(
                                ClipboardData(text: widget.text));
                            const SnackBar(
                              content: Text("Copied to Clipboard"),
                            );
                            isCopied = !isCopied;
                          }),
                          child: Icon(
                            isCopied ? Icons.copy : Icons.copy_outlined,
                            size: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  )
                      : Container()
                ],
              ),
          ]),
        ),
      ),
    );
  }
}
/**image generated
    if (imageUrl != null)
    Padding(
    padding: const EdgeInsets.all(7.0),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: Image.network(imageUrl!)),
    ), */