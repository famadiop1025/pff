import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String userRole;
  final String userName;
  final Function(String) onMenuSelected;
  final VoidCallback onLogout;

  const Sidebar({
    Key? key,
    required this.userRole,
    required this.userName,
    required this.onMenuSelected,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header avec infos utilisateur
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              _getRoleDisplayName(userRole),
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                _getRoleIcon(userRole),
                color: const Color(0xFF4CAF50),
                size: 40,
              ),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
            ),
          ),
          
          // Menus selon le rôle
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildMenuItems(),
            ),
          ),
          
          // Bouton de déconnexion
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Déconnexion',
                style: TextStyle(color: Colors.red),
              ),
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    switch (userRole) {
      case 'admin':
        return [
          _buildMenuItem('Gestion des utilisateurs', Icons.supervisor_account),
          _buildMenuItem('Gestion des agents', Icons.medical_services),
          _buildMenuItem('Gestion des parents/tuteurs', Icons.family_restroom),
          _buildMenuItem('Gestion des enfants', Icons.child_care),
          _buildMenuItem('Statistiques', Icons.bar_chart),
          _buildMenuItem('Rapports', Icons.assignment),
          _buildMenuItem('Rapport Rendez-vous', Icons.schedule),
          _buildMenuItem('Notifications', Icons.notifications),
        ];
      case 'agent':
        return [
          _buildMenuItem('Rendez-vous urgents', Icons.warning_amber_rounded),
          _buildMenuItem('Notifications', Icons.notifications_active),
          _buildMenuItem('Reporter un rendez-vous', Icons.schedule_send),
          _buildMenuItem('Rapports', Icons.assignment),
        ];
      case 'parent':
      case 'tuteur':
        return [
          _buildMenuItem('Inscrire un enfant', Icons.person_add),
          _buildMenuItem("Suivi de l'enfant", Icons.assignment_ind),
          _buildMenuItem('Rendez-vous à venir', Icons.event_available),
          _buildMenuItem('Notifications', Icons.notifications_active),
        ];
      default:
        return [
          _buildMenuItem('Accueil', Icons.home),
        ];
    }
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
      title: Text(title),
      onTap: () => onMenuSelected(title),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admin':
        return 'Administrateur';
      case 'agent':
        return 'Agent de santé';
      case 'parent':
        return 'Parent';
      case 'tuteur':
        return 'Tuteur';
      default:
        return 'Utilisateur';
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'agent':
        return Icons.medical_services;
      case 'parent':
      case 'tuteur':
        return Icons.family_restroom;
      default:
        return Icons.person;
    }
  }
} 