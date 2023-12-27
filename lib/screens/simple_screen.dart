import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class SimpleScreen extends StatefulWidget {
  const SimpleScreen({Key? key}) : super(key: key);

  @override
  State<SimpleScreen> createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController? _unityWidgetController;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('測試畫面'),
      ),
      body: Card(
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              UnityWidget(
                onUnityCreated: _onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                useAndroidViewSurface: true,
                borderRadius: const BorderRadius.all(Radius.circular(70)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PointerInterceptor(
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text("測試參數:"),
                        ),
                        Slider(
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = value;
                            });
                            setRotationSpeed(value.toString());
                          },
                          value: _sliderValue,
                          min: 0.0,
                          max: 1.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void setRotationSpeed(String speed) {
    _unityWidgetController?.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  void onUnityMessage(message) {
    print('收到Unity訊息: ${message.toString()}');
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      print('開始Unity場景讀取: ${scene.name}');
      print('開始Unity場景Idx讀取:: ${scene.buildIndex}');
    } else {
      print('讀取場景為null');
    }
  }

  void _onUnityCreated(controller) {
    controller.resume();
    if (Platform.isAndroid) {
      const MethodChannel('unity.hack').invokeMethod("init");
    }
    _unityWidgetController = controller;
  }
}
