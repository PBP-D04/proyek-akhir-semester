import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'dash--mini_image.dart';

class MiniImageContainer extends StatelessWidget {
  final Function function;
  final List<Uint8List> imagesData;

  MiniImageContainer({Key? key, required this.function, required this.imagesData}) : super(key: key);

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ...imagesData.asMap().entries.map((entry) {
                  int index = entry.key;
                  var imageData = entry.value;

                  return Card(
                    child: MiniImage(
                      imageData: imageData,
                      function: () => function(index),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
