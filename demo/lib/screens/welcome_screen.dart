import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'menu_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _glowAnim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _startOrder() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MenuScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startOrder,
      child: Scaffold(
        backgroundColor: AppConstants.bgDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Lumières d'ambiance ─────────────────────────
            AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, __) => Stack(
                children: [
                  // Lueur rouge en haut à droite
                  Positioned(
                    top: -100,
                    right: -100,
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppConstants.primaryRed
                                .withOpacity(_glowAnim.value * 0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Lueur dorée en bas à gauche
                  Positioned(
                    bottom: -80,
                    left: -80,
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppConstants.accentGold
                                .withOpacity(_glowAnim.value * 0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Grille décorative (style KFC) ───────────────
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: 80,
                  itemBuilder: (_, i) => Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppConstants.primaryRed, width: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // ── Contenu principal ────────────────────────────
            Column(
              children: [
                // En-tête
                Padding(
                  padding:
                      const EdgeInsets.only(top: 40, left: 32, right: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryRed,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.primaryRed.withOpacity(0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Text(
                          "S'TACOS",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Titre principal
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        "FINGER",
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: AppConstants.textCream,
                          height: 0.95,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "LICKIN'",
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: AppConstants.primaryRed,
                          height: 0.95,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "GOOD",
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: AppConstants.textCream,
                          height: 0.95,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Commandez comme vous aimez",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.textGrey,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 48),

                // Bouton KFC style
                ScaleTransition(
                  scale: _pulseAnim,
                  child: GestureDetector(
                    onTap: _startOrder,
                    child: Container(
                      width: 300,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryRed,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.primaryRed.withOpacity(0.5),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "COMMANDER",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 3,
                            ),
                          ),
                          SizedBox(width: 14),
                          Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "TOUCHEZ POUR COMMENCER",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textMuted,
                    letterSpacing: 3,
                  ),
                ),

                const Spacer(),

                // Footer paiements
                Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _paymentChip("💵", "Espèces"),
                      const SizedBox(width: 16),
                      _paymentChip("📱", "Wave"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentChip(String icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppConstants.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.textGrey,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
