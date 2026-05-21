import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:dimigoin_app_v4/app/services/stay/model.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFButton.dart';
import 'package:dimigoin_app_v4/app/widgets/factory94/DFList.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';

class SeatUtils {
  static List<String> generateColumn(StaySeatLayoutColumn column) {
    return List.generate(
      column.maxRow,
      (index) => '${column.name}${index + 1}',
    );
  }

  static bool isInRange(String range, String seat) {
    final parts = range.split(':');
    if (parts.length != 2) return false;

    final start = parts[0]; // "A1"
    final end = parts[1]; // "N9"

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
    final colCode = _columnIndex(col);
    final startCode = _columnIndex(start);
    final endCode = _columnIndex(end);

    return colCode >= startCode && colCode <= endCode;
  }

  static int _columnIndex(String column) {
    var value = 0;
    for (final codeUnit in column.codeUnits) {
      value = value * 26 + codeUnit - 'A'.codeUnitAt(0) + 1;
    }
    return value;
  }
}

class SeatSelectionWidget extends StatefulWidget {
  final Stay currentStay;
  final StaySeatLayout seatLayout;
  final String? initialSelectedSeat;
  final String currentUserGrade;
  final String currentUserGender;
  final String currentUserId;
  final bool isApplied;
  final Function(String) onSeatConfirmed;
  final VoidCallback? onNoSeatSelected;

  const SeatSelectionWidget({
    super.key,
    required this.currentStay,
    required this.seatLayout,
    this.initialSelectedSeat,
    required this.currentUserGrade,
    required this.currentUserGender,
    required this.currentUserId,
    required this.isApplied,
    required this.onSeatConfirmed,
    this.onNoSeatSelected,
  });

  @override
  State<SeatSelectionWidget> createState() => _SeatSelectionWidgetState();
}

class _SeatSelectionWidgetState extends State<SeatSelectionWidget> {
  static const int _mainSeatSplitRow = 9;
  static const double _seatStride = 56;
  static const double _rowHeight = 60;
  static const double _mainGroupGapX = 28;
  static const double _groupGapY = 16;
  static const double _bottomTopGap = 40;
  static const double _bottomGroupGapY = 28;

  String? _selectedSeat;

  @override
  void initState() {
    super.initState();
    _selectedSeat = widget.initialSelectedSeat;
  }

  void _onSeatTapped(String seat) {
    if (widget.isApplied) return;

    setState(() {
      _selectedSeat = seat;
    });
  }

  void _onConfirmPressed() {
    if (widget.isApplied) return;

    if (_selectedSeat != null && _selectedSeat!.isNotEmpty) {
      widget.onSeatConfirmed(_selectedSeat!);
    }
  }

  void _onNoSeatPressed() {
    if (widget.isApplied) return;

    setState(() {
      _selectedSeat = null;
    });
    widget.onNoSeatSelected?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final seatLayout = _buildSeatLayout(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 60),
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.only(bottom: 10),
            minScale: 0.5,
            maxScale: 2.0,
            constrained: false,
            child: SizedBox(
              width: _seatLayoutWidth(),
              height: _seatLayoutHeight(),
              child: seatLayout,
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
                title: (_selectedSeat == null || _selectedSeat == '')
                    ? '미선택'
                    : _selectedSeat!,
                subTitle: '내가 선택한 좌석',
                trailing: Row(
                  children: [
                    if (widget.isApplied == false) ...[
                      DFButton(
                        label: "미선택",
                        theme: DFButtonTheme.accent,
                        style: DFButtonStyle.secondary,
                        onPressed: _onNoSeatPressed,
                      ),
                      const SizedBox(width: 8),
                      DFButton(
                        label: "선택하기",
                        theme: DFButtonTheme.accent,
                        onPressed:
                            _selectedSeat != null && _selectedSeat!.isNotEmpty
                            ? _onConfirmPressed
                            : null,
                      ),
                    ],
                  ],
                ),
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
      return stayApply.firstWhere((apply) => apply.staySeat == seat);
    } catch (e) {
      return null;
    }
  }

