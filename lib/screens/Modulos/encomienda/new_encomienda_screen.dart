import 'package:courier/core/widgets/app_bar.dart';
import 'package:courier/core/widgets/encomienda_form.dart';
import 'package:flutter/material.dart';

class NewEncomiendaScreen extends StatefulWidget {
  const NewEncomiendaScreen({super.key});

  @override
  State<NewEncomiendaScreen> createState() => _NewEncomiendaScreenState();
}

class _NewEncomiendaScreenState extends State<NewEncomiendaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nueva Encomienda',
      ),
      body: const EncomiendaForm(),
    );
  }
}