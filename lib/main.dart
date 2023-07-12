import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: debugDisableShadows,
      title: '간단한 계산기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String statuement = ""; // 계산식
  String result = "0"; // 계산결과
  final List<String> buttons = <String>[
    // 버튼 텍스트 배열
    'C',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'AC',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: _resultView(),
            ),
            Expanded(
              flex: 4,
              child: _buttons(),
            )
          ],
        ),
      ),
    );
  }

// 맨 위에 계산 결과를 보여주는 뷰
  Widget _resultView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(
            statuement,
            style: const TextStyle(fontSize: 32),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(
            result,
            style: const TextStyle(fontSize: 32),
          ),
        )
      ],
    );
  }

// 버튼을 그리드 형식으로 뿌려주는 함수
  Widget _buttons() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return _myButton(buttons[index]);
      },
      itemCount: buttons.length,
    );
  }

// 개개의 버튼을 꾸며주는 함수
  Widget _myButton(String text) {
    return Container(
      // Container << 도형을 그릴 때 자주 사용하는 위젯
      margin: const EdgeInsets.all(5),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            clickButton(text);
          });
        },
        color: _getColor(text),
        textColor: Colors.white,
        child: Text(
          text,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

// 버튼의 색깔을 정해주는 함수
  _getColor(String text) {
    if (text == '=' ||
        text == '*' ||
        text == '+' ||
        text == '-' ||
        text == '/') {
      return Colors.orangeAccent;
    }
    if (text == 'C' || text == 'AC') {
      return Colors.red;
    }
    if (text == '(' || text == ')') {
      return Colors.blueGrey;
    }
    return Colors.blueAccent;
  }

  clickButton(String text) {
    if (text == 'AC') {
      statuement = '';
      result = '0';
      return;
    }
    if (text == 'C') {
      statuement = statuement.substring(0, statuement.length - 1);
      return;
    }
    if (text == '=') {
      result = calculator();
      return;
    }
    statuement = statuement + text;
  }

  calculator() {
    try {
      // statuement 에 저장된 수식을 가져와서
      // math expressions 의 Parser() 함수로 분석
      var exp = Parser().parse(statuement);
      // 해답은 math expressions 의 evaluate 함수를 사용해서
      // (에러가 없을 경우)
      // 해당 수식을 전개
      var ans = exp.evaluate(EvaluationType.REAL, ContextModel());
      return ans.toString();
    } catch (e) {
      return 'Error';
    }
  }
}
