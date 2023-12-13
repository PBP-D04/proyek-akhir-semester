import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/product_mini_image.dart';

class ProductMiniImageContainer extends StatelessWidget{
  final Function function;
  final List<String> imagesData;
  final int currIndex;
  ProductMiniImageContainer({super.key,required this.currIndex, required this.function, required this.imagesData});
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(builder: (context, constraint){
      return Container(
        width: constraint.maxWidth,
        height: constraint.maxHeight,
        child:  Scrollbar(
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
                      child: ProductMiniImage(
                        imageData: imageData,
                        function: () => function(index),
                        isSelected: index == currIndex,
                      ),
                    );
                  }).toList(),

                ],
              ),
            )
        ),
      );
    });
  }
}