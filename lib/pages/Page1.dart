import 'package:flutter/material.dart';
import 'package:proyecto_final/pages/pages.dart';
import 'package:proyecto_final/mapa.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          pages[1].title,
          style: TextStyle(color: Colors.grey[850]),
        ),
        backgroundColor: Colors.green[50],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                width: 300,
                height: 480,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MapaContainer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapaContainer extends StatefulWidget {
  const MapaContainer({Key? key}) : super(key: key);

  @override
  _MapaContainerState createState() => _MapaContainerState();
}

class _MapaContainerState extends State<MapaContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Mapa(),
      ),
    );
  }
}
