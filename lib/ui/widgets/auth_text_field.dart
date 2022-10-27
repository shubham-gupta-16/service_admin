
import 'package:flutter/material.dart';

enum AuthTextFieldType{
  username,
  email,
  password, number
}

class AuthTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final AuthTextFieldType type;
  final int? maxLength;
  final TextAlign? textAlign;
  final TextInputAction? textInputAction;
  const AuthTextField({Key? key, this.controller, required this.hint, this.type = AuthTextFieldType.username, this.textInputAction, this.textAlign, this.maxLength}) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textAlign: widget.textAlign?? TextAlign.start,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      keyboardType: keyboardType(widget.type),
      validator: (value)=> validator(widget.type, value),
      obscureText: !isPasswordVisible && widget.type == AuthTextFieldType.password,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(50),
        ),
        hintText: widget.hint,
        // for password
        suffixIcon: widget.type == AuthTextFieldType.password ? IconButton(
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          icon: Icon(
            !isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ):null,
      ),
    );

    return TextField(
      // controller: _textEditingController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
          ),
          fillColor: Theme.of(context).colorScheme.secondaryContainer,
          filled: true,
          hintText: "Command"
      ),
    );
  }

  TextInputType keyboardType(AuthTextFieldType type){
    switch (type){
      case AuthTextFieldType.username:
        return TextInputType.text;
      case AuthTextFieldType.email:
        return TextInputType.emailAddress;
      case AuthTextFieldType.password:
        return TextInputType.text;
      case AuthTextFieldType.number:
        return TextInputType.number;
    }
  }

  String? validator(AuthTextFieldType type, String? value) {
    switch (type){
      case AuthTextFieldType.username:
        final regex = RegExp(r'^[a-zA-Z0-9]+$');
        if (value == null || value.length < 4) {
          return 'Username must be of 4-digits';
        } else if(!regex.hasMatch(value)){
          return 'Username must only contains alphabets and numbers';
        } else {
          return null;
        }
      case AuthTextFieldType.email:
        String pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$";
        RegExp regex = RegExp(pattern);
        if (value == null || value.isEmpty || !regex.hasMatch(value)) {
          return 'Enter a valid email address';
        } else {
          return null;
        }
      case AuthTextFieldType.password:
        if (value == null || value.length < 6) {
          return 'Password must be of 6-digits';
        } else {
          return null;
        }
      case AuthTextFieldType.number:
        return null;
    }

  }
}
