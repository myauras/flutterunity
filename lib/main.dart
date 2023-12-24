import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() {
  print('App 啟動');
  // runApp(const MainApp());
  runApp(
    const MaterialApp(
      home: UnityDemoScreen(),
    ),
  );
}

class UnityDemoScreen extends StatefulWidget {
  const UnityDemoScreen({Key? key}) : super(key: key);

  @override
  State<UnityDemoScreen> createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () async {
            // Pop the category page if Android back button is pressed.
            return true;
          },
          child: Container(
            color: Colors.yellow,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: onUnityMsg,
              useAndroidViewSurface: true,
            ),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) async {
    print('Unity Controller建立');
    await controller.isReady();
    if (Platform.isAndroid) {
      const MethodChannel('unity.hack').invokeMethod("init");
    }
  }

  // Callback that connects the created controller to the unity controller
  void onUnityMsg(msg) {
    print('收到Unity訊息: ${msg.toString()}');
  }
}



// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }
