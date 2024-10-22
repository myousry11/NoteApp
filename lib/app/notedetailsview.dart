import 'package:flutter/material.dart';
import 'package:note/app/model/notemodel.dart';

class NoteDetailPage extends StatelessWidget {
  final NoteModel noteModel;

  const NoteDetailPage({Key? key, required this.noteModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${noteModel.notesTitle}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${noteModel.notesTitle}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "${noteModel.notesContent}",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
