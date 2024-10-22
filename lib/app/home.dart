import 'package:flutter/material.dart';
import 'package:note/app/model/notemodel.dart';
import 'package:note/components/cardnote.dart';
import 'package:note/constants/linkapi.dart';
import 'package:note/app/notes/editnote.dart';
import 'package:note/main.dart';
import '../components/crud.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud crud = Crud();
  getNotes() async {
    var response = await crud.postRequest(linkView, {
      "id": sharedPref.getString("id"),
    });
    return response;
  }

  List notes = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
              onPressed: () {
                sharedPref.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("addnotes");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[300],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
                future: getNotes(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['status'] == 'fail')
                      return Center(child: Text("No Available Notes"));
                    return ListView.builder(
                        itemCount: snapshot.data['data'].length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return CardNotes(
                            onEdit: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditNotes(
                                    notes: snapshot.data['data'][i],
                                  ),
                                ),
                              );
                            },
                            onDelete: () async {
                              var response =
                                  await crud.postRequest(linkDelete, {
                                "id": snapshot.data['data'][i]['notes_id']
                                    .toString(),
                                    "imagename" : snapshot.data['data'][i]['notes_image']
                                        .toString(),
                              });
                              if (response['status'] == 'success') {
                                Navigator.of(context)
                                    .pushReplacementNamed("home");
                              }
                            },
                            noteModel:
                                NoteModel.fromJson(snapshot.data['data'][i]),
                          );
                        });
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading ..."),
                    );
                  }
                  return Center(
                    child: Text("Loading ..."),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
