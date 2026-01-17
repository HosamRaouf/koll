import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kol/components/blank_screen.dart';
import 'package:kol/components/my_scroll_configurations.dart';
import 'package:kol/core/models/day_model.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/working_hours/day_widget.dart';

import '../../logic.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  @override
  Widget build(BuildContext context) {
    return BlankScreen(
        title: 'مواعيد العمل',
        child: MyScrollConfigurations(
          horizontal: false,
          child: SingleChildScrollView(
            child: Column(
                children: List.generate(
                    days.length,
                    (index) {

                      DayModel day = DayModel(day: days[index], openAt: '', closeAt: '');

                      for (var element in restaurantData.workingDays) {
                        days[index] == element.day ? day = element : DayModel(day: days[index], openAt: '', closeAt: '');
                      }

                      return DayWidget(day: day);
                    })),
          ),
        ));
  }
}
