import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_rent/core/values/app_colors.dart';
import 'package:smart_rent/core/widget/dialog_custom.dart';
import 'package:smart_rent/core/widget/text_form_field_input.dart';
import 'package:smart_rent/modules/login/controllers/login_controller.dart';
import 'package:smart_rent/modules/login/views/login_verify_screen.dart';
import 'package:smart_rent/modules/signup/views/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final controller = Get.put(LoginController());
  void submit() async {
    try {
      String resQuery = await LoginController.instance
          .checkExistPhoneNumber(controller.phoneNo.text.trim());
      // check log in co ton tai tai khoan => tien hanh dang nhap
      if (resQuery == 'exist') {
        LoginController.instance
            .phoneAuthentication(controller.phoneNo.text.trim());
        Get.to(
          () => LoginVerifyScreen(
            phoneNumber: controller.phoneNo.text.trim(),
          ),
        );
      } else {
        Get.dialog(
          DialogCustom(
              onPressed: () {
                Get.to(() => const SignUpScreen());
              },
              backgroundColor: Colors.white,
              iconPath: 'assets/images/ic_notify.png',
              title: 'Thông báo',
              subTitle:
                  'Không tồn tại tài khoản với số điện thoại này, đăng kí ngay'),
        );
      }
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/ic_logo_login.png'),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Chào mừng bạn đã trở lại',
              style: TextStyle(
                color: primary10,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Đăng nhập để khám phá các phòng trọ\n tuyệt vời đang chờ đón bạn.',
              style: TextStyle(
                color: secondary40,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormFieldInput(
                      maxLength: 10,
                      textEditingController: controller.phoneNo,
                      labelText: 'Số điện thoại',
                      hintText: 'Nhập số điện thoại',
                      textInputType: TextInputType.phone,
                      borderRadius: BorderRadius.circular(8),
                      borderWidth: 2,
                      borderColor: primary60,
                      icon: const Icon(Icons.phone_android),
                      onSaved: (newValue) {},
                      onValidate: (value) {
                        if (value!.isEmpty || value.length < 10) {
                          return 'Vui lòng nhập số điện thoại';
                        }
                        return null;
                      },
                      autoCorrect: false,
                      textCapitalization: TextCapitalization.none,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          submit();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: primary60),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Đăng nhập ngay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Bạn chưa có tài khoản?',
                          style: TextStyle(
                            color: secondary40,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => const SignUpScreen(),
                            );
                          },
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(color: primary60),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
