
// import 'dart:developer';
import 'package:get/get.dart';
import 'package:private_gallery/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordController extends GetxController implements GetxService {
  SharedPreferences prefs;
  PasswordController({required this.prefs});
  bool isConfirm = false;
  bool correctPassword=false;
  bool setupSuccess=false;
  String passcode = "";
  String addedPassCode = "";

  setPasscode(int index) {
    if (index == 10 && passcode.length < 6) {
      passcode = "${passcode}0";
    } else if ((index == 11) && passcode.isNotEmpty) {
      List local = passcode.split("");
      local.removeLast();
      passcode = "";
      for (var element in local) {
        passcode = "$passcode$element";
      }
      // log(passcode);
    } else if (index < 11 && passcode.length < 6) {
      passcode = "$passcode${index + 1}";
    }
    // log("$passcode $index");
    update();
  }

  addConfirm(int index){
    if (index == 10 && passcode.length < 6) {
      passcode = "${passcode}0";
    } else if ((index == 11) && passcode.isNotEmpty) {
      List local = passcode.split("");
      local.removeLast();
      passcode = "";
      for (var element in local) {
        passcode = "$passcode$element";
      }
      // log(passcode);
    } else if (index < 11 && passcode.length < 6) {
      passcode = "$passcode${index + 1}";
    }
    if (passcode.length==6) {
      String check=  prefs.getString(Constants.setPassCode) ?? "";
      if (passcode==check) {
        passcode = "";
        correctPassword=true;
        // log('correctPassword');
        update();
      } else {
        passcode = "";
      }
    }
    // log("$passcode $index");
    update();
  }

  savePasscode() {
    // if(addedPassCode.isNotEmpty && passcode.is)
    if (!isConfirm) {
      if (passcode.isNotEmpty) {
        isConfirm = true;
        addedPassCode = passcode;
        passcode = "";
        update();
      } else {
        // Fluttertoast.showToast(msg: "Invalid Passcode");
      }
    } else {
      if (addedPassCode == passcode) {
        prefs.setString(Constants.setPassCode, passcode);
        setupSuccess=true;
        update();
      } else {
        // Fluttertoast.showToast(msg: "passcode does not match");
      }
    }
  }

  checkPassword() {
    String check=  prefs.getString(Constants.setPassCode) ?? "";
    if (passcode.isNotEmpty) {
      if (passcode==check) {
        passcode = "";
        correctPassword=true;
        // log('correctPassword');
        update();
      } else {
        passcode = "";
        update();
      }
    }
  }

  clearData() {
    isConfirm = false;
    passcode = "";
    update();
  }
}