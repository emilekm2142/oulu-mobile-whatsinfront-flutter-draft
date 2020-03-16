import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:stuffinfrontofme/Database.dart';
import 'package:stuffinfrontofme/FavoritesScreen.dart';
import 'MapObject.dart';
import 'SingleObjectScreen.dart';
import "bottomBar.dart";
import "ScanScreen.dart";
import "ResultsScreen.dart";
import "ObjectsService.dart";
import 'package:geolocator/geolocator.dart';
void main(){

  return runApp(MyApp());

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What is in front of me?',
      home: MainScreen(),
      theme: ThemeData(
       // splashFactory: InkRipple.splashFactory,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),

    );
  }
}

class MainScreen extends StatefulWidget{
  @override
  _MainScreen createState() => _MainScreen();



}
class _MainScreen extends State<MainScreen>{
  String titleText = "What is in front of me?";
  int currentViewIndex=0;
  List<Function> views=[];
  _MainScreen(){
    var favoritesScreen =  ()=>FavoritesScreen(
      returnFunction:(){changeCurrentViewIndex(0);},
      singleViewFunction:
          (mo)async{
        var pos= await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        debugPrint(pos.toString());
        StaticDataHolder.myPosition = LatLng(pos.latitude, pos.longitude);
        StaticDataHolder.center=LatLng(mo.lat,mo.lon);
        StaticDataHolder.currentObject = mo;
        StaticDataHolder.lastScreenFavorites=true;
        changeCurrentViewIndex(3);
      },
    );
    var resultsScreen =  ()=>ResultsScreen(
      returnFunction:(){changeCurrentViewIndex(0);},
      singleViewFunction:
          (mo)async{
        var pos= await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        debugPrint(pos.toString());
        StaticDataHolder.myPosition = LatLng(pos.latitude, pos.longitude);
        StaticDataHolder.center=LatLng(mo.lat,mo.lon);
        StaticDataHolder.currentObject = mo;
        StaticDataHolder.lastScreenFavorites=false;
        changeCurrentViewIndex(3);
      },
    );
    views =[()=>ScanScreen((){changeCurrentViewIndex(2);}, HttpService.getPosts ),favoritesScreen,
          resultsScreen,
          ()=>SingleObjectScreen(returnFunction:(){if (StaticDataHolder.lastScreenFavorites) changeCurrentViewIndex(1); else changeCurrentViewIndex(2);},)];
  }

  void changeCurrentViewIndex(int i){
    setState((){  this.currentViewIndex=i; });
  }
  @override
  void initState(){
      setPermissions();

  }
  void setPermissions() async{
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    //geolocationStatus.value
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:IconButton(
            icon:Icon(Icons.menu),
            color: Colors.white,
            onPressed: ()=>null,
          ),
            title: Text(titleText)
        ),
      body:AnimatedSwitcher(child:this.views[this.currentViewIndex](), duration: const Duration(seconds: 1),
        transitionBuilder: (Widget child, Animation<double> animation){
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
        bottomNavigationBar: BottomBar(this.changeCurrentViewIndex, this.currentViewIndex),
    );
  }
  }
class ScanButton extends StatefulWidget{
  @override
  _ScanButton createState() => _ScanButton();
}
  class _ScanButton extends State<ScanButton>{
  @override
  Widget build(BuildContext context){
    return IconButton(icon:Icon( Icons.account_circle), onPressed: null,);
  }
  }

