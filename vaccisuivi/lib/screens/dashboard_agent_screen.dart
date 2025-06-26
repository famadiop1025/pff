import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'rendez_vous_urgents_screen.dart';
import 'notifications_screen.dart';

class DashboardAgentScreen extends StatefulWidget {
  final String userFullName;
  const DashboardAgentScreen({Key? key, required this.userFullName}) : super(key: key);

  @override
  State<DashboardAgentScreen> createState() => _DashboardAgentScreenState();
}

class _DashboardAgentScreenState extends State<DashboardAgentScreen> {
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
        title: const Text('Tableau de bord Agent de santé'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      drawer: Sidebar(
        userRole: 'agent',
        userName: widget.userFullName,
        onMenuSelected: _onMenuSelected,
        onLogout: _onLogout,
      ),
      body: _buildCurrentPage(),
    );
  }

  Widget _buildCurrentPage() {
    switch (currentPage) {
      case 'Rendez-vous urgents':
        return const RendezVousUrgentsScreen();
      case 'Notifications':
        return NotificationsScreen(
          userRole: 'agent',
          userName: widget.userFullName,
        );
      case 'Reporter un rendez-vous':
        return const PlaceholderScreen(title: 'Reporter un rendez-vous');
      case 'Rapports':
        return const PlaceholderScreen(title: 'Rapports');
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