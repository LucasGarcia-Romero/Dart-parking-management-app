import 'package:flutter/material.dart';

import 'DatabaseHelper.dart';
import 'IncidentRepository.dart';

class ParkingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> parkingLot;
  final IncidentRepository incidentRepository = IncidentRepository(DatabaseHelper());

  ParkingDetailsScreen({Key? key, required this.parkingLot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          parkingLot['nome'] ?? 'Parking Details',
          style: TextStyle(color: Colors.grey[850]),  // Text color
        ),
        backgroundColor: Colors.green[50],  // Background color
        iconTheme: IconThemeData(color: Colors.black),  // Back arrow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
              child: Text(
                'Parking Details',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
              child: Text(
                'Occupied Spaces: ${parkingLot['ocupacao'] != null ? parkingLot['ocupacao'] : 0}/${parkingLot['capacidade_max']}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
              child: Text(
                'Type: ${parkingLot['tipo'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
              child: Text(
                'Open: ${parkingLot['activo'] == 1 ? 'Yes' : (parkingLot['activo'] == 0 ? 'No' : 'Unknown')}',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
              child: Text(
                'Incidents',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: incidentRepository.getParkingIncidents(parkingLot['nome']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No incidents found'));
                } else {
                  List<Map<String, dynamic>> incidents = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: incidents.asMap().entries.map((entry) {
                      int index = entry.key + 1;
                      Map<String, dynamic> incident = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // Adjust the bottom padding as needed
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
                              child: Text('Incident $index', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
                              child: Text('Danger Level: ${incident['dangerLevel']}'),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
                              child: Text('Date: ${incident['date']}'),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),  // Adjust horizontal padding as needed
                              child: Text('Comments: ${incident['comments'] ?? 'No comments'}'),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
