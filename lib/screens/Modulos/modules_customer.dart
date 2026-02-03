import 'package:courier/core/constants/app_images.dart';
import 'package:courier/core/constants/colors.dart';
import 'package:courier/core/constants/styles.dart';
import 'package:courier/providers/auth_provider.dart';
import 'package:courier/routes/app_routes.dart';
import 'package:courier/screens/Modulos/encomienda/encomienda_screen.dart';
import 'package:courier/screens/Modulos/customer/customer_screen.dart';
import 'package:courier/screens/Modulos/dashboard/dashboard_screen.dart';
import 'package:courier/screens/Modulos/usuario/motorizado_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModulesCustomer extends StatefulWidget {
  const ModulesCustomer({super.key});

  @override
  State<ModulesCustomer> createState() => _ModulesCustomerState();
}

class _ModulesCustomerState extends State<ModulesCustomer> {
  bool _showMainPanel = true;
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CustomerScreen(),
    const EncomiendaScreen(),
    const MotorizadosScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showMainPanel = false;
    });
  }

  BottomNavigationBarItem _buildBottomItem(String asset, int index) {
    final isSelected = !_showMainPanel && _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Image.asset(
        asset,
        width: 30,
        height: 30,
        color: isSelected ? AppColors.primary : Colors.black,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showMainPanel ? AppColors.primary : Colors.white,
      drawer: _buildDrawer(context),
      body: _showMainPanel ? _buildMainPanel() : _screens[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFD9D9D9),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: _showMainPanel ? 0 : _selectedIndex,
          onTap: _onItemTapped,
          items: [
            _buildBottomItem(AppImages.barchart, 0),
            _buildBottomItem(AppImages.customer, 1),
            _buildBottomItem(AppImages.courier, 2),
            _buildBottomItem(AppImages.motorizado, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPanel() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bodyPadding = screenWidth * 0.06;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: bodyPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SalesModuleHeader(),
                  const SizedBox(height: 35),
                  SalesModuleCards(onCardTap: _onItemTapped),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final loginProvider = Provider.of<AuthProvider>(context, listen: false);
    final name = loginProvider.session!.nombre;
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      AppImages.user,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppStyles.title),
                      Text('Administrador', style: AppStyles.subtitleWhite),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          buildDrawerTile(
            asset: AppImages.profile,
            option: 'Profile',
            onTap: () {},
          ),
          buildDrawerTile(
            asset: AppImages.help,
            option: 'Help',
            onTap: () {},
          ),
          const Divider(),
          buildDrawerTile(
            asset: AppImages.logout,
            option: 'Cerrar Sesión',
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget buildDrawerTile({
    required String asset,
    required String option,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(
        asset,
        width: 20,
        height: 20,
        color: Colors.black,
      ),
      title: Text(option, style: AppStyles.label),
      onTap: onTap,
    );
  }
}

class SalesModuleHeader extends StatelessWidget {
  const SalesModuleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthProvider>(context, listen: false);
    final name = loginProvider.session!.nombre;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      AppImages.user,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Text('Hola $name', style: AppStyles.titleWhite),
            const Text('Bienvenido a tu panel de trabajo', style: AppStyles.subtitleWhite),
          ],
        ),
      ],
    );
  }
}

class SalesModuleCards extends StatelessWidget {
  final void Function(int) onCardTap;

  const SalesModuleCards({super.key, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCard('Dashboard', AppImages.barchart, null, () => onCardTap(0))),
            const SizedBox(width: 3),
            Expanded(child: _buildCard('Clientes', AppImages.customer, '0 Registros', () => onCardTap(1))),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildCard('Encomiendas', AppImages.courier, '0 Registros', () => onCardTap(2))),
            Expanded(child: _buildCard('Motorizados', AppImages.motorizado, '0 Registros', () => onCardTap(3))),
          ],
        )
      ],
    );
  }

  Widget _buildCard(
    String title,
    String assetPath, [
    String? subtitle,
    VoidCallback? onTap,
  ]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          height: 155,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                assetPath,
                width: 35,
                height: 35,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 35);
                },
              ),
              const SizedBox(height: 8),
              Text(title, style: AppStyles.title),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: AppStyles.label),
              ],
            ],
          ),
        ),
      ),
    );
  }
}