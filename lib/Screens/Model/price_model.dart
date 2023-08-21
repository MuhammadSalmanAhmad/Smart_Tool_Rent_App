import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tool Price Predictor',
      home: ToolPricePage(),
    );
  }
}

class ToolPricePage extends StatefulWidget {
  @override
  _ToolPricePageState createState() => _ToolPricePageState();
}

class _ToolPricePageState extends State<ToolPricePage> {
  late Interpreter _interpreter;
  double _predictedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    final interpreterOptions = InterpreterOptions()..threads = 2;
    _interpreter = await Interpreter.fromAsset('assets/tool_price_model.tflite', options: interpreterOptions);
  }

  Future<void> predictPrice(List<double> features) async {
    final input = Float32List.fromList(features);
    final output = Float32List(1); // Assuming the model outputs a single float
    _interpreter.run(input, output);

    setState(() {
      _predictedPrice = output[0];
    });
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tool Price Predictor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Predicted Price: $_predictedPrice'),
            ElevatedButton(
              onPressed: () {
                // Replace this with the logic to input tool features
                List<double> toolFeatures = []; // Replace with actual values
                predictPrice(toolFeatures);
              },
              child: Text('Predict Price'),
            ),
          ],
        ),
      ),
    );
  }
}
