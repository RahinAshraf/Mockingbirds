import 'package:flutter/material.dart';

class GroupId extends StatelessWidget {
  String fullPin = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0.0),
      title: const Center(
        child: Text(
          "Enter PIN",
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
                  TextField(
                    maxLength: 6,
                    onChanged: (pin) {
                      // TODO: do something with the pin
                      fullPin = pin;
                      print("The pin: " + pin);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: do something with pin
                        if (fullPin == '123') {
                          print('The pin is correct omg');
                        } else {
                          print('The pin is incorrect');
                        }
                      },
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
