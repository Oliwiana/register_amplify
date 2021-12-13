import 'package:amplify/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import 'home_view.dart';



class ConfirmCodeSingUp extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String userName;
  ConfirmCodeSingUp(this.userName);




  Widget build(BuildContext context) {

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
                    controller: authController.codeController,
                    // iconPrefix: Icons.lock,
                    // labelText: 'code',
                    // validator: ,
                    obscureText: false,
                    onChanged: (value) => null,
                    onSaved: (value) =>
                    authController.codeController.text = value!,
                    maxLines: 1, validator: (String ) {  },
                  ),

                  PrimaryButton(
                      labelText: 'Confirm reset',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          SystemChannels.textInput.invokeMethod(
                              'TextInput.hide'); //to hide the keyboard - if any
                          authController.codeConfirm(context);
                          Get.to(HomeView());
                        }
                      }),
                  // FormVerticalSpace(),
                  // LabelButton(
                  //   labelText: '',
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