  Widget _buildSeatLayout(BuildContext context) {
    final mainColumns = _mainColumns();
    final bottomColumns = _bottomColumns();
    final mainGroups = _buildColumnGroups(mainColumns);
    final bottomGroups = _buildColumnGroups(bottomColumns);

    if (mainGroups.isEmpty && bottomGroups.isEmpty) {
      return const SizedBox(width: 1, height: 1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mainGroups.isNotEmpty) _buildMainSeatLayout(context, mainGroups),
        if (mainGroups.isNotEmpty && bottomGroups.isNotEmpty)
          const SizedBox(height: _bottomTopGap),
        if (bottomGroups.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mainGroups.isNotEmpty) SizedBox(width: _bottomLeftOffset()),
              _buildBottomSeatLayout(context, bottomGroups),
            ],
          ),
      ],
    );
  }

  double _seatLayoutWidth() {
    final mainWidth = _mainLayoutWidth();
    final bottomWidth = _bottomColumns().isEmpty
        ? 0.0
        : _bottomLeftOffset() + _bottomBlockWidth();
    final width = mainWidth > bottomWidth ? mainWidth : bottomWidth;

    return width <= 0 ? 1 : width;
  }

  double _seatLayoutHeight() {
    final mainGroups = _buildColumnGroups(_mainColumns());
    final bottomGroups = _buildColumnGroups(_bottomColumns());
    var height = _groupsHeight(mainGroups, _groupGapY);

    if (bottomGroups.isNotEmpty) {
      if (height > 0) {
        height += _bottomTopGap;
      }
      height += _groupsHeight(bottomGroups, _bottomGroupGapY);
    }

    return height <= 0 ? 1 : height;
  }

  List<StaySeatLayoutColumn> _allColumns() {
    return [
      ...widget.seatLayout.leftColumns,
      ...widget.seatLayout.rightColumns,
    ];
  }

  List<StaySeatLayoutColumn> _mainColumns() {
    return _allColumns()
        .where((column) => !_isBottomColumn(column.name))
        .toList();
  }

  List<StaySeatLayoutColumn> _bottomColumns() {
    return _allColumns()
        .where((column) => _isBottomColumn(column.name))
        .toList();
  }

  bool _isBottomColumn(String columnName) {
    final columnIndex = SeatUtils._columnIndex(columnName);
    return columnIndex >= SeatUtils._columnIndex('O') &&
        columnIndex <= SeatUtils._columnIndex('U');
  }

  double _mainLayoutWidth() {
    final leftWidth = _mainLeftBlockWidth();
    final rightWidth = _mainRightBlockWidth();
    final gap = leftWidth > 0 && rightWidth > 0 ? _mainGroupGapX : 0.0;
    return leftWidth + gap + rightWidth;
  }

  double _mainLeftBlockWidth() {
    final maxRows = _mainColumns().fold<int>(0, (maxRows, column) {
      final rows = column.maxRow > _mainSeatSplitRow
          ? _mainSeatSplitRow
          : column.maxRow;
      return rows > maxRows ? rows : maxRows;
    });
    return maxRows * _seatStride;
  }

  double _mainRightBlockWidth() {
    final maxRows = _mainColumns().fold<int>(0, (maxRows, column) {
      final rows = column.maxRow > _mainSeatSplitRow
          ? column.maxRow - _mainSeatSplitRow
          : 0;
      return rows > maxRows ? rows : maxRows;
    });
    return maxRows * _seatStride;
  }

  double _bottomLeftOffset() {
    final leftWidth = _mainLeftBlockWidth();
    final rightWidth = _mainRightBlockWidth();
    return leftWidth > 0 && rightWidth > 0 ? leftWidth + _mainGroupGapX : 0.0;
  }

  double _bottomBlockWidth() {
    final bottomWidth = _maxRows(_bottomColumns()) * _seatStride;
    final mainRightWidth = _mainRightBlockWidth();
    return bottomWidth > mainRightWidth ? bottomWidth : mainRightWidth;
  }

  double _groupsHeight(
    List<List<StaySeatLayoutColumn>> groups,
    double groupGapY,
  ) {
    var height = 0.0;
    for (var index = 0; index < groups.length; index++) {
      height += groups[index].length * _rowHeight;
      if (index != groups.length - 1) {
        height += groupGapY;
      }
    }
    return height;
  }

  int _maxRows(List<StaySeatLayoutColumn> columns) {
    var maxRows = 0;
    for (final column in columns) {
      if (column.maxRow > maxRows) {
        maxRows = column.maxRow;
      }
    }
    return maxRows;
  }

  List<List<StaySeatLayoutColumn>> _buildColumnGroups(
    List<StaySeatLayoutColumn> columns,
  ) {
    final groups = <List<StaySeatLayoutColumn>>[];

    for (int i = 0; i < columns.length; i += 2) {
      groups.add(
        columns.sublist(i, i + 2 > columns.length ? columns.length : i + 2),
      );
    }

    return groups;
  }

  Widget _buildMainSeatLayout(
    BuildContext context,
    List<List<StaySeatLayoutColumn>> groups,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(groups.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == groups.length - 1 ? 0 : _groupGapY,
          ),
          child: _buildMainColumnGroup(context, groups[index]),
        );
      }),
    );
  }

  Widget _buildMainColumnGroup(
    BuildContext context,
    List<StaySeatLayoutColumn> group,
  ) {
    final hasRightBlock = group.any(
      (column) => column.maxRow > _mainSeatSplitRow,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildColumnGroupRange(context, group, 1, _mainSeatSplitRow),
        if (hasRightBlock) ...[
          const SizedBox(width: _mainGroupGapX),
          _buildColumnGroupRange(context, group, _mainSeatSplitRow + 1),
        ],
      ],
    );
  }

  Widget _buildBottomSeatLayout(
    BuildContext context,
    List<List<StaySeatLayoutColumn>> groups,
  ) {
    return SizedBox(
      width: _bottomBlockWidth(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(groups.length, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == groups.length - 1 ? 0 : _bottomGroupGapY,
            ),
            child: groups[index].length == 1
                ? _buildSpacedSeatRow(
                    context,
                    SeatUtils.generateColumn(groups[index].first),
                  )
                : _buildColumnGroupRange(context, groups[index], 1),
          );
        }),
      ),
    );
  }

  Widget _buildColumnGroupRange(
    BuildContext context,
    List<StaySeatLayoutColumn> group,
    int startRow, [
    int? endRow,
  ]) {
    return Column(
      children: group.map((column) {
        final seats = _generateColumnRange(column, startRow, endRow);
        if (seats.isEmpty) {
          return const SizedBox(height: _rowHeight);
        }
        return _buildSeatRow(context, seats);
      }).toList(),
    );
  }

  List<String> _generateColumnRange(
    StaySeatLayoutColumn column,
    int startRow, [
    int? endRow,
  ]) {
    final lastRow = endRow == null || endRow > column.maxRow
        ? column.maxRow
        : endRow;
    if (startRow > lastRow) {
      return [];
    }

    return List.generate(
      lastRow - startRow + 1,
      (index) => '${column.name}${startRow + index}',
    );
  }

  Widget _buildSeatRow(BuildContext context, List<String> row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: List.generate(row.length, (index) {
          final seat = row[index];
          return Padding(
            padding: const EdgeInsets.only(
              left: 3,
              right: 3,
              top: 3,
              bottom: 3,
            ),
            child: _buildSeatItem(context, seat),
          );
        }),
      ),
    );
  }

  Widget _buildSpacedSeatRow(BuildContext context, List<String> row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SizedBox(
        width: _bottomBlockWidth(),
        height: _rowHeight - 4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: row.map((seat) => _buildSeatItem(context, seat)).toList(),
        ),
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
