import 'package:flutter/material.dart';

import 'Page0.dart';
import 'Page1.dart';
import 'Page2.dart';
import 'Page3.dart';


final pages = [
  (title: 'Last Incidents', icon: Icons.dashboard, widget: Page0()),
  (title: 'Map', icon: Icons.map, widget: Page1()),
  (title: 'List', icon: Icons.list, widget: Page2()),
  (title: 'Incidents', icon: Icons.build, widget: Page3()),
];