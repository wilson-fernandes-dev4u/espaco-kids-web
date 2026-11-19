import 'package:flutter/material.dart';

import 'logo_mark.dart';

/// Logo do app Espaço Kids (a "Turminha", a mesma do ícone do aplicativo):
/// quadrado arredondado com o gradiente da marca e uma sombra suave.
class KidsLogo extends StatelessWidget {
  const KidsLogo({super.key, this.size = 88});

  final double size;

  @override
  Widget build(BuildContext context) => LogoTile(size: size);
}
