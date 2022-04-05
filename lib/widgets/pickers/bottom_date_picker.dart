import 'package:flutter/cupertino.dart';

/// Pop Up widget for choosing a date
/// Author(s): Eduard Ragea
class BottomDatePicker extends StatefulWidget {
  final CupertinoDatePicker picker;

  const BottomDatePicker(this.picker, {Key? key}) : super(key: key);

  @override
  State<BottomDatePicker> createState() => _BottomDatePickerState();
}

class _BottomDatePickerState extends State<BottomDatePicker> {
  final double _kPickerSheetHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: widget.picker,
          ),
        ),
      ),
    );
  }
}
