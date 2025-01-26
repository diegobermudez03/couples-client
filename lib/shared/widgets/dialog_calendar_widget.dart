import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class DialogCalendarWidget extends StatelessWidget{

  final DateRangePickerController controller;
  final void Function() setState;
  final void Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  final DateTime? minDate;
  final DateTime? maxDate;

  const DialogCalendarWidget({
    super.key,
    required this.controller,
    required this.setState,
    required this.onSelectionChanged,
    this.minDate,
    this.maxDate
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SfDateRangePicker(
        showNavigationArrow: true,
        view: DateRangePickerView.year,
        headerStyle:
            DateRangePickerHeaderStyle(backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        confirmText: l10n.ok,
        cancelText: l10n.cancel,
        minDate: minDate,
        maxDate: maxDate,
        controller: controller,
        onSelectionChanged: onSelectionChanged,
        showActionButtons: true,
        onSubmit: (_) {
          Navigator.of(context).pop();
          setState();
        },
        onCancel: () {
          Navigator.of(context).pop();
          setState();
        },
      ),
    );
  }
}
