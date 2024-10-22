import 'package:flutter/material.dart';
import 'package:note/components/crud.dart';
import 'package:note/components/customtextform.dart';
import 'package:note/components/valid.dart';
import 'package:note/constants/linkapi.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Crud _crud = Crud();
  bool isLoading = false;
  bool isPasswordVisible = false;
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  signUp() async {
    if(formState.currentState!.validate()){
      isLoading = true;
      setState(() {});
      var response = await _crud.postRequest(linkSignUp, {
        "username": username.text,
        "email": email.text,
        "password": password.text,
      });
      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        print("Sign Up Fail");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Center(
              child: Text("Loading.."),
            )
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
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
                        CustomTextForm(
                          hint: "Username",
                          myController: username,
                          valid: (val) {
                            return validInput(val!, "Username",3, 20);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextForm(
                          hint: "Email",
                          myController: email,
                          valid: (val) {
                            return validInput(val!, "Email", 5, 40);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextForm(
                          hint: 'password',
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
                          onPressed: () async {
                            await signUp();
                            Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
                          },
                          child: Text("Sign Up"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          child: Text("Login"),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed("login");
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
