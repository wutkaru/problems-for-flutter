import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      home: MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color textColor = Colors.white;
  final Color logoColor = Color(0xff438593);
  final Color topMenuColor = Color(0xff88454A);
  final Color leftMenu = Color(0xff0C263E);
  final Color headerColor = Color(0xff454545);
  final Color contentColor = Color(0xff7893AA);
  final Color detailColor = Color(0xff8D8D8D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildContainer('LOGO', logoColor),
                  Expanded(
                    child: _buildContainer('TOP MENU', topMenuColor),
                  ),
                ],
              ),
              Expanded(
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildContainer('LEFT MENU', leftMenu),
                    Expanded(
                      flex: 3,
                      child: Column( 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildContainer('HEADER', headerColor),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                 _buildContainer('CONTENT', contentColor),
                                Expanded(
                                  child: _buildContainer('DETAIL', detailColor)
                                )
                              ],
                            ),
                          )
                        ]
                      ),
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildContainer(String text, Color color) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      color: color,
      child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontSize: 14)),)
    );
  }
}
