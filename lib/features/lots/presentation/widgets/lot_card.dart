import 'package:flutter/material.dart';

class LotCard extends StatelessWidget {

  final String nombre;
  final String fecha;
  final String estado;
  final Color colorEstado;

  const LotCard({
    super.key,
    required this.nombre,
    required this.fecha,
    required this.estado,
    required this.colorEstado,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          const Icon(Icons.grass,size:45),

          const SizedBox(width:10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:18,
                  ),
                ),

                Text("Registrado:"),
                Text(fecha),

                Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    label: Text(estado),
                    backgroundColor: colorEstado.withOpacity(.2),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}