

import 'package:flutter/material.dart';
import 'package:scheduleapp/Models/Notes.dart';
import 'package:scheduleapp/Views/HomePage.dart';

import '../Database/dbhelper.dart';

class ListsNote extends StatefulWidget {
  const ListsNote({super.key});

  @override
  State<ListsNote> createState() => _ListsNoteState();
}

class _ListsNoteState extends State<ListsNote> {

  DBHelper? db=DBHelper();
  late Future<List<Notes>> noteList;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
        title: const Text('Lists'),),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Notes>>(
              future: db!.getNotes(),
                builder: (context, snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);
                }
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder:(context,index){
                        Notes note = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Text(note.title),
                            subtitle: Text(note.note),
                          ),
                        );
                      });
                }
                 return Container();

                }),
          ),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
          }, child: const Text('Add'))
  
        ],
      ),
    );
  }
}
