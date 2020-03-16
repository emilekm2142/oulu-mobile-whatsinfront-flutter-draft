import 'package:flutter/material.dart';
class BottomBar extends StatefulWidget{
  final Function(int) updateIndexInParent;
  int _selectedIndex;
  BottomBar(this.updateIndexInParent, this._selectedIndex):super(){
    this._selectedIndex = this._selectedIndex>1?0:this._selectedIndex;
  }
  @override
  _BottomBar createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar>{
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {

    setState(() {
      this.widget.updateIndexInParent(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            title: Text('Discover'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('favorites'),
          ),

        ],
        currentIndex: this.widget._selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      );

  }
}