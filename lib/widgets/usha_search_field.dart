import 'package:material_ui/material_ui.dart';

import '../core/constants/app_colors.dart';

/// Rounded search input with a live clear action.
class UshaSearchField extends StatefulWidget {
  const UshaSearchField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<UshaSearchField> createState() => _UshaSearchFieldState();
}

class _UshaSearchFieldState extends State<UshaSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(covariant UshaSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChange);
      widget.controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.controller.text.isNotEmpty;

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14.5),
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 21,
          color: AppColors.textSecondary,
        ),
        suffixIcon: hasText
            ? IconButton(
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged?.call('');
                },
                tooltip: 'Clear search',
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
      ),
    );
  }
}
