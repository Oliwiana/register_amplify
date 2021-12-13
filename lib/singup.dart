
import 'package:amplify/primary_button.dart';
import 'package:amplify/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'confirm_singup.dart';
import 'home_controller.dart';

class SignUpUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    // AuthController authController = Get.find();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              TextFormField(
                    controller: authController.emailController,
                    // iconPrefix: Icons.email,
                    // labelText: 'auth.emailFormField'.tr,
                    validator: Validator().email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                    authController.emailController.text = value!,
                  ),
                  TextFormField(
                    controller: authController.passwordController,
                    // iconPrefix: Icons.lock,
                    // labelText: 'auth.passwordFormField'.tr,
                    validator: Validator().password,
                    obscureText: true,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                    authController.passwordController.text = value!,
                    maxLines: 1,
                  ),

                  PrimaryButton(
                      labelText: 'signUpButton',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput.invokeMethod(
                              'TextInput.hide'); //to hide the keyboard - if any
                          authController.registerWithEmailAndPassword(context);
                          Get.to(ConfirmCodeSingUp(authController.emailController.text));
                          // }
                        }}),

                  // LabelButton(
                  //   labelText: 'auth.signInLabelButton'.tr,
                  //   onPressed: () => Get.to(SignInUI()),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
