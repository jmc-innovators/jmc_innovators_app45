import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _LoadingStep {
  final String label;
  final int percent;
  const _LoadingStep(this.label, this.percent);
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  int _stepIndex = 0;

  static const List<_LoadingStep> _steps = [
    _LoadingStep('Initializing AI Engine...', 10),
    _LoadingStep('Loading Learning Resources...', 25),
    _LoadingStep('Connecting Firebase...', 40),
    _LoadingStep('Loading User Profile...', 55),
    _LoadingStep('Preparing Smart Classroom...', 68),
    _LoadingStep('Loading AI Tutor...', 80),
    _LoadingStep('Synchronizing Database...', 90),
    _LoadingStep('Optimizing Performance...', 97),
    _LoadingStep('Ready to Learn!', 100),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _runSequence();
  }

  Future<void> _runSequence() async {
    for (var i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 380));
      if (!mounted) return;
      setState(() => _stepIndex = i);
    }
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) widget.onFinished();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_stepIndex];
    final progress = step.percent / 100;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Aurora glow background
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    AppColors.purple.withOpacity(0.25),
                    AppColors.blue.withOpacity(0.12),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final glow = 0.5 + (_pulseController.value * 0.5);
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.aurora,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withOpacity(glow * 0.6),
                          blurRadius: 40,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 48),
                  );
                },
              ),
              const SizedBox(height: 28),
              ShaderMask(
                shaderCallback: (bounds) => AppColors.aurora.createShader(bounds),
                child: const Text(
                  'JMC Innovators',
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              const Text('Learning Platform',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 8),
              const Text('Empowering the Future Through Smart Learning',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 48),
              SizedBox(
                width: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('${step.label}  ${step.percent}%',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
