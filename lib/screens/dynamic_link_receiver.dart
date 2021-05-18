import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:toeicking2021/services/dynamic_links_service.dart';

class DynamicLinkReceiver extends StatefulWidget {
  @override
  _DynamicLinkReceiverState createState() => _DynamicLinkReceiverState();
}

class _DynamicLinkReceiverState extends State<DynamicLinkReceiver>
    with WidgetsBindingObserver {
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
          // StatefulWidget在build()方法外可以取到BuildContext context(initState()除外)
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
        },
      ),
    );
  }
}
