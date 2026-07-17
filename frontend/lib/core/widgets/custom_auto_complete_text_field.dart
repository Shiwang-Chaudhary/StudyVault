import 'package:flutter/material.dart';
import 'package:study_vault/core/config/app_font_size.dart';

class CustomAutocompleteTextField extends StatefulWidget {
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
  State<CustomAutocompleteTextField> createState() =>
      _CustomAutocompleteTextFieldState();
}

class _CustomAutocompleteTextFieldState
    extends State<CustomAutocompleteTextField> {
  TextEditingController? _internalController;
  bool _listenersAttached = false;

  void _attachSync(TextEditingController textController) {
    if (_listenersAttached || widget.controller == null) return;
    _internalController = textController;

    // Initial sync: external -> internal
    if (textController.text != widget.controller!.text) {
      textController.value = widget.controller!.value;
    }

    // internal -> external (user typing)
    textController.addListener(_onInternalChanged);

    // external -> internal (e.g. controller.clear() from parent)
    widget.controller!.addListener(_onExternalChanged);

    _listenersAttached = true;
  }

  void _onInternalChanged() {
    final internal = _internalController;
    if (internal == null || widget.controller == null) return;
    if (widget.controller!.text != internal.text) {
      widget.controller!.value = internal.value;
    }
  }

  void _onExternalChanged() {
    final internal = _internalController;
    if (internal == null || widget.controller == null) return;
    if (internal.text != widget.controller!.text) {
      internal.value = widget.controller!.value;
    }
  }

  @override
  void dispose() {
    _internalController?.removeListener(_onInternalChanged);
    widget.controller?.removeListener(_onExternalChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return widget.items.where(
          (item) =>
              item.toLowerCase().contains(textEditingValue.text.toLowerCase()),
        );
      },
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        _attachSync(textController);

        return TextField(
          controller: textController,
          focusNode: focusNode,
          style: const TextStyle(fontSize: FontSizes.lg),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
    );
  }
}
