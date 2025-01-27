import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Code extends StatelessWidget{
  final String code;

  Code({
    super.key,
    required this.code
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: code.characters.map((char)=>_createNumber(context, char)).toList(),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _copyToClipboard(code, context),
          style: ButtonStyle(
              padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
              minimumSize: WidgetStatePropertyAll(Size(0, 0)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)))),
          icon: Icon(Icons.copy),
          label: Text(
            AppLocalizations.of(context)!.tapToCopy,
            style: Theme.of(context).textTheme.labelSmall,
          )
        ),
      ],
    );
  }

  void _copyToClipboard(String code, BuildContext context){
    Clipboard.setData(ClipboardData(text: code)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.copiedToClipboard,
          )
          )
        );
    });
  }

  Widget _createNumber(BuildContext context,String char){
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.primary
      ),
      child: Center(
        child: Text(
          char,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}