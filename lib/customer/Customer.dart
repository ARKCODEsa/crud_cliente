import 'package:flutter/material.dart';
import 'package:crud_cliente/bd/Conexion.dart';

class Customer {
  final int id;
  final String name;
  final String lastName;
  final String address;
  final String phone;
  final String email;

  Customer({
    required this.id,
    required this.name,
    required this.lastName,
    required this.address,
    required this.phone,
    required this.email,
  });
}

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final Conexion conexion = Conexion();
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  void fetchCustomers() async {
    final List<Map<String, dynamic>> customerList = await conexion.obtenerCustomer();
    setState(() {
      customers = customerList.map((customer) => Customer(
        id: customer['id'],
        name: customer['name'],
        lastName: customer['last_name'],
        address: customer['address'],
        phone: customer['phone'],
        email: customer['email'],
      )).toList();
    });
  }

  void addCustomer() async {
    final String name = nameController.text;
    final String lastName = lastNameController.text;
    final String address = addressController.text;
    final String phone = phoneController.text;
    final String email = emailController.text;

    if (name.isEmpty || lastName.isEmpty || address.isEmpty || phone.isEmpty || email.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor, llene todos los campos'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      await conexion.addCustomer(name, lastName, address, phone, email);
      nameController.clear();
      lastNameController.clear();
      addressController.clear();
      phoneController.clear();
      emailController.clear();
      fetchCustomers();
      Navigator.of(context).pop();
    }
  }

  void editCustomer(Customer customer) async {
    nameController.text = customer.name;
    lastNameController.text = customer.lastName;
    addressController.text = customer.address;
    phoneController.text = customer.phone;
    emailController.text = customer.email;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final String name = nameController.text;
                final String lastName = lastNameController.text;
                final String address = addressController.text;
                final String phone = phoneController.text;
                final String email = emailController.text;

                if (name.isEmpty || lastName.isEmpty || address.isEmpty || phone.isEmpty || email.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Por favor, llene todos los campos'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  await conexion.editCustomer(customer.id, name, lastName, address, phone, email);
                  nameController.clear();
                  lastNameController.clear();
                  addressController.clear();
                  phoneController.clear();
                  emailController.clear();
                  fetchCustomers();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void deleteCustomer(int id) async {
    await conexion.deleteCustomer(id);
    fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Nuevo Cliente'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Nombre'),
                        ),
                        TextField(
                          controller: lastNameController,
                          decoration: const InputDecoration(labelText: 'Apellido'),
                        ),
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(labelText: 'Dirección'),
                        ),
                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Teléfono'),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: addCustomer,
                        child: const Text('Guardar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return ListTile(
            title: Text(customer.name),
            subtitle: Text(customer.lastName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => editCustomer(customer),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteCustomer(customer.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}