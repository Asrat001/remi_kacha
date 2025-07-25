
import 'package:flutter/material.dart';
import 'package:remi_kacha/core/constant.dart';

class CustomPinLockScreen extends StatefulWidget {
  final int pinLength;
  final String correctPin;
  final void Function(String pin) onPinMatched;
  final void Function(String pin)? onPinChanged;
  final Color filledDotColor;
  final Color emptyDotColor;
  final Color errorDotColor;
  final BoxShape dotShape;

  const CustomPinLockScreen({
    super.key,
    required this.pinLength,
    required this.correctPin,
    required this.onPinMatched,
    this.onPinChanged,
    required this.filledDotColor,
    required this.emptyDotColor,
    required this.errorDotColor,
    required this.dotShape,
  });



  @override
  State<CustomPinLockScreen> createState() => _CustomPinLockScreenState();
}

class _CustomPinLockScreenState extends State<CustomPinLockScreen> {
  String _input = '';
  bool _error = false;

  void _onKeyTap(String value) {
    if (_input.length < widget.pinLength) {
      setState(() {
        _input += value;
        _error = false;
      });
      widget.onPinChanged?.call(_input);
      if (_input.length == widget.pinLength) {
        if (hash(_input) == widget.correctPin) {
          widget.onPinMatched(_input);
        } else {
          setState(() => _error = true);
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() => _input = '');
          });
        }
      }
    }
  }

  void _onBackspace() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
        _error = false;
      });
      widget.onPinChanged?.call(_input);
    }
  }

  @override
  Widget build(BuildContext context) {
    // PIN dots
    final dots = List.generate(widget.pinLength, (i) {
      final filled = i < _input.length;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: widget.dotShape,
          color:
              _error
                  ? widget.errorDotColor
                  : filled
                  ? widget.filledDotColor
                  : widget.emptyDotColor,
        ),
      );
    });

    // Numpad
    final keys = [...List.generate(9, (i) => '${i + 1}'), '', '0', '<'];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: dots),
          SizedBox(height: 32),
          if (_error)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('Incorrect PIN', style: TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, i) {
                final key = keys[i];
                if (key == '') return const SizedBox.shrink();
                if (key == '<') {
                  return SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      icon: const Icon(Icons.backspace, size: 18),
                      onPressed: _onBackspace,
                      padding: EdgeInsets.zero,
                    ),
                  );
                }
                return ElevatedButton(
                  onPressed: () => _onKeyTap(key),
                  style: Theme.of(
                    context,
                  ).elevatedButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    elevation: WidgetStateProperty.all(0),
                    fixedSize: WidgetStateProperty.all(const Size(20, 20)),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  child: Text(
                    key,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(fontSize: 18,color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
