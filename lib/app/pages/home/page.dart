import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/static.dart';
import 'controller.dart';

import './widgets/personal_status.dart';
import './widgets/timetable.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: DFSpacing.spacing400),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PersonalStatusWidget(),
              const SizedBox(height: 10),
              TimeTableWidget(),
            ],
          ),
        ),
      ),
    );
  }
}