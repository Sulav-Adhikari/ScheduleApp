import 'package:flutter/material.dart';
import 'package:scheduleapp/Views/Widgets/TextStyle.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function onClick;
  const MyButton({super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>onClick(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurple
        ),
        // color: Colors.deepPurple,
        height: 50,
        width: 150,
        child: Center(
          child: Text(text,
            style: titleStyle(),
          ),
        ),
      ),
    );
  }
}
