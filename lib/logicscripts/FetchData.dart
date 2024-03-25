import 'package:iot_app/logicscripts/GetRequest.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iot_app/logicscripts/PostRequest.dart';

class FetchData {
  static const String baseUrl = 'https://fast-api-sample-9b2d.onrender.com';


  // Method to fetch user data
  static Future<Map<String, dynamic>> connectionStatus() async {
    const String apiUrl = '$baseUrl/connection-status'; // Modify the endpoint for user data

    return await getRequest(apiUrl);
  }

  //Method to create an account
  static Future<Map<String, dynamic>> register(String email) async {
    const String apiUrl = '$baseUrl/create-account'; // Modify the endpoint for user data
    Map<String, dynamic> requestBody ={};
    requestBody['email']= email;

    return await postRequest(requestBody ,apiUrl);
  }

  //Method to login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    const String apiUrl = '$baseUrl/login'; // Modify the endpoint for user data
    Map<String, dynamic> requestBody ={};
    requestBody['email']= email;
    requestBody['secret_key'] = password;

    return await postRequest(requestBody ,apiUrl);
  }

  static Future<String?> checkToken() async {
    // Check if token exists
    const  storage =  FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token;
    // if (token != null) {
    //   // Token exists, navigate to the homepage
    //   Navigator.pushReplacementNamed(context, '/homepage');
    //   popUpCenter('Token present');
    // }
    // else {
    //   // Token doesn't exist, navigate to the login page
    //   // Navigator.pushReplacementNamed(context, '/loginpage');
    //   // Navigator.pop(context);
    //   Navigator.pushReplacementNamed(context, '/homepage');
    //   popUpCenter('Token absent');
    // }
  }

  static Future<bool> writeToken(String str) async {
    // Check if token exists
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: str);
      return true;
    } catch (e){
      return false;
    }
  }

  // Method to fetch post data
  // static Future<Map<String, dynamic>> fetchPostData() async {
  //   final String apiUrl = '$baseUrl/post'; // Modify the endpoint for post data
  //
  //   return await fetchData(apiUrl);
  // }

// Add more methods for different purposes as needed
}
