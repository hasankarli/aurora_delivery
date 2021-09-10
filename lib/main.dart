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
  String progressText = "";
  String totalSizeText = "";
  String errorMessageText = "";
  String checkAssetFolderPath = "";
  String assetFail = "";
  String assetNull = "";
  String assetCompleted = "";
  String assetStart = "";
  FlutterPlayAsset playAssetHelper = FlutterPlayAsset();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: 32,
                    onPressed: () async {
                      setState(() {
                        showLoading = true;
                      });
                      await playAssetHelper.init(this);

                      print('process to loading page');
                      await checkIfImageEditorAssetPackExist();

                      setState(() {
                        showLoading = false;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                progressText.isNotEmpty
                    ? _StatusText(value: progressText, title: 'progressText')
                    : SizedBox(),
                totalSizeText.isNotEmpty
                    ? _StatusText(value: totalSizeText, title: 'totalSizeText')
                    : SizedBox(),
                errorMessageText.isNotEmpty
                    ? _StatusText(
                        value: errorMessageText, title: 'errorMessageText')
                    : SizedBox(),
                checkAssetFolderPath.isNotEmpty
                    ? _StatusText(
                        value: checkAssetFolderPath,
                        title: 'checkAssetFolderPath')
                    : SizedBox(),
                assetFail.isNotEmpty
                    ? _StatusText(value: assetFail, title: 'assetFail')
                    : SizedBox(),
                assetNull.isNotEmpty
                    ? _StatusText(value: assetNull, title: 'assetNull')
                    : SizedBox(),
                assetCompleted.isNotEmpty
                    ? _StatusText(
                        value: assetCompleted, title: 'assetCompleted')
                    : SizedBox(),
                assetStart.isNotEmpty
                    ? _StatusText(value: assetStart, title: 'assetStart')
                    : SizedBox(),
              ],
            ),
    );
  }

  Future<void> checkIfImageEditorAssetPackExist() async {
    try {
      setState(() {
        progressText = "Get asset directory";
      });
      playAssetHelper.getAssetPath("editorassetpack");
    } catch (_) {
      print('checkIfImageEditorAssetPackExistError $_');
      setState(() {
        progressText = "Error $_";
      });
    }
  }

  @override
  void onProgressDownload(int percentage) {
    setState(() {
      progressText = "Download asset $percentage";
    });
  }

  @override
  void totalSize(int percentage) {
    setState(() {
      totalSizeText = "$percentage";
    });
  }

  @override
  void errorMessage(String error) {
    setState(() {
      errorMessageText = "$error";
    });
  }

  @override
  void onCheckAssetFolderPath(String path) {
    setState(() {
      checkAssetFolderPath = "$path";
    });
  }

  @override
  void onAssetFail(String message) {
    setState(() {
      assetFail = "$message";
    });
  }

  @override
  void onAssetStart(String message) {
    setState(() {
      assetStart = "$message";
    });
  }

  @override
  void onAssetCompleted(String message) {
    setState(() {
      assetCompleted = "$message";
    });
  }

  @override
  void onAssetNull(String message) {
    setState(() {
      assetNull = "$message";
    });
  }
}

class _StatusText extends StatelessWidget {
  const _StatusText({
    Key? key,
    required this.value,
    required this.title,
  }) : super(key: key);

  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text("$title: $value"),
    );
  }
}
