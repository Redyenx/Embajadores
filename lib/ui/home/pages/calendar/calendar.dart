import 'package:embajadores/ui/config/colors.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CustomColors _colors = CustomColors();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _colors.contextColor(context),
      child: const Center(child: Icon(Icons.calendar_today)),
    );
  }
}
