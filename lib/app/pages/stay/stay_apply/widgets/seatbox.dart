import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

class SeatUtils {
  static List<List<String>> generateTable() {
    List<List<String>> table = [];
    const columns = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];
    
    for (String col in columns) {
      List<String> rowSeats = [];
      for (int row = 1; row <= 18; row++) {
        rowSeats.add('$col$row');
      }
      table.add(rowSeats);
    }
    
    return table;
  }

  static bool isInRange(String range, String seat) {
    final parts = range.split(':');
    if (parts.length != 2) return false;

    final start = parts[0]; // "A1"
    final end = parts[1];   // "N9"

    // 좌석 파싱 (예: "A1" -> column: "A", row: 1)
    final seatMatch = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(seat);
    if (seatMatch == null) return false;
    final seatCol = seatMatch.group(1)!;
    final seatRow = int.parse(seatMatch.group(2)!);

    // 시작 좌석 파싱
    final startMatch = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(start);
    if (startMatch == null) return false;
    final startCol = startMatch.group(1)!;
    final startRow = int.parse(startMatch.group(2)!);

    // 끝 좌석 파싱
    final endMatch = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(end);
    if (endMatch == null) return false;
    final endCol = endMatch.group(1)!;
    final endRow = int.parse(endMatch.group(2)!);

    // 범위 체크
    final colInRange = _isColumnInRange(seatCol, startCol, endCol);
    final rowInRange = seatRow >= startRow && seatRow <= endRow;

    return colInRange && rowInRange;
  }

  static bool _isColumnInRange(String col, String start, String end) {
    final colCode = col.codeUnitAt(0);
    final startCode = start.codeUnitAt(0);
    final endCode = end.codeUnitAt(0);
    
    return colCode >= startCode && colCode <= endCode;
  }
}

class SeatSelectionWidget extends StatefulWidget {
  final Stay currentStay;
  final String? initialSelectedSeat;
  final String currentUserGrade;
  final String currentUserGender;
  final String currentUserId;
  final Function(String) onSeatConfirmed;
  final VoidCallback? onNoSeatSelected;

  const SeatSelectionWidget({
    Key? key,
    required this.currentStay,
    this.initialSelectedSeat,
    required this.currentUserGrade,
    required this.currentUserGender,
    required this.currentUserId,
    required this.onSeatConfirmed,
    this.onNoSeatSelected,
  }) : super(key: key);

  @override
  State<SeatSelectionWidget> createState() => _SeatSelectionWidgetState();
}

class _SeatSelectionWidgetState extends State<SeatSelectionWidget> {
  String? _selectedSeat;

  @override
  void initState() {
    super.initState();
    _selectedSeat = widget.initialSelectedSeat;
  }

  void _onSeatTapped(String seat) {
    setState(() {
      _selectedSeat = seat;
    });
  }

  void _onConfirmPressed() {
    if (_selectedSeat != null) {
      widget.onSeatConfirmed(_selectedSeat!);
    }
  }

  void _onNoSeatPressed() {
    setState(() {
      _selectedSeat = null;
    });
    widget.onNoSeatSelected?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 60),
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.only(bottom: 10),
            minScale: 0.5,
            maxScale: 2.0,
            constrained: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildGroupedRows(context),
            ),
          ),
        ),
        
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DFRadius.radius600),
                topRight: Radius.circular(DFRadius.radius600),
              ),
              color: colorTheme.componentsFillStandardSecondary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                  offset: const Offset(0, -6),
                  spreadRadius: -3,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DFItemList(
                title: _selectedSeat != '' ? _selectedSeat : '미선택',
                subTitle: '내가 선택한 좌석',
                trailing: Row(
                  children: [
                    DFButton(
                      label: "선택하기",
                      theme: DFButtonTheme.accent,
                      onPressed: _selectedSeat != null ? _onConfirmPressed : null,
                    ),
                    const SizedBox(width: 8),
                    DFButton(
                      label: "미선택",
                      theme: DFButtonTheme.accent,
                      style: DFButtonStyle.secondary,
                      onPressed: _onNoSeatPressed,
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isSeatActive(String seat) {
    final myTarget = '${widget.currentUserGrade}_${widget.currentUserGender}';

    final staySeat = widget.currentStay.staySeatPreset?.staySeat;
    if (staySeat == null) return false;

    return staySeat.any((seatPreset) {
      return seatPreset.target == myTarget &&
             SeatUtils.isInRange(seatPreset.range, seat);
    });
  }

  StayApplyItem? _getSeatOwner(String seat) {
    final stayApply = widget.currentStay.stayApply;
    if (stayApply == null) return null;

    try {
      return stayApply.firstWhere(
        (apply) => apply.staySeat == seat,
      );
    } catch (e) {
      return null;
    }
  }

  List<Widget> _buildGroupedRows(BuildContext context) {
    final table = SeatUtils.generateTable();
    List<Widget> groupedWidgets = [];
    
    for (int i = 0; i < table.length; i += 2) {
      List<List<String>> group = table.sublist(
        i,
        i + 2 > table.length ? table.length : i + 2,
      );

      groupedWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: group.map((row) => _buildSeatRow(context, row)).toList(),
          ),
        ),
      );
    }

    return groupedWidgets;
  }

  Widget _buildSeatRow(context, List<String> row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: List.generate(row.length, (index) {
          final seat = row[index];
          final hasExtraMargin = index == 8;

          return Padding(
            padding: EdgeInsets.only(
              left: 3,
              right: hasExtraMargin ? 23 : 3,
              top: 3,
              bottom: 3,
            ),
            child: _buildSeatItem(context, seat),
          );
        }),
      ),
    );
  }

  Widget _buildSeatItem(BuildContext context, String seat) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    final isSelected = _selectedSeat == seat;
    final isActive = _isSeatActive(seat);
    final owner = _getSeatOwner(seat);
    final isTaken = owner != null;
    final isMine = owner?.user.id == widget.currentUserId;
    
    Color backgroundColor;
    Color textColor;

    if (isSelected || isMine) {
      backgroundColor = colorTheme.coreBrandPrimary;
      textColor = colorTheme.solidWhite;
    } else if (isTaken && !isMine) {
      backgroundColor = colorTheme.componentsInteractivePressed;
      textColor = colorTheme.contentStandardPrimary;
    } else if (!isActive) {
      backgroundColor = colorTheme.componentsInteractivePressed;
      textColor = colorTheme.contentStandardPrimary;
    } else {
      backgroundColor = colorTheme.contentStandardSecondary;
      textColor = colorTheme.contentInvertedPrimary;
    }

    final displayText = isTaken
        ? owner.user.name.replaceAll(RegExp(r'[0-9\s]'), '')
        : seat;

    return GestureDetector(
      onTap: isActive && (!isTaken || isMine)
          ? () => _onSeatTapped(seat)
          : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            displayText,
            style: textTheme.callout.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}