import 'package:flutter/material.dart';

class PinKeypad extends StatefulWidget {
  final void Function(String pin) onCompleted;

  const PinKeypad({super.key, required this.onCompleted});

  @override
  State<PinKeypad> createState() => _PinKeypadState();
}

class _PinKeypadState extends State<PinKeypad>
    with SingleTickerProviderStateMixin {
  final List<String> _pin = [];
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _add(String value) {
    if (value == 'backspace') {
      if (_pin.isNotEmpty) {
        setState(() => _pin.removeLast());
      }
      return;
    }

    if (_pin.length >= 4) return;

    setState(() => _pin.add(value));

    if (_pin.length == 4) {
      widget.onCompleted(_pin.join());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _shake,
            builder: (_, child) => Transform.translate(
              offset: Offset(
                _shake.value *
                    12 *
                    (_shake.status == AnimationStatus.forward ? 1 : -1),
                0,
              ),
              child: child,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (i) => Icon(
                  i < _pin.length ? Icons.circle : Icons.circle_outlined,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Keypad(onTap: _add),
        ],
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final void Function(String) onTap;

  const _Keypad({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (_, i) {
          final key = keys[i];

          if (key.isEmpty) {
            return const SizedBox.shrink();
          }

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (key == '⌫') {
                onTap('backspace');
              } else {
                onTap(key);
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: key == '⌫'
                  ? const Icon(Icons.backspace_outlined)
                  : Text(
                      key,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
