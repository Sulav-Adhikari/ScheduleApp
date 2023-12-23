import 'package:flutter/material.dart';
import 'package:scheduleapp/Views/Widgets/TextStyle.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({super.key, required this.title, required this.hint, this.controller,this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: titleStyle(),),
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: widget==null?false:true,
                      autofocus: false,
                      controller: controller,
                      style: hintStyle(),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: hintStyle(),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 0
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 0
                          ),
                        ),
                      ),

                    ),
                  ),
                  widget??Container()
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
