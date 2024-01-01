import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/Models/Notes.dart';
import 'package:scheduleapp/NotificationHandler/local_notification.dart';
import 'package:scheduleapp/Views/HomePage.dart';
import 'package:scheduleapp/Views/Widgets/MyButton.dart';
import 'package:scheduleapp/Views/Widgets/NoteTile.dart';
import 'package:scheduleapp/Views/Widgets/TextStyle.dart';

import '../Database/dbhelper.dart';

class ListsNote extends StatefulWidget {
  const ListsNote({super.key});

  @override
  State<ListsNote> createState() => _ListsNoteState();
}

class _ListsNoteState extends State<ListsNote> {
  DBHelper? db = DBHelper();
  late Future<List<Notes>> noteList;
  DateTime? _selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Lists')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(DateTime.now()),
                      style: GoogleFonts.lato(fontSize: 15),
                    ),
                    Text(
                      'Today',
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
                MyButton(
                  text: '+Add',
                  onClick: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: DatePicker(
              DateTime.now(),
              initialSelectedDate: _selectedTime,
              height: 100,
              width: 80,
              selectionColor: Colors.deepPurple,
              dateTextStyle:
                  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 20),
              monthTextStyle:
                  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 12),
              dayTextStyle:
                  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 12),
              onDateChange: (date) {
                setState(() {
                  _selectedTime = date;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Notes>>(
                future: db!.getNotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context1, index) {
                          Notes note = snapshot.data![index];
                          //print(note.toMap());
                          if (DateFormat.yMd().format(note.date) ==
                              DateFormat.yMd().format(_selectedTime!)) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                child: SlideAnimation(
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () =>
                                          _showBottomSheet(context, note),
                                      child: NoteTile(note),
                                    ),
                                  ),
                                ));
                          }
                          return Container();
                        });
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }

  _showBottomSheet(BuildContext context, Notes note) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context1) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            height: note.isCompleted == true
                ? MediaQuery.of(context).size.height * 0.24
                : MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
                const Spacer(),
                note.isCompleted == true
                    ? Container()
                    : _bottomSheetButton(
                        label: 'Task Completed',
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                        clr: Colors.deepPurple,
                        context: context),
                _bottomSheetButton(
                    label: 'Delete Task',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    clr: Colors.red,
                    context: context),
                const SizedBox(
                  height: 20,
                ),
                _bottomSheetButton(
                    label: 'Cancel',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    clr: Colors.deepPurple,
                    isClose: true,
                    context: context),
              ],
            ),
          );
        });
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: !isClose ? clr : Colors.transparent,
            border: Border.all(width: 2, color: isClose ? Colors.grey : clr),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            label,
            style: titleStyle(),
          ),
        ),
      ),
    );
  }
}
