import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'notifications_screen.dart';
import 'inscrire_enfant_screen.dart';
import 'suivi_enfant_screen.dart';
import 'rendez_vous_avenir_screen.dart';

class DashboardTuteurScreen extends StatefulWidget {
  final String userFullName;
  const DashboardTuteurScreen({Key? key, required this.userFullName}) : super(key: key);

  @override
  State<DashboardTuteurScreen> createState() => _DashboardTuteurScreenState();
}

class _DashboardTuteurScreenState extends State<DashboardTuteurScreen> {
  String currentPage = 'Accueil';

  void _onMenuSelected(String menuTitle) {
    setState(() {
      currentPage = menuTitle;
    });
    Navigator.pop(context); // Ferme le drawer
  }

  void _onLogout() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord Tuteur'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      drawer: Sidebar(
        userRole: 'tuteur',
        userName: widget.userFullName,
        onMenuSelected: _onMenuSelected,
        onLogout: _onLogout,
      ),
      body: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (currentPage) {
      case 'Inscrire un enfant':
        return const InscrireEnfantScreen();
      case "Suivi de l'enfant":
        return const SuiviEnfantScreen();
      case 'Rendez-vous à venir':
        return const RendezVousAvenirScreen();
      case 'Notifications':
        return NotificationsScreen(
          userRole: 'tuteur',
          userName: widget.userFullName,
        );
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Bienvenue, ${widget.userFullName} !',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Text(
            'Utilisez le menu latéral pour accéder aux différentes fonctionnalités.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page "$title" à implémenter',
        style: const TextStyle(fontSize: 20, color: Colors.grey),
      ),
    );
  }
} 