import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scheduleapp/Models/Notes.dart';
import 'package:scheduleapp/Views/HomePage.dart';
import 'package:scheduleapp/Views/Widgets/MyButton.dart';
import 'package:scheduleapp/Views/Widgets/NoteTile.dart';
import 'package:scheduleapp/Views/Widgets/TextStyle.dart';

import '../Database/dbhelper.dart';

final dbProvider = Provider<DBHelper>((ref) => DBHelper());
final notesProvider = FutureProvider<dynamic>((ref) {
  return ref.read(dbProvider).getNotes();
});
final dateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final counterProvider = StateProvider<int>((ref) => 0);

class ListsNote extends ConsumerStatefulWidget {
  const ListsNote({super.key});

  @override
  ConsumerState<ListsNote> createState() => _ListsNoteState();
}

class _ListsNoteState extends ConsumerState<ListsNote> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkAndRequestPermission();
  }
  Future<void> _refresh()async {
  setState(() {});
  }

  Future<PermissionStatus> checkPermission() async {
    return await Permission.notification.status;
  }

  DBHelper? db = DBHelper();
  late Future<List<Notes>> noteList;
  //int count=0;

  @override
  Widget build(BuildContext context) {
    print('Built');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Lists')),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [
            FutureBuilder<PermissionStatus>(
                future: checkPermission(),
                builder: (context, value) {
                  if (value.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (value.data == PermissionStatus.permanentlyDenied ||
                      value.data == PermissionStatus.denied) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              const Text('Turn Your Notification on!!'),
                              TextButton(
                                  onPressed: () async {
                                      requestPermission(value.data!);

                                  },
                                  child: const Text('TurnON'))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                }),

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
                initialSelectedDate: ref.read(dateProvider),
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
                  ref.read(dateProvider.notifier).update((state) => date);
                },
              ),
            ),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final notesData = ref.watch(notesProvider);
                final selectedDate = ref.watch(dateProvider);
                return notesData.when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data?.length,
                          itemBuilder: (context1, index) {
                            Notes note = data![index];
                            int count =0;
                            //print(note.toMap());
                            if (DateFormat.yMd().format(note.date) ==
                                DateFormat.yMd().format(selectedDate)) {
                              count++;
                             //ref.watch(counterProvider.notifier).state++;
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
                            else{
                              return Container();
                            }
                          }
                          );
                    },
                    error: ((error, stackTrace) => Text(error.toString())),
                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    });
              }),
            ),
           // ref.read(counterProvider)==0?const Center(child: Text('No Notes')):Container()
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Notes note) {
    showBottomSheet(
        context: context,
        builder: (BuildContext context1) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            height: 250,
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

Future<void> requestPermission(PermissionStatus status) async {
  if (status == PermissionStatus.permanentlyDenied) {
    await openAppSettings();
  }
  await Permission.notification.request();
}
