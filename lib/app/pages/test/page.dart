import 'package:dimigoin_app_v4/app/widgets/factory94/DFAnimatedBottomSheet.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFAvatar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFChip.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFHeader.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFInputField.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSegmentControl.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFSnackBar.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller.dart';

class TestPage extends GetView<TestPageController> {
  const TestPage({super.key});

  Widget linkToRoute(String route) {
    return TextButton(
      onPressed: () {
        Get.toNamed(route);
      },
      child: Text(route),
    );
  }

  Widget linkToRouteWithArgs(
      String route, String title, Map<String, dynamic> args) {
    return TextButton(
      onPressed: () {
        Get.toNamed(route, arguments: args);
      },
      child: Text(title),
    );
  }

  void _showBottomSheet(BuildContext context) {
    DFAnimatedBottomSheet.show(
      context: context,
      children: [
        ListTile(
          leading: Icon(Icons.share),
          title: Text('공유하기'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.link),
          title: Text('링크 복사'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: Icon(Icons.download),
          title: Text('다운로드'),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Routes"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          linkToRoute('/license'),
          linkToRoute('/main'),
          linkToRoute('/login'),
          linkToRoute('/stay'),
          DFChip(label: "label", status: false, onTap: () {}), 
          DFInput(placeholder: "입력해보세요", leading: const Icon(Icons.search), trailing: const Icon(Icons.clear), type: DFInputType.focus,),
          DFAvatar(size: DFAvatarSize.large, type: DFAvatarType.person, fill: DFAvatarFill.icon, image: Image.network("https://i.ytimg.com/vi/qdD7ciXKfzE/hq720.jpg?sqp=-oaymwEXCK4FEIIDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLBacpz-KLCEsW5rw-HKI08xHR3sOQ")),
          DFSegmentControl(
            segments: const [
              DFSegment(label: "첫번째"),
              DFSegment(label: "두번째"),
              DFSegment(label: "세번째"),
            ],
            initialIndex: 0,
            onChanged: (index) {
              print("Selected segment index: $index");
            },
          ),
          ElevatedButton(
            onPressed: () {
              DFSnackBar.open(
                "This is a snack bar message.",
                leading: const Icon(Icons.info),
              );
            },
            child: const Text("Show SnackBar"),
          ),
          ElevatedButton(
            onPressed: () {
              _showBottomSheet(context);
            },
            child: const Text("Show Bottom Sheet"),
          ),
          DFSectionHeader(size: DFSectionHeaderSize.large, title: "오른쪽 세탁기", rightIcon: Icons.arrow_downward, trailingText: "3타임 사용 가능"),
          DFValueList(type: DFValueListType.vertical, title: "아침", subTitle: "7시 10분", content: "아침 세탁기 사용 중"),
          TextButton(
              onPressed: () {
                HapticFeedback.heavyImpact();
              },
              child: const Text("Haptic"),
          ),
        ],
        
      ),
    );
  }
}