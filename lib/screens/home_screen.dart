import 'package:flutter/material.dart';
import 'package:flutter_stream_video_call/screens/call_screen.dart';
import 'package:flutter_stream_video_call/screens/loader_dialog.dart';
import 'package:flutter_stream_video_call/utils/constansts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  makeACall({
    required String userId,
    required String userToken,
    required String name,
    required String role,
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
        userToken: userToken,
        options: const StreamVideoOptions(
          logPriority: Priority.debug,
        ),
      );
      var call = client.makeCall(
        id: getCallId,
        callType: StreamCallType(),
      );
      final result = await call.getOrCreate();
      debugPrint("Call created: ${result.getDataOrNull()}");
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
          debugPrint("Disconnecting call...");
          StreamVideo.reset();
        }
      });
    } catch (e) {
      debugPrint('Error joining or creating call: $e');
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemCount: users.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ElevatedButton(
                child: Text(
                  "Join as ${users[index].name}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  showLoaderDialog(context);
                  await makeACall(
                    userId: users[index].userId,
                    userToken: users[index].userToken,
                    name: users[index].name,
                    role: users[index].role,
                    context: context,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
