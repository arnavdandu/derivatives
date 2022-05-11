import 'dart:html';
import 'package:derivatives/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import "package:flutter_tex/flutter_tex.dart";
import 'package:extended_math/extended_math.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:stop_watch_timer/stop_watch_timer.dart";

String apiID = "3RRW76-5XJKG22JVA";
void main() {
  List derivatives = d();
  runApp(MyApp(
    derivatives: derivatives,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({this.derivatives});
  List derivatives;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Derivatives',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        derivatives: derivatives,
      ),
    );
  }
}

List d() {
  Random random = Random();
  int a = random.nextInt(9) + 2;
  int aInclude1 = random.nextInt(9) + 1;
  int b = random.nextInt(9) + 2;
  int bInclude1 = random.nextInt(9) + 1;
  int d = random.nextInt(9) + 2;
  int dInclude1 = random.nextInt(9) + 1;
  int e = random.nextInt(9) + 2;
  int eInclude1 = random.nextInt(9) + 1;
  int c = random.nextInt(6) + 2;
  int f = random.nextInt(6) + 2;
  int dmNum = random.nextInt(2);
  int dmNum2 = random.nextInt(2);
  int dmNum3 = random.nextInt(2);
  int dmNum4 = random.nextInt(2);
  int pmNum = random.nextInt(2);
  int pmNum2 = random.nextInt(2);
  int xNum = random.nextInt(1);

  List dm = [
    [' \\over ', '/'],
    ['', '']
  ];
  List pm = [
    ['+', '%2b'],
    ['-', '-']
  ];
  List xForms = [
    ['\\sqrt x', 'sqrt(x)'],
    ['x', 'x']
  ];
  List derivativeForms = [
    [
      r"<p> $$" +
          r"{d \over dx}" +
          "{(${a}x${pm[pmNum][0]}$b)^$c${dm[dmNum][0]}(${d}x${pm[pmNum2][0]}$e)^$f}" +
          r"$$</p>",
      "($a(x)${pm[pmNum][1]}$b)^$c ${dm[dmNum][1]} ($d(x)${pm[pmNum2][1]}$e)^$f"
    ],
    [
      r"<p> $$" +
          r"{d \over dx}" +
          "{{$aInclude1${dm[dmNum][0]}${xForms[xNum][0]}} ${pm[pmNum][0]} {$bInclude1${dm[dmNum2][0]}${xForms[xNum][0]}} \\over {$dInclude1${dm[dmNum3][0]}${xForms[xNum][0]}} ${pm[pmNum2][0]} {$eInclude1}}" +
          r"$$</p>",
      "($aInclude1${dm[dmNum][1]}${xForms[xNum][1]} ${pm[pmNum][1]} $bInclude1${dm[dmNum2][1]}${xForms[xNum][1]})/($dInclude1${dm[dmNum3][1]}${xForms[xNum][1]}${pm[pmNum2][1]}$eInclude1)"
    ]
  ];

  int formNum = random.nextInt(derivativeForms.length);
  List derivatives = derivativeForms[formNum];
  return derivatives;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.derivatives}) : super(key: key);
  List derivatives;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void future() async {
    await Future.delayed(Duration(seconds: 5));
  }

  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));

    setState(() {});

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  getAnswer(apiDerivative) async {
    var url =
        'https://www.wolframalpha.com/input/?i=derivative+of+$apiDerivative';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  Future sleepWatch() {
    return new Future.delayed(const Duration(seconds: 5), () {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataKey = new GlobalKey();
    sleepWatch();

    String derivativeTex = widget.derivatives[0];
    String apiDerivative = widget.derivatives[1];
    dynamic problem = TeXViewDocument(derivativeTex,
        style: (MediaQuery.of(context).size.width > 1300)
            ? TeXViewStyle.fromCSS(
                'padding: 15px; color: black; background: white; font-size: 300%;')
            : TeXViewStyle.fromCSS(
                'padding: 15px; color: black; background: white; font-size: 125%;'));
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Derivative Practice",
          textAlign: TextAlign.center,
        )),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                width: 700,
                child: TeXView(
                  key: dataKey,
                  child: problem,
                  loadingWidgetBuilder: (context) => Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("Rendering...")
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1),
                child: StreamBuilder(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: _isHours);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              (MediaQuery.of(context).size.width > 1300)
                  ? Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomRaisedButton(
                                  width: 400,
                                  height: 100,
                                  child: Text(
                                    "Answer",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  onPressed: () {
                                    String deriv = apiDerivative;
                                    print(deriv);
                                    _stopWatchTimer.onExecute
                                        .add(StopWatchExecute.stop);
                                    getAnswer(apiDerivative);
                                  }),
                              SizedBox(
                                width: 30,
                              ),
                              CustomRaisedButton(
                                  width: 400,
                                  height: 100,
                                  child: Text(
                                    "New Problem",
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                    widget.derivatives = d();
                                    Scrollable.ensureVisible(
                                        dataKey.currentContext);
                                    _stopWatchTimer.onExecute
                                        .add(StopWatchExecute.reset);
                                  }),
                            ],
                          ),
                        ),
                        SizedBox(height: 120)
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomRaisedButton(
                            width: 200,
                            height: 50,
                            child: Text(
                              "Answer",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.stop);
                              String deriv = apiDerivative;
                              print(deriv);
                              getAnswer(apiDerivative);
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        CustomRaisedButton(
                            width: 200,
                            height: 50,
                            child: Text(
                              "New Problem",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              setState(() {});
                              widget.derivatives = d();
                              Scrollable.ensureVisible(dataKey.currentContext);
                              _stopWatchTimer.onExecute
                                  .add(StopWatchExecute.reset);
                            }),
                        SizedBox(height: 600)
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
