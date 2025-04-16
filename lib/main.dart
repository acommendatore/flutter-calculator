import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // External package for expression evaluation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Your Name - Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = ''; // Accumulator for the current input
  String _result = ''; // To display result of evaluation

  // Function to evaluate the expression
  void _evaluateExpression() {
    try {
      final expression = Expression.parse(_expression);
      final evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      setState(() {
        _result = result.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  // Function to update expression as user presses buttons
  void _updateExpression(String value) {
    setState(() {
      _expression += value;
    });
  }

  // Function to clear the expression and result
  void _clear() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  // Function to square the current result or expression
  void _squareValue() {
    try {
      final expression = Expression.parse(_expression);
      final evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {});
      final squared = (result as num) * (result as num);
      setState(() {
        _result = squared.toString();
        _expression = squared.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = [
      '7', '8', '9', '/',
      '4', '5', '6', '*',
      '1', '2', '3', '-',
      'C', '0', '=', '+',
      'x²', '%'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Display the ongoing expression and result
            Text(
              _expression.isEmpty ? 'Enter Expression' : _expression,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _result,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Calculator Button Grid
            GridView.builder(
              shrinkWrap: true,
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return _buildButton(buttons[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build a single button for the calculator
  Widget _buildButton(String buttonText) {
    return GestureDetector(
      onTap: () {
        if (buttonText == 'C') {
          _clear();
        } else if (buttonText == '=') {
          _evaluateExpression();
        } else if (buttonText == 'x²') {
          _squareValue();
        } else {
          _updateExpression(buttonText);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
