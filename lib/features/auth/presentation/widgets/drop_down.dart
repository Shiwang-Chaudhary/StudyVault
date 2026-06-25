import 'package:flutter/material.dart';
import 'package:study_vault/core/widgets/app_drop_down.dart';

class DropDown extends StatelessWidget {
  // final String header;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const DropDown({
    super.key,
    required this.hintText,
    required this.items,
    required this.onChanged,
    // required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomText(
        //   text: header,
        //   size: FontSizes.lg,
        //   weight: FontWeight.w400,
        //   color: AppColors.textTertiary,
        // ),
        AppDropdown(
          hint: hintText,
          items: items,
          onChanged: onChanged,
          value: null,
        ),
      ],
    );
  }
}
