import 'package:dimigoin_app_v4/app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:dimigoin_app_v4/app/core/theme/static.dart';
import 'package:intl/intl.dart';

enum DFInputType { normal, focus, error }

enum DFInputMode { text, date, time, dateTime }

class DFInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final DFInputType type;
  final DFInputMode mode;
  final bool status;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final String? title;
  final String? placeholder;
  final String? content;
  final Widget? leading;
  final Widget? trailing;
  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final VoidCallback? onTap;
  final VoidCallback? onTapLeading;
  final VoidCallback? onTapTrailing;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final DateTime? initialDateTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? dateFormat;
  final String? timeFormat;

  const DFInput({
    super.key,
    this.controller,
    this.focusNode,
    this.type = DFInputType.normal,
    this.mode = DFInputMode.text,
    this.status = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.title,
    this.placeholder,
    this.content,
    this.leading,
    this.trailing,
    this.obscureText,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmit,
    this.onDateChanged,
    this.onTimeChanged,
    this.onDateTimeChanged,
    this.onTap,
    this.onTapLeading,
    this.onTapTrailing,
    this.initialDate,
    this.initialTime,
    this.initialDateTime,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.timeFormat,
  }) : assert(minLines == null || minLines > 0),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || maxLines == null || minLines <= maxLines),
       assert(obscureText != true || (maxLines == 1 && (minLines ?? 1) == 1));

  @override
  State<DFInput> createState() => _DFInputState();
}

class _DFInputState extends State<DFInput> {
  static const _duration = Duration(milliseconds: 180);
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isPicking = false;
  bool _hasInitializedDisplay = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDateTime;

