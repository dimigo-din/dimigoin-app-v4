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
  static const double _seatWidth = 50;
  static const double _seatHeight = 44;
  static const double _mainGroupGapX = 50;
  static const double _groupGapY = 42;
  static const double _secondarySectionGapY = 72;
  static const double _secondaryGroupGapY = 58;
  static const double _uSeatGapX = 50;

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
    final items = <Widget>[];
    final rightX = _mainBlockWidth + _mainGroupGapX;
    final mainRowPairs = _mainRowPairs;
    final secondaryRowPairs = _secondaryRowPairs;
    final extraRowPairs = _extraRowPairs;

    for (var index = 0; index < mainRowPairs.length; index++) {
      final pair = mainRowPairs[index];
      final y = _mainGroupY(index);
      final leftSeatCount = _leftSeatCount(pair);

      if (leftSeatCount > 0) {
        items.add(
          Positioned(
            left: 0,
            top: y,
            child: _buildSeatTable(context, pair, 1, leftSeatCount),
          ),
        );
      }

      if (_hasRightMainBlock(pair)) {
        items.add(
          Positioned(
            left: rightX,
            top: y,
            child: _buildSeatTable(context, pair, 10, _rightSeatCount(pair)),
          ),
        );
      }
    }

    final secondaryTop = _secondaryTop;

    for (var index = 0; index < secondaryRowPairs.length; index++) {
      final pair = secondaryRowPairs[index];
      items.add(
        Positioned(
          left: rightX,
          top: secondaryTop + index * (_seatHeight * 2 + _secondaryGroupGapY),
          child: _buildSeatTable(context, pair, 1, _leftSeatCount(pair)),
        ),
      );
    }

    if (_hasConfiguredColumn('U')) {
      items.add(
        Positioned(left: rightX, top: _uTop, child: _buildUSeatRow(context)),
      );
    }

    for (var index = 0; index < extraRowPairs.length; index++) {
      final pair = extraRowPairs[index];
      items.add(
        Positioned(
          left: 0,
          top: _extraTop + index * (_seatHeight * 2 + _groupGapY),
          child: _buildSeatTable(context, pair, 1, _leftSeatCount(pair)),
        ),
      );
    }

    return Stack(clipBehavior: Clip.none, children: items);
  }

  double _seatLayoutWidth() {
    final width = _mainBlockWidth + _mainGroupGapX + _rightBlockWidth;
    final extraWidth = _extraRowPairs.fold<double>(0, (maxWidth, pair) {
      final width = _seatWidth * _leftSeatCount(pair);
      return width > maxWidth ? width : maxWidth;
    });

    final maxWidth = width > extraWidth ? width : extraWidth;
    return maxWidth <= 0 ? 1 : maxWidth;
  }

  double _seatLayoutHeight() {
    final mainBottom = _mainBottom;
    final secondaryBottom = _secondaryRowPairs.isEmpty
        ? mainBottom
        : _secondaryTop +
              _secondaryRowPairs.length * (_seatHeight * 2) +
              (_secondaryRowPairs.length - 1) * _secondaryGroupGapY;
    final uBottom = _hasConfiguredColumn('U')
        ? _uTop + _seatHeight
        : secondaryBottom;
    final extraBottom = _extraRowPairs.isEmpty
        ? uBottom
        : _extraTop +
              _extraRowPairs.length * (_seatHeight * 2) +
              (_extraRowPairs.length - 1) * _groupGapY;

    return extraBottom <= 0 ? 1 : extraBottom;
  }

  static const List<List<String>> _defaultMainRowPairs = [
    ['A', 'B'],
    ['C', 'D'],
    ['E', 'F'],
    ['G', 'H'],
    ['I', 'J'],
    ['K', 'L'],
    ['M', 'N'],
  ];

  static const List<List<String>> _defaultSecondaryRowPairs = [
    ['O', 'P'],
    ['Q', 'R'],
    ['S', 'T'],
  ];

  static const Set<String> _knownSeatColumns = {
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
  };

  List<List<String>> get _mainRowPairs =>
      _configuredPairs(_defaultMainRowPairs);

  List<List<String>> get _secondaryRowPairs =>
      _configuredPairs(_defaultSecondaryRowPairs);

  List<List<String>> get _extraRowPairs {
    final names = _configuredColumnNames
        .where((name) => !_knownSeatColumns.contains(name))
        .toList();

    return _chunkPairs(names);
  }

  double get _mainBlockWidth => _seatWidth * 9;

  double get _rightBlockWidth {
    final widths = <double>[
      for (final pair in _mainRowPairs) _seatWidth * _rightSeatCount(pair),
      for (final pair in _secondaryRowPairs) _seatWidth * _leftSeatCount(pair),
      if (_hasConfiguredColumn('U')) _uSeatRowWidth,
    ];

    return widths.fold<double>(0, (maxWidth, width) {
      return width > maxWidth ? width : maxWidth;
    });
  }

  double get _mainBottom {
    if (_mainRowPairs.isEmpty) {
      return 0;
    }

    return _mainGroupY(_mainRowPairs.length - 1) + _seatHeight * 2;
  }

  double get _secondaryTop {
    if (_secondaryRowPairs.isEmpty && !_hasConfiguredColumn('U')) {
      return _mainBottom;
    }

    return _mainBottom + _secondarySectionGapY;
  }

  double get _uTop {
    if (_secondaryRowPairs.isEmpty) {
      return _secondaryTop;
    }

    return _secondaryTop +
        _secondaryRowPairs.length * (_seatHeight * 2) +
        (_secondaryRowPairs.length - 1) * _secondaryGroupGapY +
        _secondaryGroupGapY;
  }

  double get _extraTop {
    final uBottom = _hasConfiguredColumn('U') ? _uTop + _seatHeight : _uTop;
    return uBottom + (_extraRowPairs.isEmpty ? 0 : _secondaryGroupGapY);
  }

  double get _uSeatRowWidth {
    final seatCount = _configuredMaxRow('U');
    if (seatCount <= 0) {
      return 0;
    }

    return seatCount * _seatWidth + (seatCount - 1) * _uSeatGapX;
  }

  double _mainGroupY(int index) => index * (_seatHeight * 2 + _groupGapY);

  bool _hasRightMainBlock(List<String> pair) {
    return _rightSeatCount(pair) > 0;
  }

  int _leftSeatCount(List<String> pair) {
    final maxRows = pair.map(_configuredMaxRow).fold<int>(0, (a, b) {
      return a > b ? a : b;
    });

    return maxRows >= 9 ? 9 : maxRows;
  }

  int _rightSeatCount(List<String> pair) {
    final maxRows = pair.map(_configuredMaxRow).fold<int>(0, (a, b) {
      return a > b ? a : b;
    });

    return maxRows > 9 ? maxRows - 9 : 0;
  }

  int _configuredMaxRow(String columnName) {
    for (final column in [
      ...widget.seatLayout.leftColumns,
      ...widget.seatLayout.rightColumns,
    ]) {
      if (column.name == columnName) {
        return column.maxRow;
      }
    }

    return 0;
  }

  bool _hasConfiguredColumn(String columnName) {
    return _configuredMaxRow(columnName) > 0;
  }

  List<String> get _configuredColumnNames {
    final names = {
      for (final column in [
        ...widget.seatLayout.leftColumns,
        ...widget.seatLayout.rightColumns,
      ])
        if (column.maxRow > 0) column.name,
    }.toList();

    names.sort(_compareSeatColumns);
    return names;
  }

  List<List<String>> _configuredPairs(List<List<String>> defaults) {
    return defaults
        .map((pair) => pair.where(_hasConfiguredColumn).toList())
        .where((pair) => pair.isNotEmpty)
        .toList();
  }

  List<List<String>> _chunkPairs(List<String> names) {
    final pairs = <List<String>>[];

    for (var index = 0; index < names.length; index += 2) {
      pairs.add(
        names.sublist(
          index,
          index + 2 > names.length ? names.length : index + 2,
        ),
      );
    }

    return pairs;
  }

  int _compareSeatColumns(String a, String b) {
    return _columnIndex(a).compareTo(_columnIndex(b));
  }

  int _columnIndex(String column) {
    var value = 0;
    for (final codeUnit in column.codeUnits) {
      value = value * 26 + codeUnit - 'A'.codeUnitAt(0) + 1;
    }
    return value;
  }

  Widget _buildSeatTable(
    BuildContext context,
    List<String> rows,
    int startNumber,
    int count,
  ) {
    return Column(
      children: rows.map((rowName) {
        final maxRow = _configuredMaxRow(rowName);
        final effectiveCount = maxRow < startNumber
            ? 0
            : count.clamp(0, maxRow - startNumber + 1);
        final seats = List.generate(
          effectiveCount,
          (index) => '$rowName${startNumber + index}',
        );

        return Row(
          children: seats.map((seat) => _buildSeatItem(context, seat)).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildUSeatRow(BuildContext context) {
    final seatCount = _configuredMaxRow('U');

    return Row(
      children: List.generate(seatCount, (index) {
        return Padding(
          padding: EdgeInsets.only(
            right: index == seatCount - 1 ? 0 : _uSeatGapX,
          ),
          child: _buildSeatItem(context, 'U${index + 1}'),
        );
      }),
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

    final seatColumn = RegExp(r'^([A-Z]+)').firstMatch(seat)?.group(1) ?? '';
    final isSecondarySeat = _columnIndex(seatColumn) >= _columnIndex('O');

    if (isSelected || isMine) {
      backgroundColor = colorTheme.coreBrandPrimary;
      textColor = colorTheme.solidWhite;
    } else if (isTaken && !isMine) {
      backgroundColor = colorTheme.componentsInteractivePressed;
      textColor = colorTheme.contentStandardPrimary;
    } else if (!isActive) {
      backgroundColor = colorTheme.componentsFillStandardPrimary;
      textColor = colorTheme.contentStandardPrimary;
    } else if (isSecondarySeat) {
      backgroundColor = const Color(0xFFCDEFFF);
      textColor = Colors.black;
    } else {
      backgroundColor = colorTheme.solidWhite;
      textColor = Colors.black;
    }

    final displayText = isTaken
        ? owner.user.name.replaceAll(RegExp(r'[0-9\s]'), '')
        : seat;

    return GestureDetector(
      onTap: isActive && (!isTaken || isMine)
          ? () => _onSeatTapped(seat)
          : null,
      child: Container(
        width: _seatWidth,
        height: _seatHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: colorTheme.lineOutline, width: 0.8),
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
