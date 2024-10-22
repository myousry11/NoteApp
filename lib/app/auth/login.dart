import 'package:flutter/material.dart';
import 'package:note/components/crud.dart';
import 'package:note/components/customtextform.dart';
import 'package:note/constants/linkapi.dart';
import 'package:note/main.dart';

import '../../components/valid.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Crud _crud = Crud();
  bool isLoading = false;
  bool isPasswordVisible = false;

  login() async{
    if(formState.currentState!.validate()){
      isLoading = true;
      setState(() {

      });
      var response = await _crud.postRequest(linkLogin, {
        "email" : email.text,
        "password" : password.text,
      });
      isLoading = false;
      setState(() {

      });
      if(response['status'] == "success"){
         sharedPref.setString("id", response['data']['id'].toString());
         sharedPref.setString("username", response['data']['username']);
         sharedPref.setString("email", response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      }
      else{
        AlertDialog(
          title: Text("Attention"),
          content: Text("Email or password incorrect"),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: isLoading == true ? Center(child: CircularProgressIndicator()) : ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/icon.png",
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CustomTextForm(
                    hint: "Email",
                    myController: email,
                    valid: (val) {
                      return validInput(val!, "Email",5, 40);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextForm(
                    hint: 'Password',
                    myController: password,
                    valid: (val) {
                      return validInput(val!, "Password", 3, 15);
                    },
                    isPasswordField: true,
                    isPasswordVisible: isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () async{
                      await login();
                    },
                    child: Text("Login"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Text("Sign Up"),
                    onTap: () {
                      Navigator.of(context).pushNamed("signup");
                    },
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
