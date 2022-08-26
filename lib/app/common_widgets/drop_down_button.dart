import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final List<String> dropdownItems;
  final void Function(String) onSaved;
  final String initialSelectedItem;
  const MyDropdownButton(
      {Key? key,
      required this.dropdownItems,
      required this.onSaved,
      required this.initialSelectedItem})
      : super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  late String _selectedItem;

  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
    widget.onSaved(_selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 25,
        value: _selectedItem,
        onChanged: (String? newValue) {
          setState(() {
            if (newValue != null) _selectedItem = newValue;
            widget.onSaved(_selectedItem);
          });
        },
        items:
            widget.dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
