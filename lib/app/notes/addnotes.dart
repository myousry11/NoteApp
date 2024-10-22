import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:note/components/crud.dart';
import 'package:note/components/customtextform.dart';
import 'package:note/components/valid.dart';
import 'package:note/constants/linkapi.dart';
import 'package:note/main.dart';


class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;
  File? file ;


  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  Crud crud = Crud();

  addNotes() async {
    // if (file == null) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text("No Photo"),
    //       content: Text("Please Add a photo"),
    //     ),
    //   );
    //   return;
    // }
    if (formState.currentState?.validate() ?? false) { // Validate before proceeding
      setState(() {
        isLoading = true; // Start loading
      });
      var response = await crud.postRequestWithFile(linkAdd, {
        "title": title.text,
        "content": content.text,
        "id": sharedPref.getString("id"),
      }, file!);
      setState(() {
        isLoading = false; // End loading
      });
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notes"),
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
                                return validInput(val!,  "Title",1, 40);
                              }, maxLines: 1,),
                          CustomTextForm(
                              hint: "Content",
                              myController: content,
                              valid: (val) {
                                return validInput(val!,  "Content",10, 255);
                              }, maxLines: 10,),
                          SizedBox(
                            height: 10,
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
                                      height: 140,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Choose Image",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            height: 50,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            height: 45,
                            width: 200,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              textColor: Colors.white,
                              color: Colors.blue,
                              onPressed: () async {
                                await addNotes();
                              },
                              child: Text("Add Note"),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
    );
  }
}
