import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../connect_screen.dart';

class ChangeTimeoutAlert extends StatelessWidget {
  const ChangeTimeoutAlert({
    Key key,
    @required this.textController,
  }) : super(key: key);

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Timeout einstellen (sekunden)'),
      content: TextField(controller: textController),
      actions: [
        TextButton(
          onPressed: () {
            context.read(timeoutSecondsConfigProvider).state =
                int.tryParse(textController.text) ?? 0;
            Navigator.pop(context);
          },
          child: Text('Speichern'),
        )
      ],
    );
  }
}
