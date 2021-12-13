import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'home_controller.dart';



class HomeView extends GetWidget<AuthController> {
  AuthController authcontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        title: GetX<AuthController>(
          initState: (_) async {
            await Get.find<AuthController>().getCurrUser();
          },
          builder: (_) {
            return Text(controller.user?.email ?? '',
                style: TextStyle(fontSize: 12));
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authcontroller.signOut();
            },
          ),
        ],
      ),
    );
  }
}
