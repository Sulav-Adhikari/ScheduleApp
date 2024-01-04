import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scheduleapp/Database/dbhelper.dart';
import 'package:scheduleapp/Models/Notes.dart';
import 'package:scheduleapp/NotificationHandler/local_notification.dart';
import 'package:scheduleapp/Views/Lists.dart';
import 'package:scheduleapp/Views/Widgets/MyButton.dart';
import 'package:scheduleapp/Views/Widgets/TextStyle.dart';
import 'package:scheduleapp/Views/Widgets/inputfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? db;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _NoteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = DateFormat('hh:mm a').format(DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headStyle(),
              ),
              MyInputField(
                title: 'Title',
                hint: "Enter the title",
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: "Enter the note",
                controller: _NoteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_month_rounded),
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
                  icon: const Icon(Icons.access_time_outlined),
                  onPressed: () {
                    _getTimeFromUser();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Center(
                    child: MyButton(
                  text: 'Add Task',
                  onClick: () {
                    _validate();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ListsNote()));
                  },
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _addNoteToDb(int randomNumber) async {
    Notes note = Notes(
        title: _titleController.text,
        note: _NoteController.text,
        date: _selectedDate,
        time: _selectedTime,
        isCompleted: false,
        notId: randomNumber
    );
    await db?.insert(note);
   // print('clickedd  ${N}');
  }
  _scheduleNotification(int randomNumber){
    int hour;

    if (_selectedTime.split(':')[1].split(" ")[1]=='PM'){
      hour = int.parse(_selectedTime.split(':')[0]) + 12;
    }else{
      hour=int.parse(_selectedTime.split(':')[0]);
    }
    DateTime x=DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
        hour, int.parse(_selectedTime.split(':')[1].split(" ")[0]));
   // print(x);
  //  print(DateTime.now());
    LocalNotification().scheduleNotification(id:randomNumber,title:_titleController.text,body:_NoteController.text,scheduledDate: x);
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
    String? _formatedTime = _pickedTime?.format(context);
    if (_formatedTime != null) {
      setState(() {
        _selectedTime = _formatedTime;
      });
    }
  }

  _validate() async {
    if (_titleController.text.isNotEmpty && _NoteController.text.isNotEmpty) {
      final status=  await Permission.notification.status;
      if(status==PermissionStatus.denied){
        await Permission.notification.request();
      }
      Random random = Random();
      int randomNumber = random.nextInt(10000);
      print('************** $randomNumber');
      _addNoteToDb(randomNumber);
      _scheduleNotification(randomNumber);

    }
    if (_titleController.text.isEmpty || _NoteController.text.isEmpty) {
      var _errorsnackbar = SnackBar(
        content: Text(
          'All Field Required!!',
          style:
              GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w400),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(_errorsnackbar);
    }
  }
}
