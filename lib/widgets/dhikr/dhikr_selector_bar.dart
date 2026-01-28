import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_app/config/theme/custom_theme.dart';
import 'package:ramadan_app/models/dhikr/dhikr_model.dart';
import 'package:ramadan_app/widgets/dhikr/dhikr_list_sheet.dart';

class DhikrSelectorBar extends StatelessWidget {
  final Dhikr activeDhikr;

  const DhikrSelectorBar({super.key, required this.activeDhikr});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => const DhikrListSheet(),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CustomTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: CustomTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeDhikr.title,
                    style: CustomTheme.textTheme(
                      context,
                    ).bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (activeDhikr.arabicTitle != null)
                    Text(
                      activeDhikr.arabicTitle!,
                      style: CustomTheme.textTheme(context).bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontFamily: 'Amiri'
                            .tr(), // Assuming you might have arabic font, else default
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
