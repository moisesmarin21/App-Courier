class ApiEndpoints {

  static const String login = '/auth/login';

  // No existen
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String users = '/users';
  static const String createUser = '/users/create';
  static const String updateUser = '/users/update';
  static const String customers = '/customers';
  static const String couriers = '/couriers';
  static const String createCourier = 'couriers/create';
  
  // Sucursales
  static const String sucursales = '/sucursales/getSucursales';
  static const String sucursalesSimple = '/sucursales/getSucursalesSimple';
  
  // Clientes
  static const String clientes = '/clientes/getClientes';
  static const String clienteById = '/clientes/getClienteById';
  static const String createCustomer = '/clientes/createCliente';
  static const String customersType = '/clientes/getTiposCliente';
  static const String searchCustomer = '/clientes/buscarCliente';

  // Encomiendas
  static const String encomiendas = '/encomienda/getEncomiendas';
  static const String createEncomienda = '/encomienda/createEncomienda';
  static const String historialEstados = '/encomienda/getHistorialEstados';
  static const String estadoDisponibles = '/encomienda/getEstadosDisponibles';
  static const String newEstado = '/encomienda/addEstadoEncomienda';
  static const String calcularPrecio = '/encomienda/calcularPrecio';
  static const String llamarImagenes = '/encomienda/getImagenesEncomienda';
  static const String agregarImagen = '/encomienda/addImagenEncomienda';
  static const String asignarMotorizados = '/encomienda/addMotorizados';
  
  // Configuraciones
  static const String detraccionsType = '/configuraciones/getDetracciones';
  static const String departments = '/configuraciones/getDepartamentos';
  static const String provinces = '/configuraciones/getProvincias';
  static const String districts = '/configuraciones/getDistritos';
  static const String paymentTypes = '/configuraciones/getTiposPago';
  static const String planes = '/configuraciones/getPlanes';
  static const String shippingTypes = '/configuraciones/getTiposEnvio';
  static const String deliveyTypes = '/configuraciones/getTiposEntrega';
  static const String infoByDni = '/configuraciones/getNombrePorDNI';
  static const String infoByRuc = '/configuraciones/getRazonSocialPorRUC';

  // Usuarios
  static const String motorizados = '/usuarios/getMotorizados';
}