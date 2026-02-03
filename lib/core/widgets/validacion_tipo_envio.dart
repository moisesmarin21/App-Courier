String? validarPesoPorTipoEnvio({
  required String tipoEnvio,
  required double pesoKg,
}) {
  if (tipoEnvio == '-1' || tipoEnvio.isEmpty) {
    return 'Por favor, seleccione tipo de envío';
  }

  switch (tipoEnvio) {
    case 'Sobre':
      if (pesoKg <= 0 || pesoKg > 0.5) {
        return 'Peso incorrecto para Sobre. Hasta 0.5 kg';
      }
      break;

    case 'Pequeno Paquete Documento':
      if (pesoKg <= 0.5 || pesoKg > 5) {
        return 'Peso incorrecto para Documento. Desde 0.5 kg hasta 5 kg';
      }
      break;

    case 'Pequeno Paquete Mercancia':
      if (pesoKg <= 0 || pesoKg > 10000) {
        return 'Peso incorrecto para Mercancía. Hasta 10,000 kg';
      }
      break;

    case 'Encomienda Postal':
      // Libre, sin validación
      break;

    default:
      return 'Tipo de envío no válido';
  }

  return null; // ✅ todo OK
}