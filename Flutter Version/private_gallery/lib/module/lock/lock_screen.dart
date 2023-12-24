import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:private_gallery/config/constant.dart';
import 'package:private_gallery/config/routes.dart';
import 'package:private_gallery/config/routes_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/password_controller.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String? appPassword;

  @override
  void initState() {
    super.initState();
    Get.find<PasswordController>().clearData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkPassword(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return  SizedBox(
              child:Image.asset(
                      'assets/images/app_logo.jpg',
                      height: 100,
                      width: 100,
                    )
            );
          } else {
            if (appPassword != null) {
              return addConfirmPassword();
            } else {
              return setUpPassword();
            }
          }
        });
  }

  Future<bool> checkPassword() async {
    final prefs = await SharedPreferences.getInstance();
    appPassword = prefs.getString(Constants.setPassCode);
    return true;
  }

  Widget addConfirmPassword() {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10,
                  ),
                  child: Center(
                    child: Container(
                        height: 110,
                        width: 110,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Image.asset(
                        'assets/images/app_logo.jpg',
                        fit: BoxFit.scaleDown,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: GetBuilder<PasswordController>(builder: (state) {
                  if (state.correctPassword) {
                    Future.delayed(Duration.zero, () {
                      context.left(Routes.home,(route)=>false);
                    });
                  }
                  return Text(
                    state.isConfirm ? "Confirm Passcode" : "Set Passcode",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                  );
                }),
              ),

              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 6; i++)
                    GetBuilder<PasswordController>(builder: (state) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            state.passcode.length >= i + 1 ? "*" : "",
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      );
                    }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),
                child: GetBuilder<PasswordController>(builder: (state) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 12,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0.0,
                      childAspectRatio: 2,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, index) {
                      if (index == 9) {
                        return const SizedBox();
                      }
                      if (index == 11) {
                        return GestureDetector(
                          onTap: () {
                            state.setPasscode(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColorDark,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          state.addConfirm(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColorDark,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                "${index == 10 ? 0 : index + 1}"
                                ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget setUpPassword() {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 60,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Get.find<PasswordController>().savePasscode();
                },
                child: GetBuilder<PasswordController>(
                  builder: (state) {
                    if (state.setupSuccess) {
                      Future.delayed(Duration.zero, () {
                        context.left(Routes.home, (route) => false);
                      });
                    }
                    return Text(
                      state.isConfirm ? "Set Passcode" : "Save Passcode",
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10,
                  ),
                  child: Center(
                    child: Container(
                        height: 110,
                        width: 110,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Image.asset(
                        'assets/images/app_logo.jpg',
                        fit: BoxFit.scaleDown,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: GetBuilder<PasswordController>(builder: (state) {
                  return Text(
                    state.isConfirm ? "Confirm Passcode" : "Set Passcode",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                  );
                }),
              ),

              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 6; i++)
                    GetBuilder<PasswordController>(builder: (state) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            state.passcode.length >= i + 1 ? "*" : "",
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      );
                    }),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // keyboard buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),
                child: GetBuilder<PasswordController>(builder: (state) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 12,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0.0,
                      childAspectRatio: 2,
                      mainAxisSpacing: 10.0,
                    ),
                    itemBuilder: (context, index) {
                      if (index == 9) {
                        return const SizedBox();
                      }
                      if (index == 11) {
                        return GestureDetector(
                          onTap: () {
                            state.setPasscode(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColorDark,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          state.setPasscode(index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColorDark,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                "${index == 10 ? 0 : index + 1}"
                                ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
