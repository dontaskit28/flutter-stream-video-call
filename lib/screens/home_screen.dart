import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stream_video_call/screens/call_screen.dart';
import 'package:flutter_stream_video_call/screens/loader_dialog.dart';
import 'package:flutter_stream_video_call/utils/constansts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  makeACall({
    required String userId,
    // required String userToken,
    required String name,
    String role = 'admin',
    required BuildContext context,
  }) async {
    try {
      final client = StreamVideo(
        apiKey,
        user: User.regular(
          userId: userId,
          name: name,
          role: role,
        ),
        // userToken: userToken,
        tokenLoader: (userId) async {
          return await getUserToken(
            userId: userId,
            name: name,
          );
        },
        options: const StreamVideoOptions(
          logPriority: Priority.debug,
        ),
      );
      var call = client.makeCall(
        id: getCallId,
        callType: StreamCallType(),
      );
      await call.getOrCreate();
      if (!context.mounted) {
        return;
      }
      if (dialogPresentOnScreen) {
        Navigator.pop(context);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      ).then((value) {
        if (StreamVideo.isInitialized()) {
          StreamVideo.reset();
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getUserToken({
    required String userId,
    required String name,
    String role = 'admin',
  }) async {
    final url = Uri.parse('$apiUrl/createUser');
    Map<String, dynamic> body = {
      'userId': userId,
      'name': name,
      'role': role,
    };
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final response = await http.post(
      headers: headers,
      url,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to get user token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nameController.text.isEmpty
                    ? null
                    : () async {
                        showLoaderDialog(context);
                        String userId =
                            '${_nameController.text}-${DateTime.now().millisecondsSinceEpoch}';
                        if (context.mounted) {
                          makeACall(
                            userId: userId,
                            name: _nameController.text,
                            context: context,
                          );
                        }
                      },
                child: const Text('Join Call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
