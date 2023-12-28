import 'package:flutter/material.dart';
import 'package:scheduleapp/Models/Notes.dart';
import 'package:scheduleapp/Views/HomePage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lists'),
      ),
      body: Column(
        children: [
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
                          return GestureDetector(
                              onTap: () => _showBottomSheet(context, note),
                              child: NoteTile(note));
                        });
                  }
                  return Container();
                }),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Text('Add'))
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
            width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                ),
                Spacer(),
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
                SizedBox(height: 20,),
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
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: !isClose? clr:Colors.transparent,
            border: Border.all(width: 2, color: isClose ? Colors.grey : clr),
            borderRadius: BorderRadius.circular(15)),
        child: Center(child: Text(label,style: titleStyle(),),),
      ),
    );
  }
}
