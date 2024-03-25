import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getRequest(String apiUrl) async {
  // const String apiUrl = 'https://fast-api-sample-9b2d.onrender.com'; // Replace with your API endpoint

  try {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    if (response.statusCode == 200) {
      // Request successful, parse response JSON
      return jsonDecode(response.body);
    } else {
      // Request failed, throw an error
      // throw Exception('Failed with status code: ${response.statusCode}');
      return {"status":"error"};
    }
  } catch (error) {
    // Handle exceptions
    // throw Exception('Error: $error');
    return {"status":"error"};
  }
}