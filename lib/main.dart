import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_play_asset/flutter_play_asset.dart';

void main() {
  runApp(LandingPage());
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  var _selectedWidget = [
    Container(child: Center(child: Text('This is Landing Page'))),
    SecondTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Modular App'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(label: "Main", icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: "Edit it", icon: Icon(Icons.edit))
          ],
          onTap: _onItemTapped,
          currentIndex: _currentIndex,
        ),
        body: _selectedWidget[_currentIndex],
      ),
    );
  }
}

class SecondTab extends StatefulWidget {
  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> implements ViewPlayAsset {
  bool showLoading = false;
  String statusText = "Mohon tunggu";
  FlutterPlayAsset playAssetHelper = FlutterPlayAsset();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Text(statusText),
                    )
                  ],
                ),
              ),
            )
          : Container(
              child: InkWell(
                onTap: (() async {
                  setState(() {
                    showLoading = true;
                  });
                  await playAssetHelper.init(this);

                  print('process to loading page');
                  await checkIfImageEditorAssetPackExist();
                }),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 32,
                      onPressed: () {},
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Click to try module image editor',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> checkIfImageEditorAssetPackExist() async {
    try {
      setState(() {
        statusText = "Get asset directory";
      });
      playAssetHelper.getAssetPath("editorassetpack");
    } catch (_) {
      print('checkIfImageEditorAssetPackExistError $_');
      setState(() {
        statusText = "Error $_";
      });
    }
  }

  @override
  void onAssetPathFound(String path) {
    setState(() {
      statusText = "downloaded in $path";
    });
  }

  @override
  void onProcessLoadingAssetPath(String message) {
    setState(() {
      statusText = message;
    });
  }

  @override
  void onProgressDownload(int percentage) {
    setState(() {
      statusText = "Download asset $percentage%";
    });
  }
}
