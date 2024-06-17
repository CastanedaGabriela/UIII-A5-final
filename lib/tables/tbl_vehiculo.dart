import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Vehiculo',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xffff8dd0),
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Tabla', icon: Icon(Icons.list, color: Colors.white)),
              Tab(
                  text: 'Datos',
                  icon: Icon(Icons.list_alt, color: Colors.white)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductoDatos(),
            ProductoFormulario(),
          ],
        ),
      ),
    );
  }
}

class ProductoFormulario extends StatefulWidget {
  const ProductoFormulario({Key? key}) : super(key: key);

  @override
  _ProductoFormularioState createState() => _ProductoFormularioState();
}

class _ProductoFormularioState extends State<ProductoFormulario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idVehiculoController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _transmisionController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _cilindrosController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection('Vehiculo').add({
        'id_vehiculo': _idVehiculoController.text,
        'vin': _vinController.text,
        'transmision': _transmisionController.text,
        'costo': double.tryParse(_costoController.text) ?? 0.0,
        'modelo': _modeloController.text,
        'cilindros': _cilindrosController.text,
        'color': _colorController.text,
        'descripcion': _descripcionController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehiculo añadido exitosamente')),
      );

      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _idVehiculoController,
              decoration: InputDecoration(
                labelText: 'ID Vehiculo',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el ID del vehiculo';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _vinController,
              decoration: InputDecoration(
                labelText: 'Vin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _transmisionController,
              decoration: InputDecoration(
                labelText: 'Transmision',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la transmision';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _costoController,
              decoration: InputDecoration(
                labelText: 'Costo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el costo';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _modeloController,
              decoration: InputDecoration(
                labelText: 'Modelo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cilindrosController,
              decoration: InputDecoration(
                labelText: 'Cilindros',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _colorController,
              decoration: InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Añadir Vehiculo'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xffff8dd0),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductoDatos extends StatelessWidget {
  const ProductoDatos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('producto').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            final doc = data.docs[index];
            return ListTile(
              title: Text(
                doc['modelo'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text('ID: ${doc['id_vehiculo']} - Costo: \$${doc['costo']}'),
              trailing: Text(doc['cilindros']),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          },
        );
      },
    );
  }
}
