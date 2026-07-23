import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;
  const LoginScreen({super.key, required this.onAuthenticated});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _auth = AuthService();
  late final TabController _tabController;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String? _verificationId;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _runWithLoading(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
      widget.onAuthenticated();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              ShaderMask(
                shaderCallback: (b) => AppColors.aurora.createShader(b),
                child: const Text('Welcome back',
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
              const Text('Sign in to continue learning',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),

              // Google sign-in — shared "wonderful loading" button: shimmers
              // and shows a spinner while the sign-in flow is in progress.
              WonderfulLoadingButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                onPressed: () => _runWithLoading(() async {
                  await _auth.signInWithGoogle();
                }),
              ),
              const SizedBox(height: 20),
              Row(children: const [
                Expanded(child: Divider(color: Colors.white24)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: TextStyle(color: AppColors.textSecondary)),
                ),
                Expanded(child: Divider(color: Colors.white24)),
              ]),
              const SizedBox(height: 16),

              TabBar(
                controller: _tabController,
                labelColor: AppColors.cyan,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.cyan,
                tabs: const [Tab(text: 'Email'), Tab(text: 'Phone')],
              ),
              SizedBox(
                height: 260,
                child: TabBarView(
                  controller: _tabController,
                  children: [_emailForm(), _phoneForm()],
                ),
              ),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_error!,
                      style: const TextStyle(color: AppColors.danger, fontSize: 12)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          TextField(
            controller: _emailCtrl,
            decoration: const InputDecoration(hintText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passCtrl,
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _runWithLoading(
                  () => _auth.sendPasswordReset(_emailCtrl.text.trim())),
              child: const Text('Forgot password?'),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => _runWithLoading(() => _auth.signInWithEmail(
                      _emailCtrl.text.trim(), _passCtrl.text)),
              child: _loading
                  ? const SizedBox(
                      height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Sign In'),
            ),
          ),
          TextButton(
            onPressed: _loading
                ? null
                : () => _runWithLoading(() => _auth.registerWithEmail(
                    _emailCtrl.text.trim(), _passCtrl.text)),
            child: const Text('Create an account'),
          ),
        ],
      ),
    );
  }

  Widget _phoneForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          TextField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(hintText: '+94 7X XXX XXXX'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _loading
                  ? null
                  : () => _auth.startPhoneVerification(
                        phoneNumber: _phoneCtrl.text.trim(),
                        onCodeSent: (id) => setState(() => _verificationId = id),
                        onError: (e) => setState(() => _error = e.message),
                      ),
              child: const Text('Send Code'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _otpCtrl,
            decoration: const InputDecoration(hintText: '6-digit code'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _verificationId == null || _loading
                  ? null
                  : () => _runWithLoading(
                      () => _auth.verifyOtp(_verificationId!, _otpCtrl.text.trim())),
              child: const Text('Verify & Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}
