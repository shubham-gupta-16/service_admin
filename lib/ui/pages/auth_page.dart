import 'package:flutter/material.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/ui/pages/home_page.dart';
import 'package:service_admin/ui/widgets/auth_text_field.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';
import 'package:service_admin/utils/utils.dart';

import '../../api/di/locator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Auth auth;

  @override
  void initState() {
    auth = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: _LoginFrom(callback: (String username, String password) {
          return auth.login(username, password);
        },),
      ),
    );
  }
}

class _LoginFrom extends StatefulWidget {
  final Future<AuthCode> Function(String username, String password) callback;
  const _LoginFrom({Key? key, required this.callback}) : super(key: key);

  @override
  State<_LoginFrom> createState() => __LoginFromState();
}

class __LoginFromState extends State<_LoginFrom> {

  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //---------------- EMAIL ------------------------
          const Text(
            "Username",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          AuthTextField(
            controller: emailController,
            hint: "Type your username",
            textInputAction: TextInputAction.next,
            type: AuthTextFieldType.username,
          ),
          const SizedBox(height: 20),
          //---------------- PASSWORD ------------------------
          const Text(
            "Password",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          AuthTextField(
            controller: passwordController,
            hint: 'Type your password',
            type: AuthTextFieldType.password,
          ),
          const SizedBox(height: 20),
          //---------------- FORGET PASSWORD ------------------------
          Align(
              alignment: Alignment.topRight,
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).colorScheme.primary),
              ),
          ),
          const SizedBox(height: 20),
          //---------------- LOGIN BUTTON ------------------------
          TextElevatedButton.text(
              text: 'Login',
              width: double.infinity,
              height: 50,
              onPressed: () async {
                print('login pressed');
                if (_formKey.currentState!.validate()) {
                  context.showLoaderDialog();
                  final code = await widget.callback(emailController.text.trim(), passwordController.text.trim());
                  if (!mounted) return;
                  context.navigatePop();
                  if(code == AuthCode.success){
                    context.navigatePushReplace(const HomePage());
                  } else {
                    print(code.name);
                  }
                }
              }),

          /*const SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                *//*defining default style is optional *//*
                children: <TextSpan>[
                  TextSpan(
                      text: ' Sign up',
                      style: TextStyle(
                          color: Color(0xff4D63D5), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
