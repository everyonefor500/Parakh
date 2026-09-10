import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FieldRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;

  const FieldRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: value != null
                ? Text(
                    value!,
                    style: AppTextStyles.titleMedium,
                  )
                : Text(
                    'Not detected',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary, fontStyle: FontStyle.italic),
                  ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}
