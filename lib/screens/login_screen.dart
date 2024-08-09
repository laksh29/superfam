import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:super_extensions/super_extensions.dart';
import 'package:superfam_1/screens/home_screen.dart';
import 'package:superfam_1/widgets/button.dart';
import 'package:superfam_1/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _phoneCont;
  late TextEditingController _otpCont;

  bool _isOtpSent = false;
  bool verifyOtp = false;

  @override
  void initState() {
    _phoneCont = TextEditingController();
    _otpCont = TextEditingController();

    _otpCont.addListener(() {
      if (_otpCont.text.length == 6) {
        setState(() {
          verifyOtp = true;
        });
      } else {
        setState(() {
          verifyOtp = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneCont.dispose();
    _otpCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox.square(
                dimension: context.screenWidth * 0.8,
                child: Image.asset("assets/logo.png"),
              ),
              30.hSizedBox,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome to SuperFam",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    20.hSizedBox,
                    SimpleTextField(
                      textEditingController: _phoneCont,
                      header: "Enter your mobile number:",
                      inputType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      hintText: "Phone Number",
                      maxLength: 10,
                      enable: _isOtpSent ? false : true,
                    ),
                    if (_isOtpSent)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isOtpSent = false;
                          });
                        },
                        child: Text(
                          "Edit phone number",
                          style: TextStyle(
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    if (_isOtpSent) 30.hSizedBox,
                    if (_isOtpSent)
                      const Text(
                        "OTP:",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    if (_isOtpSent)
                      PinCodeTextField(
                        mainAxisAlignment: MainAxisAlignment.start,
                        appContext: context,
                        length: 6,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        textStyle: TextStyle(
                          color: Colors.blue[900],
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(4.0),
                          fieldHeight: 48,
                          fieldWidth: 36,
                          fieldOuterPadding: const EdgeInsets.all(5),
                          activeFillColor: Colors.white,
                          activeColor: Colors.blue[100],
                          inactiveColor: Colors.blue[100],
                          selectedColor: Colors.red[100],
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          borderWidth: 2,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        errorAnimationController: null,
                        controller: _otpCont,
                        autoDisposeControllers: false,
                        onCompleted: (v) {},
                        beforeTextPaste: (text) {
                          return true;
                        },
                        onChanged: (String value) {},
                      ),
                    30.hSizedBox,
                    CustomButton(
                      onTap: () {
                        if (!_isOtpSent) {
                          if (_phoneCont.text.isNotEmpty &&
                              _phoneCont.text.length >= 10) {
                            setState(() {
                              _isOtpSent = true;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blue[900],
                                content: const Text(
                                  "Please enter a valid phone number",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          if (_isOtpSent && !verifyOtp) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blue[900],
                                content: const Text(
                                  "Enter a valid OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => DetailsDialog(
                                phoneCont: _phoneCont,
                                otpCont: _otpCont,
                              ),
                            );
                          }
                        }
                      },
                      color: _isOtpSent && !verifyOtp
                          ? Colors.grey
                          : Colors.blue[900],
                      text: !_isOtpSent ? "Send OTP" : "Log In",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsDialog extends StatelessWidget {
  const DetailsDialog({
    super.key,
    required TextEditingController phoneCont,
    required TextEditingController otpCont,
  })  : _phoneCont = phoneCont,
        _otpCont = otpCont;

  final TextEditingController _phoneCont;
  final TextEditingController _otpCont;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Phone No: ",
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              children: [
                TextSpan(
                  text: _phoneCont.text,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          10.hSizedBox,
          RichText(
            text: TextSpan(
              text: "OTP: ",
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              children: [
                TextSpan(
                  text: _otpCont.text,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (_) => false,
            );
          },
          child: Container(
            width: double.infinity,
            height: context.screenHeight * 0.05,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: const Text(
              "Let's go home",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
