import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

/// Native recreation of science.html ("Advanced Periodic Table") — a
/// tappable grid of elements grouped by category color, with a detail
/// sheet for atomic number, symbol, and category.
class ScienceLabScreen extends StatefulWidget {
  const ScienceLabScreen({super.key});

  @override
  State<ScienceLabScreen> createState() => _ScienceLabScreenState();
}

class _Element {
  final int number;
  final String symbol;
  final String name;
  final String category;
  final Color color;
  const _Element(this.number, this.symbol, this.name, this.category, this.color);
}

class _ScienceLabScreenState extends State<ScienceLabScreen> {
  static const _nonmetal = Color(0xFF22C55E);
  static const _nobleGas = Color(0xFFA855F7);
  static const _alkali = Color(0xFFF59E0B);
  static const _alkalineEarth = Color(0xFFEAB308);
  static const _transition = Color(0xFF3B82F6);
  static const _metalloid = Color(0xFF14B8A6);
  static const _halogen = Color(0xFFEF4444);

  static const _elements = [
    _Element(1, 'H', 'Hydrogen', 'Nonmetal', _nonmetal),
    _Element(2, 'He', 'Helium', 'Noble Gas', _nobleGas),
    _Element(3, 'Li', 'Lithium', 'Alkali Metal', _alkali),
    _Element(4, 'Be', 'Beryllium', 'Alkaline Earth', _alkalineEarth),
    _Element(5, 'B', 'Boron', 'Metalloid', _metalloid),
    _Element(6, 'C', 'Carbon', 'Nonmetal', _nonmetal),
    _Element(7, 'N', 'Nitrogen', 'Nonmetal', _nonmetal),
    _Element(8, 'O', 'Oxygen', 'Nonmetal', _nonmetal),
    _Element(9, 'F', 'Fluorine', 'Halogen', _halogen),
    _Element(10, 'Ne', 'Neon', 'Noble Gas', _nobleGas),
    _Element(11, 'Na', 'Sodium', 'Alkali Metal', _alkali),
    _Element(12, 'Mg', 'Magnesium', 'Alkaline Earth', _alkalineEarth),
    _Element(13, 'Al', 'Aluminium', 'Post-Transition', _transition),
    _Element(14, 'Si', 'Silicon', 'Metalloid', _metalloid),
    _Element(15, 'P', 'Phosphorus', 'Nonmetal', _nonmetal),
    _Element(16, 'S', 'Sulfur', 'Nonmetal', _nonmetal),
    _Element(17, 'Cl', 'Chlorine', 'Halogen', _halogen),
    _Element(18, 'Ar', 'Argon', 'Noble Gas', _nobleGas),
    _Element(19, 'K', 'Potassium', 'Alkali Metal', _alkali),
    _Element(20, 'Ca', 'Calcium', 'Alkaline Earth', _alkalineEarth),
    _Element(26, 'Fe', 'Iron', 'Transition Metal', _transition),
    _Element(29, 'Cu', 'Copper', 'Transition Metal', _transition),
    _Element(30, 'Zn', 'Zinc', 'Transition Metal', _transition),
    _Element(47, 'Ag', 'Silver', 'Transition Metal', _transition),
    _Element(79, 'Au', 'Gold', 'Transition Metal', _transition),
  ];

  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _elements
        .where((e) =>
            e.name.toLowerCase().contains(_query.toLowerCase()) ||
            e.symbol.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('Periodic Table',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search element or symbol...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final e = filtered[i];
                return GestureDetector(
                  onTap: () => _showElement(e),
                  child: Container(
                    decoration: BoxDecoration(
                      color: e.color.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: e.color.withOpacity(0.4)),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${e.number}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
                        const Spacer(),
                        Text(e.symbol,
                            style: TextStyle(color: e.color, fontWeight: FontWeight.w800, fontSize: 18)),
                        Text(e.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 9)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showElement(_Element e) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: e.color.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: e.color),
              ),
              alignment: Alignment.center,
              child: Text(e.symbol,
                  style: TextStyle(color: e.color, fontSize: 32, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 16),
            Text(e.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Atomic number ${e.number} · ${e.category}',
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
