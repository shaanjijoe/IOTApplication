import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> postRequest(Map<String, dynamic> requestBody, String apiUrl) async {

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Request successful, parse response JSON
      return jsonDecode(response.body);
    } else {
      return {"status":"error"};
    }
  } catch (error) {
    return {"status":"error"};
  }
}