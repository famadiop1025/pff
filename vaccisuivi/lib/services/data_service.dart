import 'dart:math';
import '../models/enfant.dart';
import '../models/chat_message.dart';
import 'api_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final ApiService _apiService = ApiService();

  // Cache local pour les données
  List<Enfant> _enfants = [];
  List<ChatMessage> _chatMessages = [];
  bool _isLoading = false;

  // Getters
  List<Enfant> get enfants => _enfants;
  List<ChatMessage> get chatMessages => _chatMessages;
  bool get isLoading => _isLoading;

  // Statistiques
  int get nombreEnfantsSuivis => _enfants.length;
  
  double get tauxCouvertureGlobal {
    if (_enfants.isEmpty) return 0.0;
    double total = _enfants.fold(0.0, (sum, enfant) => sum + enfant.tauxCouverture);
    return total / _enfants.length;
  }

  List<Enfant> get prochainsRendezVous {
    final now = DateTime.now();
    return _enfants
        .where((enfant) => enfant.prochainVaccin != null)
        .where((enfant) => enfant.prochainVaccin!.dateAdministration.isAfter(now))
        .toList()
      ..sort((a, b) => a.prochainVaccin!.dateAdministration.compareTo(b.prochainVaccin!.dateAdministration));
  }

  // Charger les enfants depuis l'API
  Future<void> loadEnfants() async {
    _isLoading = true;
    try {
      _enfants = await _apiService.getEnfants();
    } catch (e) {
      print('Erreur lors du chargement des enfants: $e');
      // En cas d'erreur, utiliser les données mock comme fallback
      _enfants = _generateMockEnfants();
    } finally {
      _isLoading = false;
    }
  }

  // Charger un enfant spécifique
  Future<Enfant?> loadEnfant(String id) async {
    try {
      return await _apiService.getEnfant(id);
    } catch (e) {
      print('Erreur lors du chargement de l\'enfant: $e');
      return _enfants.firstWhere((enfant) => enfant.id == id);
    }
  }

  // Filtres
  Future<List<Enfant>> getEnfantsByVillage(String village) async {
    try {
      return await _apiService.getEnfantsByVillage(village);
    } catch (e) {
      print('Erreur lors du filtrage par village: $e');
      return _enfants.where((enfant) => enfant.village == village).toList();
    }
  }

  Future<List<Enfant>> getEnfantsByStatutVaccinal(String statut) async {
    try {
      return await _apiService.getEnfantsByStatutVaccinal(statut);
    } catch (e) {
      print('Erreur lors du filtrage par statut: $e');
      return _enfants.where((enfant) {
        if (statut == 'complet') {
          return enfant.tauxCouverture >= 100;
        } else if (statut == 'partiel') {
          return enfant.tauxCouverture > 0 && enfant.tauxCouverture < 100;
        } else if (statut == 'non_vacciné') {
          return enfant.tauxCouverture == 0;
        }
        return true;
      }).toList();
    }
  }

  // Ajout d'enfant
  Future<bool> ajouterEnfant(Enfant enfant) async {
    try {
      final enfantData = {
        'nom': enfant.nom,
        'sexe': enfant.sexe,
        'village': enfant.village,
        'date_naissance': enfant.dateNaissance.toIso8601String(),
      };
      
      final nouvelEnfant = await _apiService.createEnfant(enfantData);
      if (nouvelEnfant != null) {
        _enfants.add(nouvelEnfant);
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'enfant: $e');
      // Fallback local
      _enfants.add(enfant);
      return true;
    }
  }

  // Ajout de vaccin
  Future<bool> ajouterVaccin(String enfantId, Vaccin vaccin) async {
    try {
      final vaccinData = {
        'nom': vaccin.nom,
        'date_administration': vaccin.dateAdministration.toIso8601String(),
        'statut': vaccin.statut,
        'notes': vaccin.notes,
      };
      
      final success = await _apiService.ajouterVaccin(enfantId, vaccinData);
      if (success) {
        // Mettre à jour le cache local
        final index = _enfants.indexWhere((e) => e.id == enfantId);
        if (index != -1) {
          final enfant = _enfants[index];
          final nouveauxVaccins = List<Vaccin>.from(enfant.historiqueVaccins)..add(vaccin);
          _enfants[index] = Enfant(
            id: enfant.id,
            nom: enfant.nom,
            sexe: enfant.sexe,
            village: enfant.village,
            dateNaissance: enfant.dateNaissance,
            lieuNaissance: enfant.lieuNaissance,
            groupeSanguin: enfant.groupeSanguin,
            allergies: enfant.allergies,
            antecedentsMedicaux: enfant.antecedentsMedicaux,
            historiqueVaccins: nouveauxVaccins,
            prochainVaccin: enfant.prochainVaccin,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de l\'ajout du vaccin: $e');
      // Fallback local
      final index = _enfants.indexWhere((e) => e.id == enfantId);
      if (index != -1) {
        final enfant = _enfants[index];
        final nouveauxVaccins = List<Vaccin>.from(enfant.historiqueVaccins)..add(vaccin);
        _enfants[index] = Enfant(
          id: enfant.id,
          nom: enfant.nom,
          sexe: enfant.sexe,
          village: enfant.village,
          dateNaissance: enfant.dateNaissance,
          lieuNaissance: enfant.lieuNaissance,
          groupeSanguin: enfant.groupeSanguin,
          allergies: enfant.allergies,
          antecedentsMedicaux: enfant.antecedentsMedicaux,
          historiqueVaccins: nouveauxVaccins,
          prochainVaccin: enfant.prochainVaccin,
        );
      }
      return true;
    }
  }

  // Récupérer les villages
  Future<List<String>> getVillages() async {
    try {
      return await _apiService.getVillages();
    } catch (e) {
      print('Erreur lors de la récupération des villages: $e');
      return ['Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];
    }
  }

  // Récupérer les statistiques
  Future<Map<String, dynamic>> getStatistiques() async {
    try {
      return await _apiService.getStatistiques();
    } catch (e) {
      print('Erreur lors de la récupération des statistiques: $e');
      return {
        'nombre_enfants': _enfants.length,
        'taux_couverture_global': tauxCouvertureGlobal,
        'prochains_rendez_vous': prochainsRendezVous.length,
      };
    }
  }

  // Chat
  void ajouterMessageChat(ChatMessage message) {
    _chatMessages.add(message);
  }

  String getReponseChatbot(String message) {
    final messageLower = message.toLowerCase();
    
    if (messageLower.contains('vaccin') && messageLower.contains('obligatoire')) {
      return 'Les vaccins obligatoires au Sénégal sont : BCG, DTC, Polio, Rougeole, Fièvre jaune, et Hépatite B.';
    } else if (messageLower.contains('ajouter') && messageLower.contains('enfant')) {
      return 'Pour ajouter un nouvel enfant, allez dans la section "Ajouter enfant" et remplissez le formulaire avec le nom, sexe, village et date de naissance.';
    } else if (messageLower.contains('prochain') && messageLower.contains('vaccin')) {
      return 'Le prochain vaccin sera affiché dans la fiche de l\'enfant concerné. Vous pouvez aussi consulter la liste des rendez-vous dans le tableau de bord.';
    } else if (messageLower.contains('bonjour') || messageLower.contains('salut')) {
      return 'Bonjour ! Je suis votre assistant pour le suivi de vaccination. Comment puis-je vous aider ?';
    } else if (messageLower.contains('merci')) {
      return 'Je vous en prie ! N\'hésitez pas si vous avez d\'autres questions.';
    } else {
      return 'Je ne comprends pas votre question. Essayez de demander sur les vaccins obligatoires, comment ajouter un enfant, ou les prochains vaccins.';
    }
  }

  // Génération des données mock (fallback)
  List<Enfant> _generateMockEnfants() {
    final villages = ['Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine'];
    final noms = [
      'Fatou Diop', 'Moussa Sall', 'Aissatou Diallo', 'Ibrahima Ba', 'Mariama Sow',
      'Ousmane Ndiaye', 'Aminata Fall', 'Mamadou Diagne', 'Fatima Mbaye', 'Abdou Thiam'
    ];
    
    return List.generate(15, (index) {
      final random = Random();
      final nom = noms[index % noms.length] + ' ${index + 1}';
      final village = villages[random.nextInt(villages.length)];
      final dateNaissance = DateTime.now().subtract(Duration(days: random.nextInt(365 * 5)));
      
      // Générer des vaccins aléatoires
      final vaccins = _generateMockVaccins(random);
      
      return Enfant(
        id: 'enfant_$index',
        nom: nom,
        sexe: random.nextBool() ? 'M' : 'F',
        village: village,
        dateNaissance: dateNaissance,
        lieuNaissance: village,
        groupeSanguin: 'A+',
        allergies: '',
        antecedentsMedicaux: '',
        historiqueVaccins: vaccins,
        prochainVaccin: _generateProchainVaccin(random),
      );
    });
  }

  List<Vaccin> _generateMockVaccins(Random random) {
    final vaccinsDisponibles = [
      'BCG', 'DTC', 'Polio', 'Rougeole', 'Fièvre jaune', 'Hépatite B',
      'ROR', 'Pneumocoque', 'Rotavirus', 'Méningite'
    ];
    
    final nombreVaccins = random.nextInt(8) + 2; // 2 à 9 vaccins
    final vaccins = <Vaccin>[];
    
    for (int i = 0; i < nombreVaccins; i++) {
      final vaccin = Vaccin(
        id: 'vaccin_$i',
        nom: vaccinsDisponibles[random.nextInt(vaccinsDisponibles.length)],
        dateAdministration: DateTime.now().subtract(Duration(days: random.nextInt(365))),
        statut: 'reçu',
        lieu: 'Centre de santé de ${_generateMockEnfants()[i].village}',
        notes: random.nextBool() ? 'Administré sans problème' : null,
      );
      vaccins.add(vaccin);
    }
    
    return vaccins;
  }

  Vaccin? _generateProchainVaccin(Random random) {
    if (random.nextBool()) {
      return Vaccin(
        id: 'prochain_${random.nextInt(1000)}',
        nom: 'DTC',
        dateAdministration: DateTime.now().add(Duration(days: random.nextInt(30) + 7)),
        statut: 'en_attente',
        lieu: 'Centre de santé de ${_generateMockEnfants()[random.nextInt(15)].village}',
      );
    }
    return null;
  }

  // Initialisation (maintenant asynchrone)
  Future<void> initialize() async {
    _chatMessages = _generateMockChatMessages();
    await loadEnfants();
  }

  List<ChatMessage> _generateMockChatMessages() {
    return [
      ChatMessage(
        id: '1',
        message: 'Bonjour ! Je suis votre assistant pour le suivi de vaccination. Comment puis-je vous aider ?',
        type: MessageType.bot,
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      ),
    ];
  }
} 