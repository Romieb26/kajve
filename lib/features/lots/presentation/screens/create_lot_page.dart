import 'package:flutter/material.dart';

class CreateLotPage extends StatelessWidget {
  const CreateLotPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffB65F08),

      appBar: AppBar(
        title: const Text("Nuevo lote"),
        backgroundColor: Colors.brown,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(

          children: [

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(

                children: [

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Nombre del lote",
                    ),
                  ),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Tipo de café",
                    ),
                  ),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Fecha de inicio",
                    ),
                  ),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Ubicación",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height:20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Asociar sensores",
                    style: TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  CheckboxListTile(
                    value: true,
                    onChanged: null,
                    title: Text("Humedad de suelo #1"),
                  ),

                  CheckboxListTile(
                    value: false,
                    onChanged: null,
                    title: Text("Temperatura Aire #1"),
                  ),

                ],
              ),
            ),

            const SizedBox(height:25),

            const Text(
              "QR",
              style: TextStyle(
                fontSize:22,
                color: Colors.white,
              ),
            ),

            const SizedBox(height:10),

            Container(
              height: 180,
              width: 180,
              color: Colors.white,
              child: const Center(
                child: Icon(
                  Icons.qr_code,
                  size:120,
                ),
              ),
            ),

            const SizedBox(height:20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Guardar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}