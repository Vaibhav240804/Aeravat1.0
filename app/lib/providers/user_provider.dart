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
  String _email = "";
  bool _isSpam = false;
  User _user = User(
    email: '',
    password: '',
    name: '',
  );

  User get user => _user;
  String get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  String get smsMessage => _message;
  late SmsMessage _smsColumn;

  SmsMessage get smsColumn => _smsColumn;

  void setMessage(SmsMessage message) {
    _message = message.body!;
    _smsColumn = message;
    notifyListeners();
  }

  Future<bool> classifyMsg() async {
    try {
      var url = Uri.parse('http://localhost:5000/api/classify');
      var response = await http.post(
        url,
        body: {
          'sms_text': _message,
        },
      );
      if (response.statusCode == 200) {
        final prediction = json.decode(response.body)['prediction'];
        _isSpam = prediction == '1';
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to classify message');
      }
    } catch (error) {
      throw Exception('Failed to classify message: $error');
    }
  }

  String _lastPrediction = '';

  PlatformFile _file = PlatformFile(name: '', size: 0, bytes: Uint8List(0));

  Map<String, double> _analysis = {};

  String _ai_Res = '';

  String get ai_Res => _ai_Res;

  Map<String, double> get analysis => _analysis;

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

  Future<Map<String, double>> getAnalysis() async {
    try {
      var url = Uri.parse('http://localhost:5000/api/analysis');
      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('file', _file.path!));
      var response = await request.send();
      var responseStr = await response.stream.bytesToString();
      var responseJson = json.decode(responseStr);
      _analysis = responseJson;
      notifyListeners();
      return responseJson;
    } catch (error) {
      throw Exception('Failed to get analysis: $error');
    }
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

  Future<String> verifyOtp(String otp) async {
    try {
      final url =
          Uri.parse('http://your-backend-server/api/verify-otp'); // Adjust URL
      final response = await http.post(
        url,
        body: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final token = response.headers['set-cookie'];
        if (token == null) {
          throw Exception('Token not found in response headers');
        }
        await storeCookie(token);
        return Future(() => 'success');
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (error) {
      throw Exception('Failed to verify OTP: $error');
    }
  }

  Future<String> getUserInfo(String email) async {
    try {
      final url = Uri.parse(
          'http://your-backend-server/api/send-user-info'); // Adjust URL
      final response = await http.post(
        url,
        body: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['user'];
        _user.email = email;
        _user.name = userData['name'];
        notifyListeners();
        return response.body;
      } else {
        throw Exception('Failed to fetch user info');
      }
    } catch (error) {
      throw Exception('Failed to fetch user info: $error');
    }
  }

  Future<String> signUp(User user) async {
    final email = user.email;
    _email = email;
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
    _email = email;
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
        debugPrint(response.headers['set-cookie']);
        if (token == null) {
          throw "Token not found in response headers";
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
