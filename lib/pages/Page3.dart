import 'package:flutter/material.dart';
import 'package:proyecto_final/pages/pages.dart';
import 'package:proyecto_final/mapa.dart';

import '../incidentes.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key});

  //Add incidents page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text(pages[3].title,
          style: TextStyle(color: Colors.grey[850]),
        ),
        backgroundColor: Colors.green[50],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                width: 300,
                height: 380,
                child: Incidentes(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
