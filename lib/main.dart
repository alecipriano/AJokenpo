import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const JokenpoApp());
}

class JokenpoApp extends StatelessWidget {
  const JokenpoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokenpô Premium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0D14),
        useMaterial3: true,
      ),
      home: const JokenpoScreen(),
    );
  }
}

class JokenpoScreen extends StatefulWidget {
  const JokenpoScreen({super.key});

  @override
  State<JokenpoScreen> createState() => _JokenpoScreenState();
}

class _JokenpoScreenState extends State<JokenpoScreen> {
  // Game states
  String _escolhaApp = "padrao";
  String _resultado = "Escolha uma opção abaixo para começar!";
  int _vitorias = 0;
  int _derrotas = 0;
  int _empates = 0;

  // Track if a round was played to apply special styles
  bool _jogoIniciado = false;
  Color _corResultado = Colors.white70;

  void _jogar(String escolhaUsuario) {
    final opcoes = ["pedra", "papel", "tesoura"];
    final escolhaAleatoria = opcoes[Random().nextInt(3)];

    setState(() {
      _escolhaApp = escolhaAleatoria;
      _jogoIniciado = true;

      // Evaluation logic matching the original exactly
      if ((escolhaAleatoria == "tesoura" && escolhaUsuario == "papel") ||
          (escolhaAleatoria == "papel" && escolhaUsuario == "pedra") ||
          (escolhaAleatoria == "pedra" && escolhaUsuario == "tesoura")) {
        _resultado = "Você Perdeu! :(";
        _corResultado = const Color(0xFFFF5252); // Neon Red
        _derrotas++;
      } else if ((escolhaUsuario == "tesoura" && escolhaAleatoria == "papel") ||
                 (escolhaUsuario == "papel" && escolhaAleatoria == "pedra") ||
                 (escolhaUsuario == "pedra" && escolhaAleatoria == "tesoura")) {
        _resultado = "Você Ganhou! :)";
        _corResultado = const Color(0xFF69F0AE); // Neon Green
        _vitorias++;
      } else {
        _resultado = "Empatou! ;)";
        _corResultado = const Color(0xFFFFD740); // Neon Yellow/Amber
        _empates++;
      }
    });
  }

  void _resetarPlacar() {
    setState(() {
      _vitorias = 0;
      _derrotas = 0;
      _empates = 0;
      _escolhaApp = "padrao";
      _resultado = "Escolha uma opção abaixo para começar!";
      _jogoIniciado = false;
      _corResultado = Colors.white70;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF090C15), Color(0xFF141A29)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // App Title with premium glow
                          const SizedBox(height: 12),
                          const Text(
                            "JOKENPÔ",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8.0,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color(0x803F51B5),
                                  offset: Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "DESAFIE A MÁQUINA",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: Colors.blueAccent.shade100,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Score Board
                          _buildScoreBoard(),

                          const Spacer(),

                          // Robot/App Choice Section
                          _buildAppChoiceView(),

                          const Spacer(),

                          // Status text display
                          _buildResultText(),

                          const SizedBox(height: 24),

                          // User selection title
                          const Text(
                            "SUA ESCOLHA:",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // User buttons
                          _buildPlayerChoices(),

                          const Spacer(),

                          // Reset score button
                          _buildResetButton(),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2336).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreItem("Vitórias", _vitorias, const Color(0xFF69F0AE)),
          Container(
            height: 40,
            width: 1,
            color: Colors.white10,
          ),
          _buildScoreItem("Empates", _empates, const Color(0xFFFFD740)),
          Container(
            height: 40,
            width: 1,
            color: Colors.white10,
          ),
          _buildScoreItem("Derrotas", _derrotas, const Color(0xFFFF5252)),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            "$value",
            key: ValueKey<int>(value),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.4),
                  offset: const Offset(0, 0),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppChoiceView() {
    // Determine the glow/border color based on state
    Color borderColor = Colors.white10;
    if (_jogoIniciado) {
      if (_resultado.contains("Ganhou")) {
        borderColor = const Color(0xFFFF5252).withValues(alpha: 0.4); // Machine lost (Red glow)
      } else if (_resultado.contains("Perdeu")) {
        borderColor = const Color(0xFF69F0AE).withValues(alpha: 0.4); // Machine won (Green glow)
      } else {
        borderColor = const Color(0xFFFFD740).withValues(alpha: 0.4); // Tie (Amber glow)
      }
    }

    return Column(
      children: [
        const Text(
          "ESCOLHA DA MÁQUINA",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF1B2336),
            shape: BoxShape.circle,
            border: Border.all(
              color: _jogoIniciado ? borderColor.withValues(alpha: 1.0) : Colors.white10,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: _jogoIniciado ? borderColor.withValues(alpha: 0.3) : Colors.transparent,
                blurRadius: 20,
                spreadRadius: 2,
              ),
              const BoxShadow(
                color: Colors.black38,
                offset: Offset(0, 10),
                blurRadius: 18,
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Image.asset(
                "assets/images/$_escolhaApp.png",
                key: ValueKey<String>(_escolhaApp),
                width: 86,
                height: 86,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Text(
        _resultado,
        key: ValueKey<String>(_resultado),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _jogoIniciado ? 22 : 15,
          fontWeight: _jogoIniciado ? FontWeight.w900 : FontWeight.normal,
          color: _corResultado,
          letterSpacing: _jogoIniciado ? 0.5 : 0.0,
          shadows: _jogoIniciado
              ? [
                  Shadow(
                    color: _corResultado.withValues(alpha: 0.5),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildPlayerChoices() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildChoiceButton("pedra", "assets/images/pedra.png"),
        const SizedBox(width: 16),
        _buildChoiceButton("papel", "assets/images/papel.png"),
        const SizedBox(width: 16),
        _buildChoiceButton("tesoura", "assets/images/tesoura.png"),
      ],
    );
  }

  Widget _buildChoiceButton(String opcao, String imagePath) {
    return OptionButton(
      opcao: opcao,
      imagePath: imagePath,
      onTap: () => _jogar(opcao),
    );
  }

  Widget _buildResetButton() {
    return OutlinedButton.icon(
      onPressed: _resetarPlacar,
      icon: const Icon(Icons.refresh, size: 18, color: Colors.white54),
      label: const Text(
        "REINICIAR PLACAR",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
          letterSpacing: 1.5,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: const Color(0xFF1B2336).withValues(alpha: 0.2),
      ),
    );
  }
}

class OptionButton extends StatefulWidget {
  final String opcao;
  final String imagePath;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.opcao,
    required this.imagePath,
    required this.onTap,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 80,
          height: 80,
          transform: Matrix4.diagonal3Values(
            _isPressed ? 0.9 : (_isHovered ? 1.08 : 1.0),
            _isPressed ? 0.9 : (_isHovered ? 1.08 : 1.0),
            1.0,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2336),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered ? Colors.blueAccent.shade200 : Colors.white12,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? Colors.blueAccent.shade400.withValues(alpha: 0.4)
                    : Colors.black26,
                blurRadius: _isHovered ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
