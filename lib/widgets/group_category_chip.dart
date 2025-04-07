import 'package:flutter/material.dart';
import '../models/group.dart';

class GroupCategoryChip extends StatelessWidget {
  final GroupCategory category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFilterChip;
  
  const GroupCategoryChip({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    this.isFilterChip = true, // If true, will show X icon when selected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected && isFilterChip ? 8 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7941FF) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected && isFilterChip) 
              Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            if (isSelected && isFilterChip)
              const SizedBox(width: 4),
            Text(
              category.displayName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupCategoryRow extends StatelessWidget {
  final List<GroupCategory> categories;
  final List<GroupCategory> selectedCategories;
  final Function(GroupCategory) onCategorySelected;
  final bool scrollable;
  final bool showFilterIcon;

  const GroupCategoryRow({
    Key? key,
    required this.categories,
    required this.selectedCategories,
    required this.onCategorySelected,
    this.scrollable = true,
    this.showFilterIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget categoryChips = Row(
      children: [
        if (showFilterIcon)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.filter_list,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ...categories.map((category) {
          final isSelected = selectedCategories.contains(category);
          return GroupCategoryChip(
            category: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category),
          );
        }).toList(),
      ],
    );

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: categoryChips,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategories.contains(category);
            return GroupCategoryChip(
              category: category,
              isSelected: isSelected,
              onTap: () => onCategorySelected(category),
            );
          }).toList(),
        ),
      );
    }
  }
}
