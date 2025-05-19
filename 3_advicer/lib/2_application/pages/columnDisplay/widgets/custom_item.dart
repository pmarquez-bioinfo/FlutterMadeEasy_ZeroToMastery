import 'package:flutter/material.dart';

class CustomItem extends StatefulWidget {
  final String title;
  final bool isChecked;
  const CustomItem({
    super.key,
    required this.title,
    this.isChecked = false,
  });

  @override
  State<CustomItem> createState() => _CustomItemState();
}

class _CustomItemState extends State<CustomItem> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: ListTile(
            title: Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            trailing: Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
            ),
            onTap: () {
              setState(() {
                isChecked = !isChecked;
              });
            },
          )),
    );
  }
}
