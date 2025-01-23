import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:ionicons/ionicons.dart';

class AuthField extends StatefulWidget{

  final Widget icon;
  final String hintText;
  final String labelText;
  final bool password;

  AuthField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.labelText,
    this.password = false,
    
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {

  bool hideText = false;

  @override
  void initState() {
    hideText = widget.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return TextField(
      style: textTheme.bodyLarge!.copyWith(
        color: colorScheme.onTertiaryContainer
      ),

      // Placeholder text styling
      decoration: InputDecoration(
        // Placeholder text
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),

        // Label above the text field
        labelText: widget.labelText,
        labelStyle: textTheme.titleMedium!.copyWith(
          color: colorScheme.primary
        ),
        
        prefixIcon: widget.icon,

        suffixIcon: widget.password ? IconButton(
          onPressed: (){
            setState(() {
              hideText = !hideText;
            });
          }, 
          icon: hideText ? const Icon(Ionicons.eye) : const Icon(Ionicons.eye_off)
        ) : null,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),

        // Filled background
        filled: true,
        fillColor: colorScheme.tertiaryContainer,
      ),

      // Text input control
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLength: 50, 
      obscureText: hideText,
      
    );
  }
}