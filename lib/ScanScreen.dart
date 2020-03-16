import 'package:flutter/material.dart';
import "package:flutter/animation.dart";
class ScanScreen extends StatefulWidget{
  final Function() showPlacesFunction;
  final Function() downloadDataFunction;
  ScanScreen(this.showPlacesFunction, this.downloadDataFunction):super();
  @override
  _ScanScreen createState() => _ScanScreen();


}

class _ScanScreen extends State<ScanScreen>  with SingleTickerProviderStateMixin{
  Animation<double> animation;
  AnimationController controller;
  Tween tween;
  @override
  void initState(){

    tween = Tween<double>(begin: 80, end: 120);
     controller = AnimationController(duration: const Duration(milliseconds: 1300), vsync: this);
  }
  void animateBtn(){
    animation = tween.animate(CurvedAnimation(parent:controller, curve:Curves.easeInOutBack))..addListener(() {setState(() {
        if (animation.isCompleted) this.widget.showPlacesFunction();
    });});

    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    //powiększa się i zmniejsza po kliknięciu
    return Center(
      child:
      Ink(

        decoration: const ShapeDecoration(
        color: Colors.lightBlueAccent,
        shape: CircleBorder(),
    ),child: IconButton(
        icon:Icon(Icons.place),color:Colors.white, onPressed:(){animateBtn(); }, iconSize: 70,padding: EdgeInsets.all(animation==null?80:animation.value), ),
    ));
  }

}