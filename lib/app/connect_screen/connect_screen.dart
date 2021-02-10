import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:obj_detect_board/app/connect_screen/providers/device_list_provider.dart';
import 'package:obj_detect_board/app/home_screen/home_screen.dart';
import 'package:obj_detect_board/app/home_screen/home_view_model.dart';
import 'package:obj_detect_board/services/api.dart';

final addDialogStateProvider = StateProvider((ref) => false);
final ipv4Regex = RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
final textController = TextEditingController();

class ConnectScreen extends StatelessWidget {
  const ConnectScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, watch, child) {
          final state = watch(deviceListStateProvider);

          return state.isInitialized
              ? Text('${state.devices.length} Gerät(e) gefunden')
              : Text('Suche nach Geräten...');
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Manuell hinzufügen'),
                    content: TextField(
                        controller: textController,
                        decoration:
                            const InputDecoration(hintText: 'IP-Addresse'),
                        onChanged: (text) {
                          final state = context.read(addDialogStateProvider);
                          final isValid = ipv4Regex.hasMatch(text);
                          if (state.state != isValid) {
                            state.state = isValid;
                          }
                        }),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Abbrechen')),
                      Consumer(
                        builder: (context, watch, child) {
                          return TextButton(
                            onPressed: watch(addDialogStateProvider).state
                                ? () {
                                    context
                                        .read(deviceListStateProvider)
                                        .addManualDevice(textController.text);
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: Text('Hinzufügen'),
                          );
                        },
                      )
                    ],
                  );
                },
              );

              context.read(addDialogStateProvider).state = false;
              textController.clear();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final state = watch(deviceListStateProvider);

          if (!state.isInitialized) {
            return Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => state.refreshDeviceList(),
            child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                      title: Text(state.devices[index].name),
                      onTap: () {
                        context.read(selectedDeviceProvider).state =
                            state.devices[index];
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                separatorBuilder: (_, __) => Divider(height: 1),
                itemCount: state.devices.length),
          );
        },
      ),
    );
  }
}
