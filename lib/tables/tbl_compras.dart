import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VentasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Compras',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff00CED1),
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
            VentasDatos(),
            VentasFormulario(),
          ],
        ),
      ),
    );
  }
}

class VentasFormulario extends StatefulWidget {
  const VentasFormulario({Key? key}) : super(key: key);

  @override
  _VentasFormularioState createState() => _VentasFormularioState();
}

class _VentasFormularioState extends State<VentasFormulario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idVentaController = TextEditingController();
  final TextEditingController _idClientesController = TextEditingController();
  final TextEditingController _idEmpleadoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _extrasController = TextEditingController();
  final TextEditingController _idVehiculoController = TextEditingController();
  final TextEditingController _descuentoController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection('ventas').add({
        'id_venta': _idVentaController.text,
        'id_clientes': _idClientesController.text,
        'id_empleado': _idEmpleadoController.text,
        'fecha': _fechaController.text,
        'total': _totalController.text,
        'id_vehiculo': _idVehiculoController.text,
        'extras': int.tryParse(_extrasController.text) ?? 0,
        'descuento': _descuentoController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Venta añadida exitosamente')),
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
                  return 'Por favor ingrese el ID de los vehiculos';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _idClientesController,
              decoration: InputDecoration(
                labelText: 'ID Clientes',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el ID de los clientes';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _idVentaController,
              decoration: InputDecoration(
                labelText: 'ID Venta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _fechaController,
              decoration: InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la fecha';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _totalController,
              decoration: InputDecoration(
                labelText: 'Total a Pagar',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el total a pagar';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _extrasController,
              decoration: InputDecoration(
                labelText: 'Número de extras',
                border: OutlineInputBorder(),
              ),
            ),
            //const SizedBox(height: 10),
            //TextFormField(
            //controller: _idVehiculoController,
            //decoration: InputDecoration(
            //labelText: 'Id Vehiculo',
            //border: OutlineInputBorder(),
            // ),
            //keyboardType: TextInputType.number,
            //validator: (value) {
            //if (value == null || value.isEmpty) {
            //return 'Por favor ingrese el id del vehiculo';
            // }
            //return null;
            //},
            //),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descuentoController,
              decoration: InputDecoration(
                labelText: 'Descuento',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Añadir Venta'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff00CED1),
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

class VentasDatos extends StatelessWidget {
  const VentasDatos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ventas').snapshots(),
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
                'Venta ID: ${doc['id_venta']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Fecha: ${doc['fecha']}'),
              trailing: Text(
                  'Total: \$${doc['total']} - Descuento: ${doc['descuento']}'),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          },
        );
      },
    );
  }
}
