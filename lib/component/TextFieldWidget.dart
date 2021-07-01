import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  final bool number;
  final bool date;

  const TextFieldWidget({
    Key key,
    this.maxLines = 1,
    this.label,
    this.text,
    this.onChanged,
    this.number = false,
    this.date = false,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  TextEditingController controller;
  FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void _onLostFocus() {
    if (!_focusNode.hasFocus) widget.onChanged(controller.text);
  }

  void _onPickingDate() {
    widget.onChanged(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.addListener(_onLostFocus);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        widget.number == true
            ? TextField(
                controller: controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: widget.maxLines,
              )
            : widget.date == true
                ? TextField(
                    controller: controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: widget.maxLines,
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2022))
                          .then((value) {
                        DateFormat formatter = new DateFormat('yyyy-MM-dd');
                        controller.text = formatter.format(value);
                        _onPickingDate();
                      });
                    },
                  )
                : TextField(
                    controller: controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: widget.maxLines,
                  )
      ],
    );
  }
}
