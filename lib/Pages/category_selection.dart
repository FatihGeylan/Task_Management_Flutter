import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


List<String> Category = [
  'URGENT',
  'RUNNING',
  'ONGOING',
];
class CategorySelection extends ConsumerWidget {
  final bool isSelected;
  final String task_type;
  final Color dayColor;
  final Color backColor;


  const CategorySelection({required this.task_type,required this.dayColor,required this.backColor, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
          height: MediaQuery.of(context).size.height/18,
          width: MediaQuery.of(context).size.width/5,
          decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(15),),

        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,

          children: [

            Center(
              child: Text(
                task_type,
                style: TextStyle(
                  fontSize: 16,
                  color: dayColor,
                ),

              ),
            ),
            Positioned(
              top:-18,
              right: -18,
              child: Visibility(
                visible: isSelected,
                child: IconButton(
                  color: Colors.white,
                    icon: Container(
                        decoration: BoxDecoration(color:backColor, shape: BoxShape.circle),
                        child: const Icon(Icons.check,)),
                    onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
