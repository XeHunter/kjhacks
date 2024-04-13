import 'package:flutter/material.dart';
import 'package:kj/ytservices.dart';
import 'package:url_launcher/url_launcher.dart';


class YouTubeVideoCard extends StatelessWidget {
  final String videoUrl;

  YouTubeVideoCard({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchVideoDetails(videoUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error fetching video details');
        } else {
          final details = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Card(
              child: InkWell(
                onTap: () async {
                  String url = videoUrl;
                  Uri parsedUrl = Uri.parse(videoUrl);
                  if (!await launchUrl(parsedUrl)) {
                    throw Exception('Could not launch $parsedUrl');
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),),
                        child: Image.network(details['thumbnailUrl'])
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28.0,top: 5,left: 5),
                      child: Text(details['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}


