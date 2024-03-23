import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:telephony/telephony.dart';

class User {
  String name;
  String email;
  String password;

  User({
    required this.email,
    required this.password,
    required this.name,
  });
}

class UserProvider extends ChangeNotifier {
  String _message = "";
  User _user = User(
    email: '',
    password: '',
    name: '',
  );

  User get user => _user;

  String get smsMessage => _message;
  late SmsMessage _smsColumn;

  SmsMessage get smsColumn => _smsColumn;
  
  void setMessage(SmsMessage message) {
    _message = message.body!;
    _smsColumn = message;
    notifyListeners();
  }

  String _lastPrediction = '';
  PlatformFile _file = PlatformFile(name: '', size: 0, bytes: Uint8List(0));

  String _ai_Res = '';

  String get ai_Res => _ai_Res;

  void setFile(PlatformFile file) {
    _file = file;
    notifyListeners();
  }

  void prediction(String prediction) {
    _lastPrediction = prediction;
    notifyListeners();
  }

  String get predictionstr => _lastPrediction;

  void clearUser() {
    _user = User(
      email: '',
      password: '',
      name: '',
    );
    notifyListeners();
  }

  Future<String> getChatbotResponse(String message) async {
    // final response = await http.get(Uri.parse('https://your-chatbot-endpoint'));
    // if (response.statusCode == 200) {
    //   return response.body;
    // } else {
    //   throw Exception('Failed to get chatbot response');
    // }
    await Future.delayed(const Duration(seconds: 1));
    return 'Chatbot responses to: $message';
  }

  Future<void> logOut() async {
    clearUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('myCookie');
    notifyListeners();
  }

  Future<String> signUp(User user) async {
    final email = user.email;
    final password = user.password;
    final name = user.name;
    try {
      var url = Uri.parse('http://192.168.61.84:5000/api/signup');
      var response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      if (response.statusCode == 200) {
        final token = response.headers['set-cookie'];
        print(response.headers['set-cookie']);
        if (token == null) {
          throw "Something went wrong, got no token";
        }
        _user.email = user.email;
        _user.password = user.password;
        _user.name = json.decode(response.body)['name'];
        await storeCookie(token);
        notifyListeners();
        return Future(() => 'success');
      } else {
        throw "Something went wrong";
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> logIn(User user) async {
    final email = user.email;
    final password = user.password;
    try {
      var url = Uri.parse(
          'http://192.168.61.84:5000/api/login'); // Replace with your backend URL
      var response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.headers['set-cookie'];
        print(response.headers['set-cookie']);
        if (token == null) {
          throw "Something went wrong, got no token";
        }
        _user.email = user.email;
        _user.password = user.password;
        _user.name = json.decode(response.body)['name'];
        await storeCookie(token);
        notifyListeners();
        return Future(() => 'success');
      } else {
        throw "Something went wrong";
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}

Future<void> storeCookie(String cookieValue) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('myCookie', cookieValue);
}

Future<String?> getStoredCookie() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('myCookie');
}
