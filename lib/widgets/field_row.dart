import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A premium field row with subtle bottom divider, muted label, and italic
/// "Not detected" fallback.
class FieldRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;
  final bool isLast;

  const FieldRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Value
              Expanded(
                flex: 3,
                child: value != null
                    ? Text(
                        value!,
                        style: AppTextStyles.titleMedium,
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.remove_circle_outline,
                            size: 14,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Not detected',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.dividerSubtle,
          ),
      ],
    );
  }
}
