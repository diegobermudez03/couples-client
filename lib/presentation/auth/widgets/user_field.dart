import 'package:flutter/material.dart';


class UserField extends StatelessWidget{

  final String hintText;
  final String labelText;
  final bool password;
  final bool editable;
  final TextEditingController controller;

  const UserField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.editable,
    this.password = false,
    
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return TextField(
      readOnly: !editable,
      controller: controller,
      style: textTheme.bodyLarge!.copyWith(
        color: colorScheme.onSecondaryContainer
      ),

      // Placeholder text styling
      decoration: InputDecoration(
        // Placeholder text
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),

        // Label above the text field
        labelText: labelText,
        labelStyle: textTheme.titleMedium!.copyWith(
          color: colorScheme.primary
        ),
        
        // Borders
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent,width: 0),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.tertiary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        // Content padding
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

        // Filled background
        filled: true,
        fillColor: colorScheme.secondaryContainer,
      ),

      // Text input control
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLength: 50,
    );
  }
}