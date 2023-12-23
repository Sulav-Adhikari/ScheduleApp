import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/Views/Widgets/MyButton.dart';
import 'package:scheduleapp/Views/Widgets/TextStyle.dart';
import 'package:scheduleapp/Views/Widgets/inputfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = DateFormat('hh:mm a').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Task",
              style: headStyle(),
            ),
            MyInputField(title: 'Title', hint: "Enter the title"),
            MyInputField(title: 'Note', hint: "Enter the note"),
            MyInputField(
              title: 'Date',
              hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_month_rounded),
                onPressed: () {
                  _getDatefromUser();
                  //DatePicker
                },
              ),
            ),
            MyInputField(
              title: 'Time',
              hint: _selectedTime,
              widget: IconButton(
                icon: Icon(Icons.access_time_outlined),
                onPressed: () {
                  _getTimeFromUser();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(child: MyButton(text: 'Add Task', onClick:(){},)),
            )
          ],
        ),
      ),
    );
  }

  _getDatefromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2029));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate!;
      });
    }
  }

  _getTimeFromUser() async {
    var _pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_selectedTime.split(':')[0]),
            minute: int.parse(_selectedTime.split(':')[1].split(" ")[0])));
    String? _formatedTime=_pickedTime?.format(context);
    if(_formatedTime!=null){
      setState(() {
        _selectedTime=_formatedTime;
      });
    }
  }
}
