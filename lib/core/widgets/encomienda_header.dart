import 'package:courier/models/encomienda.dart';
import 'package:flutter/material.dart';

class EncomiendaHeader extends StatelessWidget {
  final Encomienda encomienda;

  const EncomiendaHeader({required this.encomienda});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remito ${encomienda.serieRemito}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Origen: ${encomienda.agenciaOrigen}  •  Destino: ${encomienda.agenciaDestino}',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}