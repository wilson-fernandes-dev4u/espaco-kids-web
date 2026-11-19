import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Carregamento da marca (Lottie `assets/lottie/logo_loader.json`): as bolas
/// acendem uma de cada vez (esquerda, centro, direita e o ponto verde).
/// `light` é para dentro de botões coloridos (bolas brancas).
class LogoLoader extends StatelessWidget {
  const LogoLoader({super.key, this.size = 96, this.light = false});

  final double size;
  final bool light;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Carregando',
    child: Lottie.asset(
      light
          ? 'assets/lottie/logo_loader_light.json'
          : 'assets/lottie/logo_loader.json',
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: true,
    ),
  );
}
