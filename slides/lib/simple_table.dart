import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class SimpleTable extends StatelessWidget {
  const SimpleTable({required this.data, super.key});

  final List<List<String>> data;

  @override
  Widget build(BuildContext context) {
    // table using grid or wrap
    final textStyle = FlutterDeckTheme.of(context).textTheme.bodyMedium;
    var header = textStyle.copyWith(
      color: Colors.black,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
    var item = textStyle.copyWith(
      color: Colors.black,
      fontSize: 24,
    );
    final rows = data.length;
    final cols = data[0].length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        for (var row = 0; row < rows; row++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var col = 0; col < cols; col++)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data[row][col],
                    style: row == 0 ? header : item,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
