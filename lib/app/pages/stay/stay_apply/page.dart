import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:dimigoin_app_v4/app/services/auth/service.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';
import './widgets/seatbox.dart';
import './widgets/stay_schedule_selector.dart';
import './widgets/seat_selection_card.dart';
import './widgets/stay_selection_bottom_sheet.dart';

class StayApplyPage extends GetView<StayPageController> {
  StayApplyPage({super.key});

  final AuthService authService = Get.find<AuthService>();

  void _showSeatBottomSheet(BuildContext context) {
    DFAnimatedBottomSheet.show(
      context: context,
      height: MediaQuery.of(context).size.height * 0.9,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SeatSelectionWidget(
            currentStay: controller.stayList[controller.selectedStayIndex.value],
            initialSelectedSeat: controller.selectedSeat.value,
            currentUserGrade: authService.user!.userGrade.toString(),
            currentUserGender: authService.user!.gender.toString(),
            currentUserId: authService.user!.id.toString(),
            isApplied: controller.isApplied.value,
            onSeatConfirmed: (seat) {
              controller.selectedSeat.value = seat;
              Navigator.pop(context);
            },
            onNoSeatSelected: () {
              controller.selectedSeat.value = '';
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: DFSpacing.spacing500),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // 잔류 일정 선택 헤더
                  Obx(() => StayScheduleSelector(
                    title: controller.stayList.isEmpty
                        ? "잔류 일정 없음"
                        : controller.stayList[controller.selectedStayIndex.value].name,
                    onTap: () => StaySelectionBottomSheet.show(
                      context: context,
                      stayList: controller.stayList,
                      selectedStayIndex: controller.selectedStayIndex.value,
                      onStaySelected: controller.selectStay,
                    ),
                  )),
                  const SizedBox(height: DFSpacing.spacing600),

                  // 좌석 선택 카드
                  Obx(() {
                    if (controller.stayList.isEmpty) {
                      return const SizedBox();
                    }

                    return SeatSelectionCard(
                      selectedSeat: controller.selectedSeat.value,
                      onTap: () => _showSeatBottomSheet(context),
                    );
                  }),
                  const SizedBox(height: DFSpacing.spacing600),

                  // 좌석 미선택 사유 입력
                  Obx(() {
                    final showReason = controller.selectedSeat.value == '';
                    return Visibility(
                      visible: showReason,
                      maintainState: true,
                      child: DFInputField(
                        title: "좌석 미선택 사유",
                        inputs: [
                          Row(
                            children: [
                              Expanded(
                                child: DFInput(
                                  controller: controller.noSeatReason,
                                  placeholder: "좌석 미선택 사유를 입력하세요",
                                  type: DFInputType.normal,
                                ),
                              ),
                              const SizedBox(width: DFSpacing.spacing200),
                              DFButton(
                                label: "교실잔류",
                                theme: DFButtonTheme.grayscale,
                                style: DFButtonStyle.secondary,
                                onPressed: () {
                                  controller.noSeatReason.text = "교실잔류";
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // 신청/취소 버튼
            Obx(() {
              if (controller.stayList.isEmpty) {
                return const SizedBox();
              }
              
              return SizedBox(
                width: double.infinity,
                child: controller.isApplied.value == false
                  ? DFButton(
                    onPressed: () => controller.addStayApplication(),
                    label: "잔류 신청",
                    size: DFButtonSize.large,
                    theme: DFButtonTheme.accent,
                    style: DFButtonStyle.primary,
                  )
                  : DFButton(
                    onPressed: () => controller.deleteStayApplication(),
                    label: "잔류 신청 취소",
                    size: DFButtonSize.large,
                    theme: DFButtonTheme.accent,
                    style: DFButtonStyle.secondary,
                  ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
