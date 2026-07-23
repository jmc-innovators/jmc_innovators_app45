import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Native recreation of mathslab.html (JMC Maths Lab) — a grid of real,
/// working calculator tools (geometry, number theory, statistics, and a
/// scientific calculator), in the source page's cyan/dark palette.
class MathLabScreen extends StatelessWidget {
  const MathLabScreen({super.key});

  static const _cyan = Color(0xFF00E5FF);

  static const _tools = [
    ('Circle', Icons.circle_outlined),
    ('Square', Icons.crop_square_rounded),
    ('Triangle', Icons.change_history),
    ('Parallelogram', Icons.straighten_rounded),
    ('Cube Volume', Icons.view_in_ar_rounded),
    ('Cuboid Volume', Icons.inventory_2_outlined),
    ('Cylinder', Icons.data_usage_rounded),
    ('Sphere', Icons.public_rounded),
    ('HCF / GCD', Icons.compare_arrows_rounded),
    ('LCM', Icons.timeline_rounded),
    ('Prime Checker', Icons.filter_2_rounded),
    ('Powers', Icons.bolt_rounded),
    ('Square Root', Icons.functions_rounded),
    ('Mean', Icons.bar_chart_rounded),
    ('Standard Deviation', Icons.equalizer_rounded),
    ('Scientific Calculator', Icons.calculate_rounded),
    ('Unit Converter', Icons.swap_horiz_rounded),
    ('Equation Solver (ax+b=c)', Icons.functions_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text('JMC Maths Lab',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Tap a tool to calculate',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _tools.length,
              itemBuilder: (context, i) {
                final (title, icon) = _tools[i];
                return GlassCard(
                  onTap: () => _openTool(context, title),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: _cyan),
                      const Spacer(),
                      Text(title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openTool(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: _ToolSheet(title: title),
      ),
    );
  }
}

class _ToolSheet extends StatefulWidget {
  final String title;
  const _ToolSheet({required this.title});

  @override
  State<_ToolSheet> createState() => _ToolSheetState();
}

class _ToolSheetState extends State<_ToolSheet> {
  static const _cyan = Color(0xFF00E5FF);
  final _controllers = <String, TextEditingController>{};
  String? _result;

  TextEditingController _ctrl(String key) =>
      _controllers.putIfAbsent(key, () => TextEditingController());

  double? _d(String key) => double.tryParse(_ctrl(key).text.trim());

  void _compute() {
    double? r;
    String suffix = '';
    switch (widget.title) {
      case 'Circle':
        final radius = _d('r');
        if (radius != null) {
          setState(() => _result =
              'Area: ${(math.pi * radius * radius).toStringAsFixed(2)}   Circumference: ${(2 * math.pi * radius).toStringAsFixed(2)}');
        }
        return;
      case 'Square':
        final s = _d('side');
        if (s != null) {
          setState(() => _result = 'Area: ${(s * s).toStringAsFixed(2)}   Perimeter: ${(4 * s).toStringAsFixed(2)}');
        }
        return;
      case 'Triangle':
        final b = _d('base'), h = _d('height');
        if (b != null && h != null) r = 0.5 * b * h;
        break;
      case 'Parallelogram':
        final b = _d('base'), h = _d('height');
        if (b != null && h != null) r = b * h;
        break;
      case 'Cube Volume':
        final s = _d('side');
        if (s != null) r = s * s * s;
        break;
      case 'Cuboid Volume':
        final l = _d('l'), w = _d('w'), h = _d('h');
        if (l != null && w != null && h != null) r = l * w * h;
        break;
      case 'Cylinder':
        final radius = _d('r'), h = _d('h');
        if (radius != null && h != null) r = math.pi * radius * radius * h;
        break;
      case 'Sphere':
        final radius = _d('r');
        if (radius != null) r = (4 / 3) * math.pi * math.pow(radius, 3);
        break;
      case 'HCF / GCD':
        final a = _d('a')?.toInt(), b = _d('b')?.toInt();
        if (a != null && b != null) {
          setState(() => _result = 'GCD: ${_gcd(a.abs(), b.abs())}');
        }
        return;
      case 'LCM':
        final a = _d('a')?.toInt(), b = _d('b')?.toInt();
        if (a != null && b != null) {
          final g = _gcd(a.abs(), b.abs());
          setState(() => _result = 'LCM: ${g == 0 ? 0 : (a * b).abs() ~/ g}');
        }
        return;
      case 'Prime Checker':
        final n = _d('n')?.toInt();
        if (n != null) setState(() => _result = '$n is ${_isPrime(n) ? '' : 'not '}a prime number');
        return;
      case 'Powers':
        final base = _d('base'), exp = _d('exp');
        if (base != null && exp != null) r = math.pow(base, exp).toDouble();
        break;
      case 'Square Root':
        final n = _d('n');
        if (n != null && n >= 0) r = math.sqrt(n);
        break;
      case 'Mean':
        final nums = _parseList(_ctrl('list').text);
        if (nums.isNotEmpty) {
          r = nums.reduce((a, b) => a + b) / nums.length;
        }
        break;
      case 'Standard Deviation':
        final nums = _parseList(_ctrl('list').text);
        if (nums.length > 1) {
          final mean = nums.reduce((a, b) => a + b) / nums.length;
          final variance =
              nums.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) / nums.length;
          r = math.sqrt(variance);
        }
        break;
      case 'Unit Converter':
        final km = _d('km');
        if (km != null) {
          setState(() => _result =
              '${km.toStringAsFixed(3)} km = ${(km * 1000).toStringAsFixed(1)} m = ${(km * 0.621371).toStringAsFixed(3)} mi');
        }
        return;
      case 'Equation Solver (ax+b=c)':
        final a = _d('a'), b = _d('b'), c = _d('c');
        if (a != null && a != 0 && b != null && c != null) {
          r = (c - b) / a;
          suffix = ' (x)';
        }
        break;
      case 'Scientific Calculator':
        // Basic +,-,*,/ evaluator for two numbers and an operator.
        final a = _d('a'), b = _d('b');
        final op = _ctrl('op').text.trim();
        if (a != null && b != null) {
          switch (op) {
            case '+': r = a + b; break;
            case '-': r = a - b; break;
            case '*': case 'x': r = a * b; break;
            case '/': r = b == 0 ? null : a / b; break;
            case '^': r = math.pow(a, b).toDouble(); break;
          }
        }
        break;
    }
    setState(() => _result = r == null ? 'Enter valid values' : '${r.toStringAsFixed(4)}$suffix');
  }

  int _gcd(int a, int b) => b == 0 ? a : _gcd(b, a % b);
  bool _isPrime(int n) {
    if (n < 2) return false;
    for (var i = 2; i * i <= n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }
  List<double> _parseList(String s) => s
      .split(RegExp(r'[,\s]+'))
      .where((e) => e.trim().isNotEmpty)
      .map((e) => double.tryParse(e.trim()))
      .whereType<double>()
      .toList();

  List<String> _fieldsFor(String title) {
    switch (title) {
      case 'Circle': return ['r'];
      case 'Square': return ['side'];
      case 'Triangle': return ['base', 'height'];
      case 'Parallelogram': return ['base', 'height'];
      case 'Cube Volume': return ['side'];
      case 'Cuboid Volume': return ['l', 'w', 'h'];
      case 'Cylinder': return ['r', 'h'];
      case 'Sphere': return ['r'];
      case 'HCF / GCD': return ['a', 'b'];
      case 'LCM': return ['a', 'b'];
      case 'Prime Checker': return ['n'];
      case 'Powers': return ['base', 'exp'];
      case 'Square Root': return ['n'];
      case 'Mean': return ['list'];
      case 'Standard Deviation': return ['list'];
      case 'Unit Converter': return ['km'];
      case 'Equation Solver (ax+b=c)': return ['a', 'b', 'c'];
      case 'Scientific Calculator': return ['a', 'op', 'b'];
      default: return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = _fieldsFor(widget.title);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        for (final f in fields)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: _ctrl(f),
              style: const TextStyle(color: Colors.white),
              keyboardType: f == 'op' ? TextInputType.text : const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                hintText: f == 'list'
                    ? 'Numbers separated by commas (e.g. 4, 8, 15, 16)'
                    : f == 'op'
                        ? 'Operator: + - * / ^'
                        : f,
              ),
            ),
          ),
        const SizedBox(height: 4),
        WonderfulLoadingButton(
          label: 'Calculate',
          icon: Icons.calculate_rounded,
          gradient: const LinearGradient(colors: [_cyan, AppColors.blue]),
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 350));
            _compute();
          },
        ),
        if (_result != null) ...[
          const SizedBox(height: 16),
          GlassCard(
            child: Text(_result!,
                style: const TextStyle(color: _cyan, fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}
