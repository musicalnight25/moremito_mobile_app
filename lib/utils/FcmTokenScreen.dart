import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FcmTokenScreen extends StatefulWidget {
  @override
  _FcmTokenScreenState createState() => _FcmTokenScreenState();
}

class _FcmTokenScreenState extends State<FcmTokenScreen> {
  String? _fcmToken;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _fcmToken = token;
      _loading = false;
    });
  }

  void _copyToClipboard() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Token copied to clipboard!".tr)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("FCM Token".tr)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Your Device Token:".tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : SelectableText(
                      _fcmToken ?? "Failed to fetch token",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _copyToClipboard,
                icon: Icon(Icons.copy),
                label: Text("Copy Token".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
