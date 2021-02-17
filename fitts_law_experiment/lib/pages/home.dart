import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Directory _downloadsDirectory;

class _HomeState extends State<Home> {
  Directory _downloadsDirectory;
  @override
  void initState() {
    super.initState();
    print("Home Init -- ");
    initDownloadsDirectoryState();
  }

  Future<void> initDownloadsDirectoryState() async {
    Directory downloadsDirectory;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _downloadsDirectory = downloadsDirectory;
    });
  }

  void requestPermission() async {
    final res = await SimplePermissions.requestPermission(
        Permission.WriteExternalStorage);
    print("permission request result is " + res.toString());
  }

  @override
  Widget build(BuildContext context) {
    print("Home build --");
    // requestPermission();
    // String path = _downloadsDirectory.path;
    // File myFile = File('$path/counter.txt');
    // myFile.writeAsString('Hello');
    return Scaffold(
      backgroundColor: Color(0xff15202b),
      appBar: AppBar(
        title: Text('Welcome to Fitts Law Experiment'),
        centerTitle: true,
        backgroundColor: Color(0xff1D2C3B),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Text(
              'Please choose your input method.',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _downloadsDirectory != null
                  ? 'Downloads directory: ${_downloadsDirectory.path}\n'
                  : 'Could not get the downloads directory',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 100.0,
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/experiment', // gotta push the next screen while passing the input method
                          arguments: 'Thumb');
                    },
                    child: const Text(
                      "Thumb",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.0,
                  width: 200.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/experiment', // gotta push the next screen while passing the input method.
                          arguments: 'Index');
                    },
                    child: const Text(
                      "Index Finger",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
