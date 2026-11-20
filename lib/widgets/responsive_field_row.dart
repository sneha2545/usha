import 'package:material_ui/material_ui.dart';

/// Lays out sibling form fields side by side on wider screens and stacks them
/// on compact phones.
class ResponsiveFieldRow extends StatelessWidget {
  const ResponsiveFieldRow({
    super.key,
    required this.children,
    this.gap = 14,
    this.breakpoint = 380,
  });

  final List<Widget> children;
  final double gap;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < breakpoint || children.length < 2) {
          return Column(
            children: <Widget>[
              for (int index = 0; index < children.length; index++) ...<Widget>[
                if (index > 0) SizedBox(height: gap),
                children[index],
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int index = 0; index < children.length; index++) ...<Widget>[
              if (index > 0) SizedBox(width: gap),
              Expanded(child: children[index]),
            ],
          ],
        );
      },
    );
  }
}
