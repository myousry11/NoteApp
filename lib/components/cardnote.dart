import 'package:flutter/material.dart';
import 'package:note/app/model/notemodel.dart';
import 'package:note/constants/linkapi.dart';

import '../app/notedetailsview.dart';

class CardNotes extends StatelessWidget {
  final void Function() onDelete;
  final void Function() onEdit;
  final NoteModel noteModel;

  const CardNotes(
      {super.key,
      required this.onEdit,
      required this.onDelete,
      required this.noteModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailPage(noteModel: noteModel),
          ),
        );
      },
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "$linkImageRoot/${noteModel.notesImage}",
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: Text(
                  "${noteModel.notesTitle}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                subtitle: Text(
                  "${noteModel.notesContent}",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_forever_outlined),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
