import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Secret {
  final String apiKey;
  Secret({this.apiKey = ""});
  factory Secret.fromJson(Map<String, dynamic> jsonMap) {
    return new Secret(apiKey: jsonMap["openAPIKEY"]);
  }
}

class SecretLoader {
  final String secretPath;

  SecretLoader({required this.secretPath});
  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}

class OpenAIService {
  final List<Map<String, String>> message = [];
  Future<Secret> openAPIKEY = SecretLoader(secretPath: "api.json").load();

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAPIKEY"
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    "Does this message want to generate an AI picture, image, art or anything similiar? $prompt. Simply answer with a yer or no."
              }
            ]
          },
        ),
      );
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)["choices"][0]["message"]["content"];
        content = content.trim();

        switch (content) {
          case "Yes":
          case "yes":
          case "Yes.":
          case "yes.":
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    message.add(
      {
        "role": "user",
        "content": prompt,
      },
    );
    try {
      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAPIKEY"
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": message,
          },
        ),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)["choices"][0]["message"]["content"];
        content = content.trim();

        message.add(
          {
            "role": "assistent",
            "content": content,
          },
        );
        return content;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    return "DALL-E";
  }
}
