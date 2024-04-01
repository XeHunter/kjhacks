import 'dart:convert';
import 'constants.dart';
import 'package:http/http.dart' as http;
// import 'package:rive_animation/constants.dart';

class OpenAIAPI {
  final List<Map<String, String>> _chatMessages = [];

  Future<String> makeAPICall({required String prompt}) async {
    return await _chatGPTAPI(prompt: prompt);
  }

  Future<String> _chatGPTAPI({required String prompt}) async {
    _chatMessages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
          'Cookie':
          '__cf_bm=f4m2Qesw95.7DvvTJNywbf.g02JD.bKDjqD9CyQXst4-1708200909-1.0-ARmNIgO5msWn6FTo3EPe4B2jQQomndSThht8ekkNGCGGu+U4mXftxxSjsT+RGfIYR6e/ZUapbQLezJTOhy29q2k=; _cfuvid=20wG5hGVPLQ1TmYccVcnVV2YZ8kRaQ3Qy9KhTqHO_cY-1708181763680-0.0-604800000'
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
              "You are a helpful assistant. A career guide. Explain in very simple language about the next:  " +
                  prompt
            }
          ]
        }),
      );

      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        String content =
        jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        _chatMessages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      throw Exception('Failed to call ChatGPT API');
    } catch (e) {
      throw Exception('Failed to call ChatGPT API: $e');
    }
  }
}