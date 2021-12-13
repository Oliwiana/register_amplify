
import 'dart:async';


import 'package:amplify/models/User.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../datastore_service.dart';
import '../../../../singup.dart';
import 'home_view.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  TextEditingController codeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final DataStoreService _db = DataStoreService();
  RxBool isSignedIn = false.obs;
  RxBool isLoading = false.obs;
  // late final String userName;
  User? get user => currentUser.value;
  Rxn<User> currentUser = Rxn<User>();


  @override
  void onReady() {
    isUserSignedIn();
     handleAuthChanged(isSignedIn);
    print( 'is signed in ? ' '$isSignedIn');
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  Future<bool> isSignedIn1() async {
    AuthSession authSessions = await Amplify.Auth.fetchAuthSession();
    return authSessions.isSignedIn;
  }
  void isUserSignedIn() async {

    try {
      isSignedIn.value = await isSignedIn1();
    } catch (e) {
      throw e;
    }
  }

  handleAuthChanged(isSignedIn) async {
    if (isSignedIn == false) {
      print('Send to signUp/in');
      Get.offAll(()=>SignUpUI());
    } else {
      Get.offAll(()=>HomeView());
    }
  }
  Future<AuthUser> getCurrentUser() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    return authUser;
  }

  Future<void> getCurrUser() async {
    AuthUser authUser = await getCurrentUser();
    currentUser.value = (await _db.getUser(authUser.userId));
    print(currentUser.value);
  }

  Future saveUser(String email) async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    User user = new User(
      id: authUser.userId,
      email: email, name: '',

    );
    await _db.saveUser(user);
  }

  // User registration using email and password
 void registerWithEmailAndPassword(BuildContext context) async {

    try {
      Map<String, String> userAttributes = {
        "email": emailController.text.trim(),
        "preferred_username": emailController.text.trim(),
        // additional attributes as needed
      };
      SignUpResult res = await Amplify.Auth.signUp(
          username: emailController.text.trim(),
          password: passwordController.text.trim(),
          options: CognitoSignUpOptions(userAttributes:userAttributes));

      print(res.isSignUpComplete);

    } on AuthException catch (e) {
      print(e.message);
    }
  }

  codeConfirm(BuildContext context) async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: emailController.text.trim(),
          confirmationCode: codeController.text.trim());
      if (res.isSignUpComplete) {
        await saveUser(emailController.text.trim());
      }
    } on AuthException catch (e) {
      print(e.message);
    }
  }


  void signIn(AuthProvider authProvider) async {
    try {
   await Amplify.Auth.signInWithWebUI(provider: authProvider);
      isSignedIn.value = true;
      // _setuplistener();
    } catch (e) {
      throw e;
    }
  }

  // Sign out
  void signOut() async {
    try {
      await Amplify.DataStore.clear();
      await Amplify.Auth.signOut();
      isSignedIn.value = false;
      isLoading.value = false;
    } on AuthException catch (e) {
      print(e.message);
    }
  }


}
