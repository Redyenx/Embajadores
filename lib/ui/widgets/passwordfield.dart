import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(
      {Key? key,
      this.fieldKey,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldChange,
      this.controller})
      : super(key: key);

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged? onFieldChange;
  final TextEditingController? controller;
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  Icon _icon = const Icon(
    Icons.visibility,
    color: Colors.deepPurpleAccent,
    size: 20,
  );
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: 'passwordField',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      key: widget.fieldKey,
      obscureText: _obscureText,
      onSaved: widget.onSaved,
      onChanged: widget.onFieldChange,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon:
            const Icon(Icons.lock, color: Colors.deepPurpleAccent, size: 18),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
                _icon = ((_obscureText)
                    ? const Icon(
                        Icons.visibility,
                        color: Colors.deepPurpleAccent,
                        size: 18,
                      )
                    : const Icon(
                        Icons.visibility_off,
                        color: Colors.deepPurpleAccent,
                        size: 18,
                      ));
              });
            },
            child: _icon),
      ),
    );
  }
}
