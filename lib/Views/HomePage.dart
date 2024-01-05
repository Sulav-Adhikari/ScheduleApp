import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:scheduleapp/RiverPodClasses/Providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  DBHelper? db;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

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
                controller: _noteController,
              ),
              Consumer(builder: (context,ref,child){
                final selectedDate =ref.watch(selectedDateProvider);
                return MyInputField(
                  title: 'Date',
                  hint: DateFormat.MMMMEEEEd().format(selectedDate),
                  widget: IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () {
                      _getDatefromUser(ref);
                      //DatePicker
                    },
                  ),
                );
              }),Consumer(builder: (context,ref,child){
                final selectedTime =ref.watch(selectedTimeProvider);
                return MyInputField(
                  title: 'Time',
                  hint: selectedTime,
                  widget: IconButton(
                    icon: const Icon(Icons.access_time_outlined),
                    onPressed: () {
                      _getTimeFromUser(ref);
                    },
                  ),
                );
              }),


              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Center(
                    child: MyButton(
                  text: 'Add Task',
                  onClick: () {
                    _validate(ref);
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

  _addNoteToDb(int randomNumber,DateTime selectedDate,String selectedTime) async {
    Notes note = Notes(
        title: _titleController.text,
        note: _noteController.text,
        date: selectedDate,
        time: selectedTime,
        isCompleted: false,
        notId: randomNumber
    );
    await db?.insert(note);
   // print('clickedd  ${N}');
  }
  _scheduleNotification(int randomNumber,DateTime selectedDate,String selectedTime){
    int hour;

    if (selectedTime.split(':')[1].split(" ")[1]=='PM'){
      hour = int.parse(selectedTime.split(':')[0]) + 12;
    }else{
      hour=int.parse(selectedTime.split(':')[0]);
    }
    DateTime x=DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        hour, int.parse(selectedTime.split(':')[1].split(" ")[0]));
   // print(x);
  //  print(DateTime.now());
    LocalNotification().scheduleNotification(id:randomNumber,title:_titleController.text,body:_noteController.text,scheduledDate: x);
  }

  _getDatefromUser(WidgetRef ref) async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2029));
    if (_pickedDate != null) {
      ref.read(selectedDateProvider.notifier).update((state) => _pickedDate);
    }
  }

  _getTimeFromUser(WidgetRef ref) async {
    final selectedTime= ref.read(selectedTimeProvider);
    int hour = int.parse(selectedTime.split(':')[0]);
    String dayNight= selectedTime.split(':')[1].split(" ")[1];
    if(dayNight=='PM'){
      hour=hour+12;
    }
    var pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: hour,
            minute: int.parse(selectedTime.split(':')[1].split(" ")[0])));
    String? formattedTime = pickedTime?.format(context);
    if (formattedTime != null) {
      ref.read(selectedTimeProvider.notifier).update((state) => formattedTime);
    }
  }

  _validate(WidgetRef ref) async {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      final status=  await Permission.notification.status;
      if(status==PermissionStatus.denied){
        await Permission.notification.request();
      }
      Random random = Random();
      int randomNumber = random.nextInt(10000);
      final selectedDate =ref.read(selectedDateProvider);
      final selectedTime =ref.read(selectedTimeProvider);
      _addNoteToDb(randomNumber,selectedDate,selectedTime);
      _scheduleNotification(randomNumber,selectedDate,selectedTime);

    }
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      var errorsnackbar = SnackBar(
        content: Text(
          'All Field Required!!',
          style:
              GoogleFonts.lato(color: Colors.red, fontWeight: FontWeight.w400),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(errorsnackbar);
    }
  }
}
