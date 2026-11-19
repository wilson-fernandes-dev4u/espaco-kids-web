import 'package:flutter/material.dart';

/// [Card] com um detalhe decorativo (círculos suaves) nos cantos superior
/// direito e inferior esquerdo, usado nos cards do app para dar identidade visual sem depender
/// de imagens.
class PatternCard extends StatelessWidget {
  const PatternCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
    this.stacked = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;

  /// Cor de fundo do cartão (o padrão é a do tema).
  final Color? color;

  /// Bolas sobrepostas no canto inferior direito (cartões de número). O padrão
  /// são as bolas nos cantos superior direito e inferior esquerdo.
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return Card(
      color: color,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CirclesPainter(
                  primary: scheme.primary,
                  secondary: scheme.secondary,
                  opacity: isDark ? 0.10 : 0.12,
                  stacked: stacked,
                ),
              ),
            ),
          ),
          // Força o filho a usar toda a largura do card (sem isso o `Stack`
          // o encolhe e some a área clicável fora do texto).
          SizedBox(width: double.infinity, child: child),
        ],
      ),
    );
  }
}

class _CirclesPainter extends CustomPainter {
  const _CirclesPainter({
    required this.primary,
    required this.secondary,
    required this.opacity,
    this.stacked = false,
  });

  final Color primary;
  final Color secondary;
  final double opacity;
  final bool stacked;

  @override
  void paint(Canvas canvas, Size size) {
    if (stacked) {
      canvas.drawCircle(
        Offset(size.width - 8, size.height - 4),
        44,
        Paint()..color = primary.withValues(alpha: opacity),
      );
      canvas.drawCircle(
        Offset(size.width - 62, size.height + 6),
        28,
        Paint()..color = secondary.withValues(alpha: opacity),
      );
      return;
    }
    // Mesma disposição dos cards do Reportask, com bolas: uma grande saindo
    // pelo canto superior direito e uma menor pelo canto inferior esquerdo.
    canvas.drawCircle(
      Offset(size.width - 24, 16),
      56,
      Paint()..color = primary.withValues(alpha: opacity),
    );
    canvas.drawCircle(
      Offset(16, size.height),
      40,
      Paint()..color = secondary.withValues(alpha: opacity * 0.7),
    );
  }

  @override
  bool shouldRepaint(_CirclesPainter old) =>
      old.primary != primary ||
      old.secondary != secondary ||
      old.opacity != opacity ||
      old.stacked != stacked;
}
