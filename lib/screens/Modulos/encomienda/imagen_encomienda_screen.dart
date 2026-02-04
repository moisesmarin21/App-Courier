import 'dart:io';

import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/core/widgets/app_bar.dart';
import 'package:courier/models/encomienda.dart';
import 'package:courier/providers/encomiendas_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ImagenEncomiendaScreen extends StatefulWidget {
  final Encomienda encomienda;
  const ImagenEncomiendaScreen({super.key, required this.encomienda});

  @override
  State<ImagenEncomiendaScreen> createState() => _ImagenEncomiendaScreenState();
}

class _ImagenEncomiendaScreenState extends State<ImagenEncomiendaScreen> {
  late int idEncomienda;
  
  @override
  void initState() {
    super.initState();
    idEncomienda = int.parse(widget.encomienda.id!);
    Future.microtask(() {
      Provider.of<EncomiendasProvider>(context, listen: false).getImagenesEncomienda(idEncomienda);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Imagenes de encomienda',
        onBack: () => Navigator.pop(context),
      ),
      body: Consumer<EncomiendasProvider>(
        builder: (context, provider, _) {
          final imagenes = provider.imagenesEncomienda;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Agregar nueva imagen', style: AppStyles.labelBlue),
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: AppColors.primary,
                      tooltip: 'Agregar imagen',
                      onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => SubirImagenModal(idEncomienda: idEncomienda),
                      );
                    },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: imagenes.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay imágenes disponibles',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: imagenes.length,
                        itemBuilder: (context, index) {
                          final imageUrl = imagenes[index].imagen;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VistaImagenScreen(
                                    imageUrl: imageUrl,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  Uri.encodeFull(imageUrl),
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Icon(Icons.broken_image, size: 40),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class VistaImagenScreen extends StatelessWidget {
  final String imageUrl;

  const VistaImagenScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await descargarImagen(context, imageUrl);
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            Uri.encodeFull(imageUrl),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> descargarImagen(BuildContext context, String url) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) return;

      final dir = await getExternalStorageDirectory();
      final fileName = url.split('/').last;

      final savePath = '${dir!.path}/$fileName';

      await Dio().download(
        Uri.encodeFull(url),
        savePath,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen descargada correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al descargar la imagen')),
      );
    }
  }
}

class SubirImagenModal extends StatefulWidget {
  final int idEncomienda; // para enviar al backend
  const SubirImagenModal({super.key, required this.idEncomienda});

  @override
  State<SubirImagenModal> createState() => _SubirImagenModalState();
}

class _SubirImagenModalState extends State<SubirImagenModal> {
  File? _imagen;
  final ImagePicker _picker = ImagePicker();
  bool _cargando = false;

  Future<void> _seleccionarImagen(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80, // comprime un poco
    );

    if (picked != null) {
      setState(() {
        _imagen = File(picked.path);
      });
    }
  }

  Future<void> _subirImagen() async {
    if (_imagen == null) return;

    setState(() => _cargando = true);

    try {
      final formData = FormData.fromMap({
      'id_encomienda': (widget.idEncomienda).toString(),
      'file': await MultipartFile.fromFile(
        _imagen!.path,
        filename: _imagen!.path.split('/').last,
      ),
    });

    // Revisar contenido
    formData.fields.forEach((f) => print('Campo: ${f.key} = ${f.value}'));
    formData.files.forEach((f) => print('Archivo: ${f.key} -> ${f.value.filename}'));

      final provider = Provider.of<EncomiendasProvider>(
        context,
        listen: false,
      );
      await provider.addImagenEncomienda(formData);

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _seleccionarImagen(ImageSource.gallery),
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imagen == null
                    ? const Icon(
                        Icons.add,
                        size: 80,
                        color: Colors.grey,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _imagen!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => _seleccionarImagen(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Galería'),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => _seleccionarImagen(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargando ? null : _subirImagen,
              child: _cargando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Subir imagen'),
            ),
          ],
        ),
      ),
    );
  }
}