import 'package:flutter/material.dart';
import 'package:obj_detect_board/app/screens/streaming/views/property_view.dart';

class StreamingScreenTest extends StatelessWidget {
  const StreamingScreenTest({Key? key}) : super(key: key);

  static const _bodyPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('#DeviceName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: buttonPress,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const FittedBox(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: ColoredBox(color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _bodyPadding),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    childAspectRatio: 2,
                    children: const [
                      PropertyView(
                        title: 'MODEL',
                        value: '#Model',
                      ),
                      PropertyView(title: 'AUFLÖSUNG (KAMERA)', value: 'HxW'),
                      PropertyView(title: 'STATUS', value: '#Status'),
                      PropertyView(
                        title: 'AUFLÖSUNG (CROPPED)',
                        value: 'HxW',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _bodyPadding, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: buttonPress,
                      child: const Text('Konfigurieren')),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: buttonPress,
                    child: const Text('Starten'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void buttonPress() {
    print("Button pressed");
  }
}
