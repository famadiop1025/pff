import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/enfant.dart';
import 'fiche_enfant_screen.dart';
import 'ajouter_enfant_screen.dart';

class GestionEnfantsScreen extends StatefulWidget {
  const GestionEnfantsScreen({Key? key}) : super(key: key);

  @override
  State<GestionEnfantsScreen> createState() => _GestionEnfantsScreenState();
}

class _GestionEnfantsScreenState extends State<GestionEnfantsScreen> {
  final ApiService _apiService = ApiService();
  List<Enfant> _enfants = [];
  List<Enfant> _enfantsFiltres = [];
  bool _isLoading = true;
  String _filtreVillage = 'Tous';
  String _filtreStatut = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _villages = ['Tous', 'Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];
  final List<String> _statuts = ['Tous', 'complet', 'partiel', 'non_vacciné'];

  @override
  void initState() {
    super.initState();
    _loadEnfants();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEnfants() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _enfants = await _apiService.getEnfants();
      _appliquerFiltres();
    } catch (e) {
      print('Erreur lors du chargement des enfants: $e');
      _enfants = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _appliquerFiltres() {
    List<Enfant> enfants = _enfants;

    // Filtre par village
    if (_filtreVillage != 'Tous') {
      enfants = enfants.where((enfant) => enfant.village == _filtreVillage).toList();
    }

    // Filtre par statut vaccinal
    if (_filtreStatut != 'Tous') {
      enfants = enfants.where((enfant) {
        if (_filtreStatut == 'complet') {
          return enfant.tauxCouverture >= 100;
        } else if (_filtreStatut == 'partiel') {
          return enfant.tauxCouverture > 0 && enfant.tauxCouverture < 100;
        } else if (_filtreStatut == 'non_vacciné') {
          return enfant.tauxCouverture == 0;
        }
        return true;
      }).toList();
    }

    // Filtre par recherche
    if (_searchController.text.isNotEmpty) {
      enfants = enfants.where((enfant) =>
          enfant.nom.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          enfant.village.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    setState(() {
      _enfantsFiltres = enfants;
    });
  }

  Future<void> _supprimerEnfant(Enfant enfant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${enfant.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _apiService.deleteEnfant(enfant.id);
        if (success) {
          setState(() {
            _enfants.removeWhere((e) => e.id == enfant.id);
            _appliquerFiltres();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${enfant.nom} a été supprimé')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la suppression')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Enfants'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEnfants,
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
              onChanged: (value) => _appliquerFiltres(),
              decoration: InputDecoration(
                hintText: 'Rechercher un enfant...',
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
                      _appliquerFiltres();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _filtreStatut,
                    decoration: InputDecoration(
                      labelText: 'Statut',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _statuts.map((statut) {
                      return DropdownMenuItem(
                        value: statut,
                        child: Text(statut == 'non_vacciné' ? 'Non vacciné' : statut),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filtreStatut = value!;
                      });
                      _appliquerFiltres();
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
                Icon(Icons.info, color: const Color(0xFF4CAF50), size: 16),
                const SizedBox(width: 8),
                Text(
                  '${_enfantsFiltres.length} enfant(s) trouvé(s) sur ${_enfants.length} total',
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Liste des enfants
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _enfantsFiltres.isEmpty
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
                              'Aucun enfant trouvé',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadEnfants,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _enfantsFiltres.length,
                          itemBuilder: (context, index) {
                            final enfant = _enfantsFiltres[index];
                            return _buildEnfantCard(enfant);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AjouterEnfantScreen(),
            ),
          );
          if (result == true) {
            _loadEnfants();
          }
        },
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEnfantCard(Enfant enfant) {
    Color statusColor;
    String statusText;
    
    if (enfant.tauxCouverture >= 100) {
      statusColor = Colors.green;
      statusText = 'Complet';
    } else if (enfant.tauxCouverture > 0) {
      statusColor = Colors.orange;
      statusText = 'Partiel';
    } else {
      statusColor = Colors.red;
      statusText = 'Non vacciné';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: enfant.sexe == 'M' ? Colors.blue : Colors.pink,
          child: Icon(
            enfant.sexe == 'M' ? Icons.boy : Icons.girl,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          enfant.nom,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  enfant.village,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.cake, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${enfant.age} ans',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.vaccines, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${enfant.historiqueVaccins.length} vaccins reçus',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FicheEnfantScreen(enfant: enfant),
                  ),
                );
                break;
              case 'edit':
                // TODO: Implémenter l'édition
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fonctionnalité d\'édition à venir')),
                );
                break;
              case 'delete':
                _supprimerEnfant(enfant);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Voir'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Modifier'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Supprimer'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FicheEnfantScreen(enfant: enfant),
            ),
          );
        },
      ),
    );
  }
} 