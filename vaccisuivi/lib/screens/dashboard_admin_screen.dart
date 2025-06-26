import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'notifications_screen.dart';
import 'gestion_enfants_screen.dart';
import 'rendez_vous_urgents_screen.dart';
import 'statistiques_screen.dart';
import 'gestion_utilisateurs_screen.dart';
import 'gestion_agents_screen.dart';
import 'gestion_parents_screen.dart';
import 'rapports_screen.dart';
import 'rapport_rendez_vous_screen.dart';

class DashboardAdminScreen extends StatefulWidget {
  final String userFullName;
  const DashboardAdminScreen({Key? key, required this.userFullName}) : super(key: key);

  @override
  State<DashboardAdminScreen> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
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
        title: const Text('Tableau de bord Administrateur'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      drawer: Sidebar(
        userRole: 'admin',
        userName: widget.userFullName,
        onMenuSelected: _onMenuSelected,
        onLogout: _onLogout,
      ),
      body: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (currentPage) {
      case 'Gestion des enfants':
        return const GestionEnfantsScreen();
      case 'Rendez-vous urgents':
        return const RendezVousUrgentsScreen();
      case 'Statistiques':
        return const StatistiquesScreen();
      case 'Gestion utilisateurs':
        return const GestionUtilisateursScreen();
      case 'Gestion agents':
        return const GestionAgentsScreen();
      case 'Gestion parents/tuteurs':
        return const GestionParentsScreen();
      case 'Rapports':
        return const RapportsScreen();
      case 'Rapport Rendez-vous':
        return const RapportRendezVousScreen();
      case 'Notifications':
        return NotificationsScreen(
          userRole: 'admin',
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