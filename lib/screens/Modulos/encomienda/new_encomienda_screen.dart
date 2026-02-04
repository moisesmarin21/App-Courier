import 'package:courier/core/utils/exit_confirmation.dart';
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final salir = await ExitConfirmation.show(
          context,
          message: 'Se perderá toda la información llenada en el formulario para nueva encomienda',
        );

        if (salir) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Nueva Encomienda',
          onBack: () async {
            final salir = await ExitConfirmation.show(
              context,
              message: 'Se perderá toda la información llenada en el formulario para nueva encomienda',
            );

            if (salir) {
              Navigator.of(context).pop();
            }
          },
        ),
        body: const EncomiendaForm(),
      ),
    );
  }
}