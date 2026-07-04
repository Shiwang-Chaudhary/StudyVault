import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_font_size.dart';

class CustomAutocompleteTextField extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final ValueChanged<String>? onSelected;
  final TextEditingController? controller;

  const CustomAutocompleteTextField({
    super.key,
    required this.items,
    required this.hintText,
    this.onSelected,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }

        return items.where(
          (item) =>
              item.toLowerCase().contains(textEditingValue.text.toLowerCase()),
        );
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        if (controller != null && controller != textController) {
          controller!.value = textController.value;

          textController.addListener(() {
            controller!.value = textController.value;
          });
        }

        return TextField(
          controller: textController,
          focusNode: focusNode,
          style: const TextStyle(fontSize: FontSizes.lg),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
    );
  }
}
