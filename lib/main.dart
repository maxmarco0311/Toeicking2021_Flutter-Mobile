import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:toeicking2021/services/dynamic_links_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '多益金',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '多益金'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  // int _counter = 0;
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 50,
          width: 100,
          child: FutureBuilder<Uri>(
              future: _dynamicLinkService.createDynamicLink(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Uri uri = snapshot.data;
                  return FlatButton(
                    color: Colors.amber,
                    onPressed: () => Share.share(uri.toString()),
                    child: Text('Share'),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: _incrementCounter,
    //     tooltip: 'Increment',
    //     child: Icon(Icons.add),
    //   ),
    // );
  }
}
