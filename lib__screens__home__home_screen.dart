import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceGlass,
                    child: Icon(Icons.person, color: AppColors.cyan),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Good Morning,',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        Text('Student',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.white)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search resources, videos, notes...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  fillColor: AppColors.surfaceGlass,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _heroBanner()),
          _sectionTitle('Continue Learning'),
          _horizontalCards(['Algebra Basics', 'Cell Biology', 'World History'],
              [Icons.functions, Icons.biotech, Icons.public]),
          _sectionTitle('Popular Subjects'),
          _sliverGrid(const [
            ('Mathematics', Icons.calculate_rounded),
            ('Science', Icons.science_rounded),
            ('English', Icons.menu_book_rounded),
            ('ICT', Icons.computer_rounded),
          ]),
          _sectionTitle('Latest Updates'),
          _updatesList(),
          _sectionTitle('Learning Progress'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('This week', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.62,
                        minHeight: 10,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation(AppColors.cyan),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('62% of weekly goal', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _heroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.aurora,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('AI Suggestion',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 12)),
            SizedBox(height: 6),
            Text('Practice Grade 10 Science\nexam papers today',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  Widget _horizontalCards(List<String> titles, List<IconData> icons) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: titles.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) => SizedBox(
            width: 160,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icons[i], color: AppColors.cyan),
                  const Spacer(),
                  Text(titles[i],
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sliverGrid(List<(String, IconData)> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GlassCard(
            child: Row(
              children: [
                Icon(items[i].$2, color: AppColors.purple),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(items[i].$1,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _updatesList() {
    final updates = [
      ('New exam papers uploaded', 'Grade 11 · Combined Maths'),
      ('AI Tutor updated', 'Faster responses, new subjects'),
      ('Live class scheduled', 'JMC Classroom · Tomorrow 4PM'),
    ];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: GlassCard(
            child: Row(
              children: [
                const Icon(Icons.campaign_rounded, color: AppColors.cyan),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(updates[i].$1,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      Text(updates[i].$2,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        childCount: updates.length,
      ),
    );
  }
}
