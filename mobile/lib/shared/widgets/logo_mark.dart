import 'package:flutter/material.dart';

/// Marca do Espaço Kids, "Turminha": uma bola grande e duas menores se
/// abraçando, com um ponto verde no topo. Versão clara, para usar direto sobre
/// o gradiente da marca, sem fundo próprio.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 96});

  final double size;

  static const _done = Color(0xFF3EE0A9);

  @override
  Widget build(BuildContext context) {
    // Desenhado numa grade de 120; `k` ajusta para o tamanho pedido.
    final k = size / 120;

    Widget ball(double cx, double cy, double r, Color color, double alpha) =>
        Positioned(
          left: (cx - r) * k,
          top: (cy - r) * k,
          child: Container(
            width: 2 * r * k,
            height: 2 * r * k,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: alpha),
            ),
          ),
        );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ball(30, 74, 19, Colors.white, 0.55),
          ball(90, 74, 19, Colors.white, 0.55),
          ball(60, 68, 27, Colors.white, 0.95),
          ball(60, 26, 9, _done, 1),
        ],
      ),
    );
  }
}

/// A marca num quadrado arredondado com o gradiente da marca (como o ícone do
/// app), para telas de fundo comum.
class LogoTile extends StatelessWidget {
  const LogoTile({super.key, this.size = 88, this.shadow = true});

  final double size;
  final bool shadow;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size * 0.225),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7B4DFF), Color(0xFF3D7BFF)],
      ),
      boxShadow: shadow
          ? [
              BoxShadow(
                color: const Color(0xFF7B4DFF).withValues(alpha: 0.3),
                blurRadius: size * 0.2,
                offset: Offset(0, size * 0.08),
              ),
            ]
          : null,
    ),
    // A marca ocupa de y=17 a y=95 da grade; sobe 4% para ficar no centro.
    child: Transform.translate(
      offset: Offset(0, -size * 0.04),
      child: LogoMark(size: size * 0.66),
    ),
  );
}
