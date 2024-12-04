import 'package:flutter/material.dart';
import 'IncidentRepository.dart';
import 'DatabaseHelper.dart'; // Asegúrate de importar DatabaseHelper

class MostrarIncidentes extends StatefulWidget {
  const MostrarIncidentes({Key? key}) : super(key: key);

  @override
  _MostrarIncidentesState createState() => _MostrarIncidentesState();
}

class _MostrarIncidentesState extends State<MostrarIncidentes> {
  late final IncidentRepository _incidentRepository;
  late Future<List<Map<String, dynamic>>> _incidentFuture;

  @override
  void initState() {
    super.initState();
    // Crear una instancia de DatabaseHelper y pasarla al constructor de IncidentRepository
    final databaseHelper = DatabaseHelper();
    _incidentRepository = IncidentRepository(databaseHelper);
    _incidentFuture = _incidentRepository.getAllIncidents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _incidentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No incidents found.');
        } else {
          // Crear una copia de la lista para evitar modificar la original
          List<Map<String, dynamic>> sortedIncidents = List.from(snapshot.data!);

          // Ordenar la lista de incidentes por fecha
          sortedIncidents.sort((a, b) => a['date'].compareTo(b['date']));

          return ListView.builder(
            itemCount: sortedIncidents.length > 4 ? 4 : sortedIncidents.length, // Mostrar máximo 4 elementos
            itemBuilder: (context, index) {
              final incident = sortedIncidents[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Ajuste del ancho de los rectángulos
                title: Text(
                  'Parking: ${incident['parkingName']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Danger Level: ${incident['dangerLevel']}'),
                    Text('Date: ${incident['date']}'), // Agregamos la fecha como segundo subtítulo
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