  bool get _isPicker => widget.mode != DFInputMode.text;
  bool get _isMultiline => widget.maxLines != 1;
  DFInputType get _effectiveType {
    if (widget.type == DFInputType.error) return DFInputType.error;
    if (widget.enabled &&
        (widget.type == DFInputType.focus ||
            _focusNode.hasFocus ||
            _isPicking)) {
      return DFInputType.focus;
    }
    return DFInputType.normal;
  }

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.content);
    _controller.addListener(_onTextChanged);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
    _selectedDateTime = widget.initialDateTime ?? widget.initialDate;
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  void _onTextChanged() {
    // TextField observes its controller itself; picker labels need a rebuild.
    if (mounted && _isPicker) setState(() {});
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
  void didUpdateWidget(covariant DFInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      final value = _controller.value;
      _controller.removeListener(_onTextChanged);
      if (oldWidget.controller == null) _controller.dispose();
      _controller = widget.controller ?? TextEditingController.fromValue(value);
      _controller.addListener(_onTextChanged);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChanged);
    }
    if (widget.controller == null && widget.content != oldWidget.content) {
      _setText(widget.content ?? '');
    }
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
    }
    if (widget.initialTime != oldWidget.initialTime) {
      _selectedTime = widget.initialTime;
    }
    if (widget.initialDateTime != oldWidget.initialDateTime ||
        widget.initialDate != oldWidget.initialDate) {
      _selectedDateTime = widget.initialDateTime ?? widget.initialDate;
    }
    if (widget.mode != oldWidget.mode ||
        widget.initialDate != oldWidget.initialDate ||
        widget.initialTime != oldWidget.initialTime ||
        widget.initialDateTime != oldWidget.initialDateTime ||
        widget.dateFormat != oldWidget.dateFormat ||
        widget.timeFormat != oldWidget.timeFormat) {
      _updateDisplayText();
    }
    if (!widget.enabled && _focusNode.hasFocus) _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _setText(String text) {
    if (_controller.text == text) return;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String _formatTime(TimeOfDay time) {
    if (widget.timeFormat == null) return time.format(context);
    final now = DateTime.now();
    return DateFormat(
      widget.timeFormat,
    ).format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  }

  void _updateDisplayText() {
    switch (widget.mode) {
      case DFInputMode.text:
        return;
      case DFInputMode.date:
        if (_selectedDate != null) {
          _setText(
            DateFormat(
              widget.dateFormat ?? 'yyyy-MM-dd',
            ).format(_selectedDate!),
          );
        }
      case DFInputMode.time:
        if (_selectedTime != null) _setText(_formatTime(_selectedTime!));
      case DFInputMode.dateTime:
        if (_selectedDateTime != null) {
          final date = DateFormat(
            widget.dateFormat ?? 'yyyy-MM-dd',
          ).format(_selectedDateTime!);
          final time = DateFormat(
            widget.timeFormat ?? 'HH:mm',
          ).format(_selectedDateTime!);
          _setText('$date $time');
        }
    }
  }

  Future<DateTime?> _pickDate(DateTime? selected) {
    final first = DateUtils.dateOnly(widget.firstDate ?? DateTime(1900));
    final last = DateUtils.dateOnly(widget.lastDate ?? DateTime(2100));
    var initial = DateUtils.dateOnly(selected ?? DateTime.now());
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
  }

  Future<void> _handleTap() async {
    if (!widget.enabled || _isPicking) return;
    final mode = widget.mode;
    widget.onTap?.call();
    if (!_isPicker) {
      _focusNode.requestFocus();
      return;
    }
    if (widget.readOnly) return;
    _focusNode.requestFocus();
    setState(() => _isPicking = true);
    try {
      switch (widget.mode) {
        case DFInputMode.text:
          break;
        case DFInputMode.date:
          final picked = await _pickDate(_selectedDate);
          if (!mounted ||
              !widget.enabled ||
              widget.readOnly ||
              picked == null) {
            return;
          }
          _selectedDate = picked;
          _updateDisplayText();
          widget.onDateChanged?.call(picked);
        case DFInputMode.time:
          final picked = await showTimePicker(
            context: context,
            initialTime: _selectedTime ?? TimeOfDay.now(),
          );
          if (!mounted ||
              !widget.enabled ||
              widget.readOnly ||
              picked == null) {
            return;
          }
          _selectedTime = picked;
          _updateDisplayText();
          widget.onTimeChanged?.call(picked);
        case DFInputMode.dateTime:
          final date = await _pickDate(_selectedDateTime);
          if (!mounted ||
              !widget.enabled ||
              widget.readOnly ||
              widget.mode != mode ||
              date == null) {
            return;
          }
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
              _selectedDateTime ?? DateTime.now(),
            ),
          );
          if (!mounted ||
              !widget.enabled ||
              widget.readOnly ||
              widget.mode != mode ||
              time == null) {
            return;
          }
          final picked = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          _selectedDateTime = picked;
          _updateDisplayText();
          widget.onDateTimeChanged?.call(picked);
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Widget _accessory(Widget child, VoidCallback? onTap, DFColors colors) {
    final visual = child is Icon
        ? Icon(child.icon, size: 24, color: colors.contentStandardTertiary)
        : child;
    return SizedBox.square(
      dimension: 24,
      child: onTap == null
          ? FittedBox(fit: BoxFit.contain, child: visual)
          : IconButton(
              onPressed: widget.enabled ? onTap : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 24,
              icon: FittedBox(fit: BoxFit.contain, child: visual),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<DFColors>()!;
    final typography = Theme.of(context).extension<DFTypography>()!;
    final type = _effectiveType;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _duration;
    final textStyle = typography.body.copyWith(
      color: colors.contentStandardPrimary,
      fontWeight: FontWeight.w500,
    );
    final hintStyle = typography.body.copyWith(
      color: colors.contentStandardTertiary,
      fontWeight: FontWeight.w400,
    );
    final trailing =
        widget.trailing ??
        (_isPicker
            ? Icon(switch (widget.mode) {
                DFInputMode.date => Icons.calendar_today,
                DFInputMode.time => Icons.access_time,
                _ => Icons.event,
              })
            : null);

    Widget input = _isPicker
        ? Semantics(
            button: true,
            enabled: widget.enabled && !widget.readOnly,
            label: widget.title,
            child: FocusableActionDetector(
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              mouseCursor: widget.enabled && !widget.readOnly
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
              },
              actions: {
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) {
                    _handleTap();
                    return null;
                  },
                ),
              },
              child: Text(
                _controller.text.isEmpty
                    ? (widget.placeholder ?? '')
                    : _controller.text,
                maxLines: widget.maxLines,
                overflow: widget.maxLines == null
                    ? null
                    : TextOverflow.ellipsis,
                style: _controller.text.isEmpty ? hintStyle : textStyle,
              ),
            ),
          )
        : TextField(
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            keyboardType:
                widget.keyboardType ??
                (_isMultiline ? TextInputType.multiline : null),
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmit,
            onTap: widget.onTap,
            onTapAlwaysCalled: widget.readOnly,
            cursorColor: type == DFInputType.error
                ? colors.coreStatusNegative
                : colors.coreBrandPrimary,
            obscureText: widget.obscureText ?? false,
            style: textStyle,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: widget.placeholder,
              hintStyle: hintStyle,
            ),
          );

    input = AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: type == DFInputType.error
            ? colors.solidTranslucentRed
            : colors.componentsFillStandardPrimary,
        borderRadius: BorderRadius.circular(DFRadius.radius400),
      ),
      // Paint the border over the fixed padding so focus does not move text.
      foregroundDecoration: BoxDecoration(
        border: Border.all(
          color: switch (type) {
            DFInputType.normal => colors.lineOutline,
            DFInputType.focus => colors.coreBrandPrimary,
            DFInputType.error => colors.coreStatusNegative,
          },
          width: type == DFInputType.normal ? 1 : 2,
        ),
        borderRadius: BorderRadius.circular(DFRadius.radius400),
      ),
      child: AnimatedSize(
        duration: duration,
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DFSpacing.spacing400,
            vertical: DFSpacing.spacing300,
          ),
          child: Row(
            crossAxisAlignment: _isMultiline
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (widget.leading != null) ...[
                _accessory(widget.leading!, widget.onTapLeading, colors),
                const SizedBox(width: DFSpacing.spacing200),
              ],
              Expanded(child: input),
              if (trailing != null) ...[
                const SizedBox(width: DFSpacing.spacing200),
                _accessory(
                  trailing,
                  _isPicker ? _handleTap : widget.onTapTrailing,
                  colors,
                ),
              ],
            ],
          ),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: typography.callout.copyWith(
              color: colors.contentStandardSecondary,
            ),
          ),
          const SizedBox(height: DFSpacing.spacing200),
        ],
        AnimatedOpacity(
          duration: duration,
          curve: Curves.easeOutCubic,
          opacity: widget.enabled ? 1 : 0.3,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled ? _handleTap : null,
            child: input,
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

  const DFInputField({super.key, this.title, this.subLabel, this.inputs});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).extension<DFColors>()!;
    final textTheme = Theme.of(context).extension<DFTypography>()!;

    return Column(
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
        if (inputs != null) ...[Column(children: inputs!)],
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
          ),
        ],
      ],
    );
  }
}
