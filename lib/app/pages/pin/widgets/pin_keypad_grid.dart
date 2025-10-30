import 'package:dimigoin_app_v4/app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class PinKeypadGrid extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;

  const PinKeypadGrid({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'delete'];

    final colorTheme = Theme.of(context).extension<DFColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          final value = numbers[index];

          if (value == '') {
            return const SizedBox();
          } else if (value == 'delete') {
            return _buildDeleteButton(colorTheme);
          } else {
            return _buildNumberButton(value, colorTheme);
          }
        },
      ),
    );
  }

  Widget _buildNumberButton(String number, DFColors colorTheme) {
    return _PinButton(
      onPressed: () => onNumberPressed(number),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(DFColors colorTheme) {
    return _PinButton(
      onPressed: onDeletePressed,
      child: const Icon(
        Icons.backspace_outlined,
        size: 24,
        color: Colors.grey,
      ),
    );
  }
}

class _PinButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _PinButton({
    required this.onPressed,
    required this.child,
  });

  @override
  State<_PinButton> createState() => _PinButtonState();
}

class _PinButtonState extends State<_PinButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: _isPressed ? 0.4 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
