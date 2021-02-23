import 'package:flutter/material.dart';
import 'stream_view.dart';

class ZoomRoute extends StatelessWidget {
  const ZoomRoute();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream')),
      body: Center(
        child: Hero(
          tag: 'frame',
          child: StreamView(onTap: () => Navigator.pop(context)),
        ),
      ),
    );
  }
}
