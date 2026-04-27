// lib/widgets/shared_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Responsive helpers
// ─────────────────────────────────────────────────────────────────────────────
class R {
  static double w(BuildContext ctx)  => MediaQuery.of(ctx).size.width;
  static double h(BuildContext ctx)  => MediaQuery.of(ctx).size.height;
  static double sp(BuildContext ctx, double base) =>
      base * (w(ctx) / 390); // design base: iPhone 14 width
  static double dp(BuildContext ctx, double base) =>
      base * (h(ctx) / 844); // design base: iPhone 14 height
}

// ─────────────────────────────────────────────────────────────────────────────
// Scene background  –  shows user's drawn PNG or a gradient fallback
// ─────────────────────────────────────────────────────────────────────────────
class SceneBg extends StatelessWidget {
  final String scene;
  final List<Color> fallbackColors;

  const SceneBg({super.key, required this.scene, required this.fallbackColors});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      // Gradient fallback (always shown)
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: fallbackColors,
          ),
        ),
      ),
      // User's drawn background (covers fallback if asset exists)
      Image.asset(
        'assets/images/scenes/bg_$scene.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GuteCat  –  shows the correct skin for scene + state, with float animation
// Speech bubble when critical stat
// ─────────────────────────────────────────────────────────────────────────────
class GuteCat extends StatefulWidget {
  final String scene;
  final double size;
  final bool interactive;

  const GuteCat({
    super.key,
    required this.scene,
    this.size = 0,          // 0 = responsive (40% of screen width)
    this.interactive = true,
  });

  @override
  State<GuteCat> createState() => _GuteCatState();
}

class _GuteCatState extends State<GuteCat> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final cat      = provider.cat;
    final sz       = widget.size > 0 ? widget.size : R.w(context) * 0.42;
    final asset    = cat.catAsset(widget.scene);
    final speech   = cat.alertSpeech;

    return GestureDetector(
      onTap: widget.interactive ? () => provider.playCat() : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speech bubble for critical state
          if (speech.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF6B9D), width: 1.5),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFFF6B9D).withOpacity(0.2), blurRadius: 8),
                ],
              ),
              child: Text(
                speech,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: R.sp(context, 13),
                  color: const Color(0xFFFF6B9D),
                ),
                textAlign: TextAlign.center,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn(duration: 600.ms)
                .then()
                .fadeOut(duration: 600.ms),

          // Cat image (user's drawing)
          SizedBox(
            width: sz,
            height: sz,
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => _PlaceholderCat(size: sz, scene: widget.scene),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -10, duration: 2000.ms, curve: Curves.easeInOut),
        ],
      ),
    );
  }
}

// Fallback drawn cat when asset is missing
class _PlaceholderCat extends StatelessWidget {
  final double size;
  final String scene;
  const _PlaceholderCat({required this.size, required this.scene});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FallbackCatPainter(scene: scene)),
    );
  }
}

class _FallbackCatPainter extends CustomPainter {
  final String scene;
  _FallbackCatPainter({required this.scene});

  @override
  void paint(Canvas canvas, Size sz) {
    final Color body;
    switch (scene) {
      case 'kitchen':   body = const Color(0xFFFFE082); break;
      case 'bedroom':   body = const Color(0xFF9FA8DA); break;
      case 'outdoor':   body = const Color(0xFFA5D6A7); break;
      case 'classroom': body = const Color(0xFFCE93D8); break;
      case 'walk':      body = const Color(0xFFFF8A80); break;
      case 'minigame':  body = const Color(0xFF80CBC4); break;
      default:          body = const Color(0xFFFFB7C5);
    }
    final p = Paint()..color = body..isAntiAlias = true;
    final s = sz.width;

    // body
    canvas.drawOval(Rect.fromCenter(center: Offset(s*.45,s*.72), width: s*.6, height: s*.46), p);
    // head
    canvas.drawCircle(Offset(s*.45,s*.38), s*.28, p);
    // ears
    void ear(double x1,double y1,double x2,double y2,double x3,double y3){
      canvas.drawPath(Path()..moveTo(x1,y1)..lineTo(x2,y2)..lineTo(x3,y3)..close(), p);
    }
    ear(s*.2,s*.2,s*.27,s*.13,s*.35,s*.22);
    ear(s*.55,s*.2,s*.63,s*.13,s*.7,s*.22);
    // eyes
    p.color = const Color(0xFF2E7D32);
    canvas.drawCircle(Offset(s*.35,s*.375),s*.05,p);
    canvas.drawCircle(Offset(s*.55,s*.375),s*.05,p);
    // nose
    p.color = const Color(0xFFFF9BB5);
    canvas.drawOval(Rect.fromCenter(center:Offset(s*.45,s*.45),width:s*.07,height:s*.05),p);
    // cheeks
    p.color = body.withOpacity(0.4);
    canvas.drawCircle(Offset(s*.27,s*.44),s*.06,p);
    canvas.drawCircle(Offset(s*.63,s*.44),s*.06,p);
  }

  @override bool shouldRepaint(_FallbackCatPainter o) => o.scene != scene;
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat bar
// ─────────────────────────────────────────────────────────────────────────────
class StatBar extends StatelessWidget {
  final String label;
  final double value;      // 0–100 (double)
  final Color color;
  final IconData icon;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icon, size: R.sp(context,18), color: color),
        SizedBox(width: R.sp(context,6)),
        SizedBox(
          width: R.sp(context,60),
          child: Text(label,
            style: GoogleFonts.nunito(
              fontSize: R.sp(context,11),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF7B5EA7),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 11,
            ),
          ),
        ),
        SizedBox(width: R.sp(context,6)),
        Text('${value.round()}%',
          style: GoogleFonts.nunito(
            fontSize: R.sp(context,11),
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav icon  –  user's drawn PNG or emoji fallback
// ─────────────────────────────────────────────────────────────────────────────
class NavIcon extends StatelessWidget {
  final String scene;
  final String fallbackEmoji;
  final String label;
  final VoidCallback onTap;

  const NavIcon({
    super.key,
    required this.scene,
    required this.fallbackEmoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sz = R.sp(context, 44);
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: sz, height: sz,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F8),
            borderRadius: BorderRadius.circular(sz * .3),
            border: Border.all(color: const Color(0xFFFFB7C5).withOpacity(0.5)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(sz * .3),
            child: Image.asset(
              'assets/images/icons/icon_$scene.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Center(child: Text(fallbackEmoji, style: TextStyle(fontSize: sz * .48))),
            ),
          ),
        ),
        SizedBox(height: R.sp(context,3)),
        Text(label,
          style: GoogleFonts.nunito(
            fontSize: R.sp(context,9),
            fontWeight: FontWeight.w700,
            color: const Color(0xFFBB8EC0),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Back button (consistent across screens)
// ─────────────────────────────────────────────────────────────────────────────
class GuteBackButton extends StatelessWidget {
  final Color? iconColor;
  final Color? bgColor;
  const GuteBackButton({super.key, this.iconColor, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
          ],
        ),
        child: Icon(Icons.arrow_back_ios_new,
          color: iconColor ?? const Color(0xFF7B5EA7), size: 20),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Coins badge
// ─────────────────────────────────────────────────────────────────────────────
class CoinsBadge extends StatelessWidget {
  const CoinsBadge({super.key});
  @override
  Widget build(BuildContext context) {
    final coins = context.watch<GameProvider>().cat.coins;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD93D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFFFFD93D).withOpacity(0.4), blurRadius: 8, offset: const Offset(0,3))],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Text('🪙', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text('$coins',
          style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 14)),
      ]),
    );
  }
}
