import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class FilterChipRow extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const FilterChipRow({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => onSelected(filter),
              selectedColor: AppColors.accentBlue.withValues(alpha: 0.2),
              backgroundColor: AppColors.bgSecondary,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.accentBlue : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.accentBlue : AppColors.divider,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
