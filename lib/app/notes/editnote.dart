import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/constants/linkapi.dart';

import '../../components/crud.dart';
import '../../components/customtextform.dart';
import '../../components/valid.dart';


class EditNotes extends StatefulWidget {
  final notes;
  const EditNotes({super.key, this.notes});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {

  File? file;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Crud crud = Crud();

  editNotes() async {
    if (formState.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response;
      if(file == null){
        response = await crud.postRequest(linkEdit, {
          "title": title.text,
          "content": content.text,
          "id": widget.notes['notes_id'].toString(),
          "imagename": widget.notes['notes_image'].toString(),
        });
      }
      else{
        response = await crud.postRequestWithFile(linkEdit, {
          "title": title.text,
          "content": content.text,
          "id": widget.notes['notes_id'].toString(),
          "imagename": widget.notes['notes_image'].toString(),
        }, file!);
      }
      isLoading = false;
      setState(() {});
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      }
    }
  }
  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Notes"),
      ),
      body: isLoading == true
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
                key: formState,
                child: Column(
                  children: [
                    CustomTextForm(
                        hint: "Title",
                        myController: title,
                        valid: (val) {
                          return validInput(val!, "Title" ,1, 40);
                        }, maxLines: 1,),
                    CustomTextForm(
                        hint: "Content",
                        myController: content,
                        valid: (val) {
                          return validInput(val!, "Content",10, 255);
                        }, maxLines: 10,),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textColor: Colors.white,
                        color: file == null ? Colors.blue : Colors.green,
                        onPressed: () async {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Choose Image",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    InkWell(
                                      onTap:() async{
                                        XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                        Navigator.of(context).pop();
                                        file = File(xFile!.path);
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        child: Text("From Gallery", style: TextStyle(fontSize: 16),),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async{
                                        XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
                                        Navigator.of(context).pop();
                                        file = File(xFile!.path);
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        child: Text("From Camera", style: TextStyle(fontSize: 16),),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                        child: Text("Choose Image"),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 45,
                          width: 200,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            textColor: Colors.white,
                            color: Colors.blue,
                            onPressed: () async {
                              await editNotes();
                            },
                            child: Text("Edit Note"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
