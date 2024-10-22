import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hint;
  final TextEditingController myController;
  final String? Function(String?) valid;
  final int? maxLines;
  final bool isPasswordField;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;

  const CustomTextForm({
    super.key,
    required this.hint,
    required this.myController,
    required this.valid,
    this.maxLines,
    this.isPasswordField = false,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: valid,
        controller: myController,
        obscureText: isPasswordField ? !isPasswordVisible : false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          suffixIcon: isPasswordField
              ? IconButton(
            icon: Icon(

              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onVisibilityToggle,
          )
              : null,
        ),
        maxLines: maxLines ?? 1,
      ),
    );
  }
}
