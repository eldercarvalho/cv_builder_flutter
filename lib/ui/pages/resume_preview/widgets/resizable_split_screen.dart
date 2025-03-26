import 'package:flutter/material.dart';

class ResizableSplitScreen extends StatefulWidget {
  const ResizableSplitScreen({super.key});

  @override
  ResizableSplitScreenState createState() => ResizableSplitScreenState();
}

class ResizableSplitScreenState extends State<ResizableSplitScreen> {
  double bottomHeight = 0.0; // Começa escondido
  double minHeight = 0.0;
  double draggableMinHeight = 200.0;
  double maxHeight = 400.0; // Altura máxima do painel inferior
  bool isExpanded = false;

  void togglePanel() {
    setState(() {
      isExpanded = !isExpanded;
      bottomHeight = isExpanded ? 200.0 : 0.0; // Alterna entre escondido e 200px
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Painel superior (ocupa o espaço restante)
          Expanded(
            child: Container(
              color: Colors.blueAccent,
              child: const Center(
                child: Text(
                  "Painel Superior",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),

          // Barra de arraste entre os painéis
          if (bottomHeight != 0.0)
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  bottomHeight -= details.primaryDelta!;
                  bottomHeight = bottomHeight.clamp(draggableMinHeight, maxHeight);
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                child: Container(
                  height: 10,
                  color: Colors.black,
                ),
              ),
            ),

          // Painel inferior animado
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: bottomHeight,
            color: Colors.green,
            child: const Center(
              child: Text(
                "Painel Inferior",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),

      // Botão para mostrar/ocultar o painel inferior
      floatingActionButton: FloatingActionButton(
        onPressed: togglePanel,
        child: Icon(isExpanded ? Icons.arrow_downward : Icons.arrow_upward),
      ),
    );
  }
}
