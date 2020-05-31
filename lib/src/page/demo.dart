import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../page/home.dart';
import '../convert/util.dart';
import '../convert/dialog.dart';
import '../convert/icon.dart';
import '../convert/session.dart';
import '../convert/gradient.dart';
import '../convert/api.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> with SingleTickerProviderStateMixin {
  final int delayedAmount = 0;
  int state = 0;
  double _scale;
  AnimationController _controller;
  TextEditingController tokenControler = new TextEditingController();
  
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    sessionLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    Widget _demoForm = demoForm();
    Widget _loadingForm = IfDialog.getLoading();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: getColor('FF5C1D'),
          body: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: state == 0 ? _demoForm : _loadingForm,
                    )
                  ]
                )
              )
            )
          )
        )
    );
  }

  Widget demoForm() {
    return Column(
      children: <Widget>[
        DelayedAnimation(
          child: Image.asset('assets/white-logo.png'),
          delay: delayedAmount + 500,
        ),
        SizedBox(height: 30.0,),
        DelayedAnimation(
          child: Text('นี่คือแอพทดสอบ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white,fontFamily: Site.font),),
          delay: delayedAmount + 1000,
        ),
        SizedBox(height: 5.0,),
        DelayedAnimation(
          child: Text('หากกำหนดค่า Token ในโค๊ดจะไม่เห็นหน้าต่างนี้',style: TextStyle(fontSize: Site.fontSize,color: Colors.white,fontFamily: Site.font),),
          delay: delayedAmount + 1500,
        ),
        DelayedAnimation(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(25),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: getGradient({'color1':'fff','color2':'fff0','range':90,'gradient':2}),
              ),
            )
          ),
          delay: delayedAmount + 2250,
        ),
        DelayedAnimation(
          child: Text('กรุณาใส่รหัส Token',style: TextStyle(fontSize: Site.fontSize, color: Colors.white,fontFamily: Site.font),),
          delay: delayedAmount + 2500,
        ),
        DelayedAnimation(
          child: Text('ที่ได้รับจากระบบจัดการแอพของคุณ', style: TextStyle(fontSize: Site.fontSize, color: Colors.white, fontFamily: Site.font),),
          delay: delayedAmount + 2750,
        ),
        SizedBox(height: 20.0,),
        DelayedAnimation(
          child: Container(
            width: 200,
            margin: EdgeInsets.only(bottom:20),
            child: TextField(
              controller: tokenControler,
              obscureText: false,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, decorationColor: Colors.white, fontFamily: Site.font,),
              decoration: InputDecoration(
                hintText: 'กรอกรหัส 10 ตัวอักษร',                                    
                //fillColor: Color(0xffff5717),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),),  
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),),
                filled: true
              )
            ),
          ),
          delay: delayedAmount + 3000,
        ),
        DelayedAnimation(
          child: GestureDetector(
            onTap: () {
              String token = tokenControler.text.trim();
              if(token.length < 10) {
                _invalidToken();
              } else {
                state = 1;
                Site.token = tokenControler.text;
                _loadData();
              }
            },
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            child: Transform.scale(
              scale: _scale,
              child: _animatedButtonUI,
            ),
          ),
          delay: delayedAmount + 3250,
        ),       
      SizedBox(height: 15.0,),
        DelayedAnimation(
          child: Text('หรือทดสอบค่าเริ่มต้นของแอพ', style: TextStyle(fontSize: Site.fontSize, color: Colors.white, fontFamily: Site.font),),
          delay: delayedAmount + 3500,
        ),
      SizedBox(height: 10.0,),
        DelayedAnimation(
          child: GestureDetector(
            child: _animateDefault,
            onTap: () {
              setState(() {
                state = 1;
                Site.token = '161:1568d1164e';
                _loadData();
              });
            },
          ),
          delay: delayedAmount + 3750,
        ),    
        DelayedAnimation(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(25),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: getGradient({'color1':'fff','color2':'fff0','range':90,'gradient':2}),
              ),
            )
          ),
          delay: delayedAmount + 4000,
        ),
        DelayedAnimation(          
          child: GestureDetector(
            onTap: () {
              _launchLink('https://ifelse.co/docs/apps');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(getIcon('info'), color: Colors.white, size: Site.fontSize),
                SizedBox(width: 8),
                Text('คู่มือการใช้งานเพิ่มเติม คลิกที่นี่', style: TextStyle(fontSize: Site.fontSize, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: Site.font),)
              ]
            )
          ),
          delay: delayedAmount + 4250,
        ),
      ],
    );
  }

  Widget get _animatedButtonUI => Container(
        height: 60,
        width: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(getIcon('arrow-right'), color: Color(0xFFFF5717), size: 20,),
              SizedBox(width: 8),
              Text('เริ่มทดสอบ !', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFFFF5717), fontFamily: Site.font),)
            ]
          )
        ),
      );

  Widget get _animateDefault => Container(
        height: 50,
        width: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color(0xFFAD2F00),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(getIcon('badge'), color: Colors.white, size: 20,),
              SizedBox(width: 8),
              Text('ดูตัวอย่าง (ค่าเริ่มต้น)', style: TextStyle(fontSize: Site.fontSize, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: Site.font),)
            ]
          )
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _invalidToken() async {
    await IfDialog.show(context: context, text: 'token ไม่ถูกต้อง');
  }
  
  void _launchLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  _loadData() async {
    String message = '';
    if(await Api.load()) {  
      return Timer(Duration(seconds: 1),() {
        Get.offAll(HomePage());
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      message = 'รหัส Token ไม่ถูกต้อง';
    }
    await IfDialog.show(context: context, text: message);
    
    setState(() {
      state = 0;
    });
    await IfDialog.show(context: context, text: message);
  }
}


class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  DelayedAnimation({@required this.child, this.delay});

  @override
  _DelayedAnimationState createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    final curve =  CurvedAnimation(curve: Curves.decelerate, parent: _controller);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(curve);
    if (widget.delay == null) {
      _controller.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      opacity: _controller,
    );
  }
}