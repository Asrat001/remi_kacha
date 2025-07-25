import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:remi_kacha/features/exchnage/data/models/exchange_rate_model.dart';

import '../../../core/constant.dart';
import '../../../core/theme/app_theme.dart';



class ExchangeRateDropdown extends StatelessWidget {
  final List<ExchangeRate> items;
  final ExchangeRate? selectedItem;
  final void Function(ExchangeRate?) onChanged;
  final String label;

  const ExchangeRateDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.label = "Select Currency",
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context);
    return DropdownSearch<ExchangeRate>(
      items: (filter, infiniteScrollProps)=> items,
      selectedItem: selectedItem,
      itemAsString: (ExchangeRate item) => item.currencyCode,
      compareFn: (a, b) => a.currencyCode == b.currencyCode,
      onChanged: onChanged,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          fillColor: AppColors.surface,
          filled: true,
          hintStyle: customTheme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade500,
          ),
          labelStyle: customTheme.textTheme.bodySmall,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cBorderRadius),
            borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular( 4),
            borderSide: BorderSide(color: Colors.grey.shade500, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.orange.shade500, width: 0.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),

      // ✅ Dropdown menu config
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        constraints: const BoxConstraints(maxHeight: 300),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Search currency...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
