import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/enfant.dart';
import 'fiche_enfant_screen.dart';

class RendezVousUrgentsScreen extends StatefulWidget {
  const RendezVousUrgentsScreen({Key? key}) : super(key: key);

  @override
  State<RendezVousUrgentsScreen> createState() => _RendezVousUrgentsScreenState();
}

class _RendezVousUrgentsScreenState extends State<RendezVousUrgentsScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _rendezVousUrgents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRendezVousUrgents();
  }

  Future<void> _loadRendezVousUrgents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation d'appel API pour les rendez-vous urgents
      // TODO: Remplacer par un vrai appel API quand l'endpoint sera créé
      await Future.delayed(Duration(seconds: 1));
      
      _rendezVousUrgents = _generateMockRendezVousUrgents();
      
    } catch (e) {
      print('Erreur lors du chargement des rendez-vous urgents: $e');
      _rendezVousUrgents = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateMockRendezVousUrgents() {
    final now = DateTime.now();
    return [
      {
        'id': '1',
        'enfant': {
          'id': 'enfant_1',
          'nom': 'Fatou Diop',
          'age': 2,
          'village': 'Thiès',
          'sexe': 'F',
        },
        'vaccin': 'DTC',
        'date_prevue': now.subtract(Duration(days: 5)),
        'retard': 5,
        'priorite': 'critique',
        'notes': 'Enfant en retard de 5 jours pour le vaccin DTC',
      },
      {
        'id': '2',
        'enfant': {
          'id': 'enfant_2',
          'nom': 'Moussa Sall',
          'age': 1,
          'village': 'Mbour',
          'sexe': 'M',
        },
        'vaccin': 'Rougeole',
        'date_prevue': now.subtract(Duration(days: 3)),
        'retard': 3,
        'priorite': 'elevee',
        'notes': 'Vaccin Rougeole en retard de 3 jours',
      },
      {
        'id': '3',
        'enfant': {
          'id': 'enfant_3',
          'nom': 'Aissatou Diallo',
          'age': 3,
          'village': 'Joal',
          'sexe': 'F',
        },
        'vaccin': 'Polio',
        'date_prevue': now.subtract(Duration(days: 2)),
        'retard': 2,
        'priorite': 'elevee',
        'notes': 'Vaccin Polio en retard de 2 jours',
      },
      {
        'id': '4',
        'enfant': {
          'id': 'enfant_4',
          'nom': 'Ibrahima Ba',
          'age': 4,
          'village': 'Ngaparou',
          'sexe': 'M',
        },
        'vaccin': 'Fièvre jaune',
        'date_prevue': now.subtract(Duration(days: 1)),
        'retard': 1,
        'priorite': 'moyenne',
        'notes': 'Vaccin Fièvre jaune en retard de 1 jour',
      },
    ];
  }

  Color _getPrioriteColor(String priorite) {
    switch (priorite) {
      case 'critique':
        return Colors.red;
      case 'elevee':
        return Colors.orange;
      case 'moyenne':
        return Colors.yellow[700]!;
      case 'basse':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getPrioriteText(String priorite) {
    switch (priorite) {
      case 'critique':
        return 'CRITIQUE';
      case 'elevee':
        return 'ÉLEVÉE';
      case 'moyenne':
        return 'MOYENNE';
      case 'basse':
        return 'BASSE';
      default:
        return 'NORMALE';
    }
  }

  Future<void> _marquerCommeTraite(Map<String, dynamic> rendezVous) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer le traitement'),
        content: Text('Marquer le rendez-vous de ${rendezVous['enfant']['nom']} comme traité ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Appel API pour marquer comme traité
      setState(() {
        _rendezVousUrgents.removeWhere((rdv) => rdv['id'] == rendezVous['id']);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rendez-vous de ${rendezVous['enfant']['nom']} marqué comme traité'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rendez-vous Urgents'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRendezVousUrgents,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rendezVousUrgents.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 64,
                        color: Colors.green,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Aucun rendez-vous urgent',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tous les rendez-vous sont à jour !',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRendezVousUrgents,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _rendezVousUrgents.length,
                    itemBuilder: (context, index) {
                      final rendezVous = _rendezVousUrgents[index];
                      return _buildRendezVousCard(rendezVous);
                    },
                  ),
                ),
    );
  }

  Widget _buildRendezVousCard(Map<String, dynamic> rendezVous) {
    final enfant = rendezVous['enfant'] as Map<String, dynamic>;
    final priorite = rendezVous['priorite'] as String;
    final retard = rendezVous['retard'] as int;
    final datePrevue = rendezVous['date_prevue'] as DateTime;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      color: _getPrioriteColor(priorite).withOpacity(0.1),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: enfant['sexe'] == 'M' ? Colors.blue : Colors.pink,
          child: Icon(
            enfant['sexe'] == 'M' ? Icons.boy : Icons.girl,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                enfant['nom'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPrioriteColor(priorite),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPrioriteText(priorite),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.vaccines, size: 16, color: Colors.black87),
                const SizedBox(width: 4),
                Text(
                  'Vaccin: ${rendezVous['vaccin']}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.black87),
                const SizedBox(width: 4),
                Text(
                  enfant['village'],
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  'Retard: $retard jour(s)',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.black87),
                const SizedBox(width: 4),
                Text(
                  'Prévu: ${DateFormat('dd/MM/yyyy').format(datePrevue)}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (rendezVous['notes'] != null && rendezVous['notes'].isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                rendezVous['notes'],
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                // TODO: Naviguer vers la fiche de l'enfant
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Voir la fiche de ${enfant['nom']}')),
                );
                break;
              case 'treat':
                _marquerCommeTraite(rendezVous);
                break;
              case 'call':
                // TODO: Implémenter l'appel
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Appeler ${enfant['nom']}')),
                );
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
                  Text('Voir fiche'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'treat',
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Marquer traité'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'call',
              child: Row(
                children: [
                  Icon(Icons.phone, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Appeler'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Naviguer vers la fiche de l'enfant
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Voir la fiche de ${enfant['nom']}')),
          );
        },
      ),
    );
  }
} 