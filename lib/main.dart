import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Add this package to evaluate expressions

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ''; // Stores the input expression
  String result = ''; // Stores the result

  // Function to handle button presses
  void onButtonPressed(String value) {
    setState(() {
      // Prevent multiple operators in sequence
      if (['+', '-', '*', '/'].contains(value) &&
          input.isNotEmpty &&
          ['+', '-', '*', '/'].contains(input[input.length - 1])) {
        return;
      }
      input += value;
    });
  }

  // Function to calculate the result
  void calculateResult() {
    try {
      // Parse and evaluate the expression using the MathExpressions package
      Parser parser = Parser();
      Expression expression =
          parser.parse(input.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel contextModel = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, contextModel);

      setState(() {
        result = eval.toString(); // Store the result
      });
    } catch (e) {
      setState(() {
        result = "0"; // Show error if calculation fails
      });
    }
  }

  // Function to clear the input
  void clearInput() {
    setState(() {
      input = '';
      result = '';
    });
  }

  // Function to build buttons
  Widget buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button background color
        padding: const EdgeInsets.all(16.0), // Button size
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white), // White text color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Simple Calculator',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            // Display Box
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Calculator Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 4, // 4 buttons per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.all(16.0),
                children: [
                  buildButton('1', () => onButtonPressed('1')),
                  buildButton('2', () => onButtonPressed('2')),
                  buildButton('3', () => onButtonPressed('3')),
                  buildButton('+', () => onButtonPressed('+')),
                  buildButton('4', () => onButtonPressed('4')),
                  buildButton('5', () => onButtonPressed('5')),
                  buildButton('6', () => onButtonPressed('6')),
                  buildButton('-', () => onButtonPressed('-')),
                  buildButton('7', () => onButtonPressed('7')),
                  buildButton('8', () => onButtonPressed('8')),
                  buildButton('9', () => onButtonPressed('9')),
                  buildButton('*', () => onButtonPressed('*')),
                  buildButton('C', clearInput),
                  buildButton('0', () => onButtonPressed('0')),
                  buildButton('=', calculateResult),
                  buildButton('/', () => onButtonPressed('/')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
