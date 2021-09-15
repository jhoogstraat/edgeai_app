import 'package:flutter/material.dart';

class PropertyView extends StatelessWidget {
  final String? title;
  final String? value;

  const PropertyView({Key? key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style:
              Theme.of(context).textTheme.bodyText2!.apply(color: Colors.grey),
        ),
        Text(
          value!,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
