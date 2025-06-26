import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GestionParentsScreen extends StatefulWidget {
  const GestionParentsScreen({Key? key}) : super(key: key);

  @override
  State<GestionParentsScreen> createState() => _GestionParentsScreenState();
}

class _GestionParentsScreenState extends State<GestionParentsScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _parents = [];
  bool _isLoading = true;
  String _filtreRole = 'Tous';
  String _filtreVillage = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _roles = ['Tous', 'parent', 'tuteur'];
  final List<String> _villages = ['Tous', 'Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];

  @override
  void initState() {
    super.initState();
    _loadParents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadParents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API pour les parents/tuteurs
      // TODO: Remplacer par un vrai appel API quand l'endpoint sera créé
      await Future.delayed(Duration(seconds: 1));
      
      _parents = _generateMockParents();
      
    } catch (e) {
      print('Erreur lors du chargement des parents: $e');
      _parents = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockParents() {
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
        'telephone': '+221 77 123 45 67',
        'derniere_connexion': '2024-03-15 14:30',
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
        'telephone': '+221 76 234 56 78',
        'derniere_connexion': '2024-03-14 09:15',
      },
      {
        'id': '3',
        'username': 'mariama.ba',
        'full_name': 'Mariama Ba',
        'email': 'mariama.ba@email.com',
        'role': 'parent',
        'village': 'Ngaparou',
        'date_inscription': '2024-03-05',
        'statut': 'inactif',
        'enfants_count': 1,
        'telephone': '+221 77 345 67 89',
        'derniere_connexion': '2024-03-10 16:45',
      },
      {
        'id': '4',
        'username': 'ibrahim.traore',
        'full_name': 'Ibrahim Traore',
        'email': 'ibrahim.traore@email.com',
        'role': 'tuteur',
        'village': 'Joal',
        'date_inscription': '2024-02-10',
        'statut': 'actif',
        'enfants_count': 2,
        'telephone': '+221 76 456 78 90',
        'derniere_connexion': '2024-03-15 11:20',
      },
      {
        'id': '5',
        'username': 'aissatou.diallo',
        'full_name': 'Aissatou Diallo',
        'email': 'aissatou.diallo@email.com',
        'role': 'parent',
        'village': 'Popenguine',
        'date_inscription': '2024-01-25',
        'statut': 'actif',
        'enfants_count': 1,
        'telephone': '+221 77 567 89 01',
        'derniere_connexion': '2024-03-15 13:45',
      },
    ];
  }

  List<Map<String, dynamic>> _getParentsFiltres() {
    List<Map<String, dynamic>> parents = _parents;

    // Filtre par rôle
    if (_filtreRole != 'Tous') {
      parents = parents.where((parent) => parent['role'] == _filtreRole).toList();
    }

    // Filtre par village
    if (_filtreVillage != 'Tous') {
      parents = parents.where((parent) => parent['village'] == _filtreVillage).toList();
    }

    // Filtre par recherche
    if (_searchController.text.isNotEmpty) {
      parents = parents.where((parent) =>
          parent['full_name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          parent['username'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
          parent['email'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    return parents;
  }

  Color _getRoleColor(String role) {
    return role == 'tuteur' ? Colors.orange : Colors.green;
  }

  Color _getStatutColor(String statut) {
    return statut == 'actif' ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final parentsFiltres = _getParentsFiltres();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Parents/Tuteurs'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implémenter l'ajout de parent/tuteur
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité d\'ajout de parent/tuteur à implémenter'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadParents,
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
                hintText: 'Rechercher un parent/tuteur...',
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
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtreVillage,
                    decoration: InputDecoration(
                      labelText: 'Village',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _villages.map((village) {
                      return DropdownMenuItem(
                        value: village,
                        child: Text(village),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filtreVillage = value!;
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
                Icon(Icons.family_restroom, color: const Color(0xFF4CAF50), size: 16),
                const SizedBox(width: 8),
                Text(
                  '${parentsFiltres.length} parent(s)/tuteur(s) trouvé(s)',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Liste des parents/tuteurs
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : parentsFiltres.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.family_restroom_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Aucun parent/tuteur trouvé',
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
                        itemCount: parentsFiltres.length,
                        itemBuilder: (context, index) {
                          final parent = parentsFiltres[index];
                          return _buildParentCard(parent);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentCard(Map<String, dynamic> parent) {
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
                  backgroundColor: _getRoleColor(parent['role']),
                  child: Icon(
                    parent['role'] == 'tuteur' ? Icons.family_restroom : Icons.person,
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
                        parent['full_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${parent['username']} (${parent['role']})',
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
                    color: _getStatutColor(parent['statut']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getStatutColor(parent['statut'])),
                  ),
                  child: Text(
                    parent['statut'].toUpperCase(),
                    style: TextStyle(
                      color: _getStatutColor(parent['statut']),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Informations du parent/tuteur
            _buildInfoRow(Icons.email, 'Email', parent['email']),
            _buildInfoRow(Icons.phone, 'Téléphone', parent['telephone']),
            _buildInfoRow(Icons.location_on, 'Village', parent['village']),
            _buildInfoRow(Icons.calendar_today, 'Inscrit le', parent['date_inscription']),
            _buildInfoRow(Icons.child_care, 'Enfants', '${parent['enfants_count']} enfant(s)'),
            _buildInfoRow(Icons.access_time, 'Dernière connexion', parent['derniere_connexion']),

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
                          content: Text('Modification de ${parent['full_name']}'),
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
                      final newStatut = parent['statut'] == 'actif' ? 'inactif' : 'actif';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Statut de ${parent['full_name']} changé à $newStatut'),
                          backgroundColor: newStatut == 'actif' ? Colors.green : Colors.orange,
                        ),
                      );
                    },
                    icon: Icon(parent['statut'] == 'actif' ? Icons.block : Icons.check_circle),
                    label: Text(parent['statut'] == 'actif' ? 'Désactiver' : 'Activer'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: parent['statut'] == 'actif' ? Colors.red : Colors.green,
                      side: BorderSide(
                        color: parent['statut'] == 'actif' ? Colors.red : Colors.green,
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
} 