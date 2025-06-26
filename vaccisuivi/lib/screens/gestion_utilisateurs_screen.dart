import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GestionUtilisateursScreen extends StatefulWidget {
  const GestionUtilisateursScreen({Key? key}) : super(key: key);

  @override
  State<GestionUtilisateursScreen> createState() => _GestionUtilisateursScreenState();
}

class _GestionUtilisateursScreenState extends State<GestionUtilisateursScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _utilisateurs = [];
  bool _isLoading = true;
  String _filtreRole = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _roles = ['Tous', 'parent', 'tuteur', 'agent', 'admin'];

  @override
  void initState() {
    super.initState();
    _loadUtilisateurs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUtilisateurs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API pour les utilisateurs
      // TODO: Remplacer par un vrai appel API quand l'endpoint sera créé
      await Future.delayed(Duration(seconds: 1));
      
      _utilisateurs = _generateMockUtilisateurs();
      
    } catch (e) {
      print('Erreur lors du chargement des utilisateurs: $e');
      _utilisateurs = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockUtilisateurs() {
    return [
      {
        'id': '1',
        'username': 'fatou.diop',
        'full_name': 'Fatou Diop',
        'email': 'fatou.diop@email.com',
        'role': 'parent',
        'village': 'Thiès',
        'date_inscription': '2024-01-15',
        'statut': 'actif',
        'enfants_count': 2,
      },
      {
        'id': '2',
        'username': 'moussa.sall',
        'full_name': 'Moussa Sall',
        'email': 'moussa.sall@email.com',
        'role': 'tuteur',
        'village': 'Mbour',
        'date_inscription': '2024-02-20',
        'statut': 'actif',
        'enfants_count': 3,
      },
      {
        'id': '3',
        'username': 'aissatou.diallo',
        'full_name': 'Aissatou Diallo',
        'email': 'aissatou.diallo@email.com',
        'role': 'agent',
        'village': 'Joal',
        'date_inscription': '2024-01-10',
        'statut': 'actif',
        'enfants_count': 0,
      },
      {
        'id': '4',
        'username': 'admin',
        'full_name': 'Administrateur',
        'email': 'admin@vaccisuivi.sn',
        'role': 'admin',
        'village': 'Tous',
        'date_inscription': '2024-01-01',
        'statut': 'actif',
        'enfants_count': 0,
      },
      {
        'id': '5',
        'username': 'mariama.ba',
        'full_name': 'Mariama Ba',
        'email': 'mariama.ba@email.com',
        'role': 'parent',
        'village': 'Ngaparou',
        'date_inscription': '2024-03-05',
        'statut': 'inactif',
        'enfants_count': 1,
      },
    ];
  }

  List<Map<String, dynamic>> _getUtilisateursFiltres() {
    List<Map<String, dynamic>> utilisateurs = _utilisateurs;

    // Filtre par rôle
    if (_filtreRole != 'Tous') {
      utilisateurs = utilisateurs.where((user) => user['role'] == _filtreRole).toList();
    }

    // Filtre par recherche
    if (_searchController.text.isNotEmpty) {
      utilisateurs = utilisateurs.where((user) =>
          user['full_name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          user['username'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          user['email'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    return utilisateurs;
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'agent':
        return Colors.blue;
      case 'tuteur':
        return Colors.orange;
      case 'parent':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatutColor(String statut) {
    return statut == 'actif' ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final utilisateursFiltres = _getUtilisateursFiltres();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implémenter l'ajout d'utilisateur
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité d\'ajout d\'utilisateur à implémenter'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUtilisateurs,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF4CAF50),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Rechercher un utilisateur...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtreRole,
                    decoration: InputDecoration(
                      labelText: 'Rôle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role == 'Tous' ? 'Tous les rôles' : role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filtreRole = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Statistiques
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFE8F5E8),
            child: Row(
              children: [
                Icon(Icons.people, color: const Color(0xFF4CAF50), size: 16),
                const SizedBox(width: 8),
                Text(
                  '${utilisateursFiltres.length} utilisateur(s) trouvé(s)',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Liste des utilisateurs
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : utilisateursFiltres.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun utilisateur trouvé',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: utilisateursFiltres.length,
                        itemBuilder: (context, index) {
                          final utilisateur = utilisateursFiltres[index];
                          return _buildUtilisateurCard(utilisateur);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilisateurCard(Map<String, dynamic> utilisateur) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec nom et statut
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: _getRoleColor(utilisateur['role']),
                  child: Icon(
                    _getRoleIcon(utilisateur['role']),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        utilisateur['full_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${utilisateur['username']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatutColor(utilisateur['statut']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatutColor(utilisateur['statut'])),
                  ),
                  child: Text(
                    utilisateur['statut'].toUpperCase(),
                    style: TextStyle(
                      color: _getStatutColor(utilisateur['statut']),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Informations de l'utilisateur
            _buildInfoRow(Icons.email, 'Email', utilisateur['email']),
            _buildInfoRow(Icons.location_on, 'Village', utilisateur['village']),
            _buildInfoRow(Icons.calendar_today, 'Inscrit le', utilisateur['date_inscription']),
            _buildInfoRow(Icons.child_care, 'Enfants', '${utilisateur['enfants_count']} enfant(s)'),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter la modification
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Modification de ${utilisateur['full_name']}'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implémenter la désactivation/activation
                      final newStatut = utilisateur['statut'] == 'actif' ? 'inactif' : 'actif';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Statut de ${utilisateur['full_name']} changé à $newStatut'),
                          backgroundColor: newStatut == 'actif' ? Colors.green : Colors.orange,
                        ),
                      );
                    },
                    icon: Icon(utilisateur['statut'] == 'actif' ? Icons.block : Icons.check_circle),
                    label: Text(utilisateur['statut'] == 'actif' ? 'Désactiver' : 'Activer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: utilisateur['statut'] == 'actif' ? Colors.red : Colors.green,
                      side: BorderSide(
                        color: utilisateur['statut'] == 'actif' ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'agent':
        return Icons.medical_services;
      case 'tuteur':
        return Icons.family_restroom;
      case 'parent':
        return Icons.person;
      default:
        return Icons.person;
    }
  }
} 