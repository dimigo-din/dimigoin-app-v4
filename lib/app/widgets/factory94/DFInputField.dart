import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:intl/intl.dart';

enum DFInputType { normal, focus, error }

enum DFInputMode { text, date, time, dateTime }

class DFInput extends StatefulWidget {
  final TextEditingController? controller;
  final DFInputType type;
  final DFInputMode mode;
  final bool status;
  final String? title;
  final String? placeholder;
  final String? content;
  final Widget? leading;
  final Widget? trailing;
  final bool? obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final VoidCallback? onTapLeading;
  final VoidCallback? onTapTrailing;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? dateFormat;
  final String? timeFormat;

  const DFInput({
    super.key,
    this.controller,
    this.type = DFInputType.normal,
    this.mode = DFInputMode.text,
    this.status = false,
    this.title,
    this.placeholder,
    this.content,
    this.leading,
    this.trailing,
    this.obscureText,
    this.onChanged,
    this.onSubmit,
    this.onDateChanged,
    this.onTimeChanged,
    this.onDateTimeChanged,
    this.onTapLeading,
    this.onTapTrailing,
    this.initialDate,
    this.initialTime,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.timeFormat,
  });

  @override
  State<DFInput> createState() => _DFInputState();
}

class _DFInputState extends State<DFInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  // ignore: unused_field
  bool _isFocused = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDateTime;
  bool _hasInitializedDisplay = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.content ?? '');
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      });

    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
    _selectedDateTime = widget.initialDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitializedDisplay) {
      _updateDisplayText();
      _hasInitializedDisplay = true;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _updateDisplayText() {
    String text = '';
    
    switch (widget.mode) {
      case DFInputMode.date:
        if (_selectedDate != null) {
          final format = widget.dateFormat ?? 'yyyy-MM-dd';
          text = DateFormat(format).format(_selectedDate!);
        }
        break;
      case DFInputMode.time:
        if (_selectedTime != null) {
          text = widget.timeFormat != null 
              ? _formatTime(_selectedTime!, widget.timeFormat!)
              : _selectedTime!.format(context);
        }
        break;
      case DFInputMode.dateTime:
        if (_selectedDateTime != null) {
          final dateFormat = widget.dateFormat ?? 'yyyy-MM-dd';
          final timeFormat = widget.timeFormat ?? 'HH:mm';
          text = '${DateFormat(dateFormat).format(_selectedDateTime!)} ${DateFormat(timeFormat).format(_selectedDateTime!)}';
        }
        break;
      case DFInputMode.text:
        return;
    }
    
    if (text.isNotEmpty) {
      _controller.text = text;
    }
  }

  String _formatTime(TimeOfDay time, String format) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat(format).format(dateTime);
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateDisplayText();
      });
      widget.onDateChanged?.call(picked);
    }
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _updateDisplayText();
      });
      widget.onTimeChanged?.call(picked);
    }
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!mounted) return;
      
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        
        setState(() {
          _selectedDateTime = dateTime;
          _updateDisplayText();
        });
        widget.onDateTimeChanged?.call(dateTime);
      }
    }
  }

  void _handleTap() {
    switch (widget.mode) {
      case DFInputMode.date:
        _showDatePicker();
        break;
      case DFInputMode.time:
        _showTimePicker();
        break;
      case DFInputMode.dateTime:
        _showDateTimePicker();
        break;
      case DFInputMode.text:
        _focusNode.requestFocus();
        break;
    }
  }

  Color getBackgroundColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    switch (widget.type) {
      case DFInputType.error:
        return colorTheme.solidTranslucentRed;
      case DFInputType.focus:
        return colorTheme.componentsFillStandardPrimary;
      case DFInputType.normal:
        return colorTheme.componentsFillStandardPrimary;
    }
  }

  Color getBorderColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    switch (widget.type) {
      case DFInputType.error:
        return colorTheme.coreStatusNegative;
      case DFInputType.focus:
        return colorTheme.coreBrandPrimary;
      case DFInputType.normal:
        return colorTheme.lineOutline;
    }
  }

  Color getTextColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    return colorTheme.contentStandardPrimary;
  }

  Color getPlaceholderColor(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    return colorTheme.contentStandardTertiary;
  }

  Widget buildLeading(BuildContext context) {
    final l = widget.leading;

    if (l is Icon) {
      return Icon(l.icon, size: 24, color: getPlaceholderColor(context));
    } else {
      return l ?? const SizedBox();
    }
  }

  Widget buildTrailing(BuildContext context) {
    final l = widget.trailing;

    if (l is Icon) {
      return Icon(l.icon, size: 24, color: getPlaceholderColor(context));
    } else {
      return l ?? const SizedBox();
    }
  }

  Widget _buildDefaultTrailing(BuildContext context) {
    if (widget.trailing != null) {
      return buildTrailing(context);
    }
    
    IconData icon;
    switch (widget.mode) {
      case DFInputMode.date:
        icon = Icons.calendar_today;
        break;
      case DFInputMode.time:
        icon = Icons.access_time;
        break;
      case DFInputMode.dateTime:
        icon = Icons.event;
        break;
      case DFInputMode.text:
        return const SizedBox();
    }
    
    return Icon(icon, size: 24, color: getPlaceholderColor(context));
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;
    // ignore: unused_local_variable
    final hasValue = widget.status || _controller.text.isNotEmpty;
    final isPickerMode = widget.mode != DFInputMode.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: TextStyle(
              color: colorTheme.contentStandardPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: DFSpacing.spacing150),
        ],
        GestureDetector(
          onTap: isPickerMode ? _handleTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: getBackgroundColor(context),
              border: Border.all(
                color: getBorderColor(context),
                width: widget.type == DFInputType.normal ? 1 : 2,
              ),
              borderRadius: BorderRadius.circular(DFRadius.radius400),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: DFSpacing.spacing400,
              vertical: DFSpacing.spacing300,
            ),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: GestureDetector(
                      onTap: widget.onTapLeading ?? () {},
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: buildLeading(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: DFSpacing.spacing200),
                ],
                Expanded(
                  child: isPickerMode
                      ? Text(
                          _controller.text.isEmpty
                              ? (widget.placeholder ?? '')
                              : _controller.text,
                          style: textTheme.body.copyWith(
                            color: _controller.text.isEmpty
                                ? getPlaceholderColor(context)
                                : getTextColor(context),
                            fontWeight: _controller.text.isEmpty
                                ? FontWeight.w400
                                : FontWeight.w500,
                          ),
                        )
                      : TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmit,
                          cursorColor: colorTheme.coreBrandPrimary,
                          obscureText: widget.obscureText ?? false,
                          style: textTheme.body.copyWith(
                            color: getTextColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: widget.placeholder,
                            hintStyle: textTheme.body.copyWith(
                              color: getPlaceholderColor(context),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ),
                if (widget.trailing != null || isPickerMode) ...[
                  const SizedBox(width: DFSpacing.spacing200),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: GestureDetector(
                      onTap: isPickerMode 
                          ? _handleTap 
                          : (widget.onTapTrailing ?? () {}),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: _buildDefaultTrailing(context),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DFInputField extends StatelessWidget {
  final String? title;
  final String? subLabel;
  final List<Widget>? inputs;

  const DFInputField({
    super.key,
    this.title,
    this.subLabel,
    this.inputs,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                bottom: DFSpacing.spacing200,
                left: DFSpacing.spacing100,
                right: DFSpacing.spacing100,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title!,
                  style: textTheme.callout.copyWith(
                    color: colorTheme.contentStandardSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
          if (inputs != null) ...[
            Column(
              children: inputs!,
            ),
          ],
          if (subLabel != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: DFSpacing.spacing200,
                left: DFSpacing.spacing100,
                right: DFSpacing.spacing100,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  subLabel!,
                  style: textTheme.footnote.copyWith(
                    color: colorTheme.contentStandardQuaternary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}