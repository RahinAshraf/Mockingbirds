import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

OtpFieldController otpController = OtpFieldController();

class GroupId extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
      title: const Center(
        child: Text(
          'Enter PIN',
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  OTPTextField(
                    controller: otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldWidth: 40,
                    fieldStyle: FieldStyle.box,
                    outlineBorderRadius: 10,
                    style: const TextStyle(fontSize: 17),
                    onChanged: (pin) {},
                    onCompleted: (pin) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 0.5,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Confirm'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
