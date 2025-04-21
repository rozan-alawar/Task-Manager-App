import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  FilterButton(
      {super.key,
      required this.title,
      required this.currentFilter,
      required this.filter});
  String title;
  String currentFilter;
  String filter;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.currentFilter == widget.filter;

    return InkWell(
      onTap: () {
        setState(() {
          widget.currentFilter = widget.filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
