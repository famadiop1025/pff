import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/enfant.dart';
import '../models/chat_message.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Headers pour les requêtes
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Gestion des erreurs
  void _handleError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception('Erreur API: ${response.statusCode} - ${response.body}');
    }
  }

  // Récupérer tous les enfants
  Future<List<Enfant>> getEnfants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enfants/'),
        headers: _headers,
      );
      
      _handleError(response);
      
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Enfant.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des enfants: $e');
      return [];
    }
  }

  // Récupérer un enfant par ID
  Future<Enfant?> getEnfant(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enfants/$id/'),
        headers: _headers,
      );
      
      _handleError(response);
      
      final data = json.decode(response.body);
      return Enfant.fromJson(data);
    } catch (e) {
      print('Erreur lors de la récupération de l\'enfant: $e');
      return null;
    }
  }

  // Créer un nouvel enfant
  Future<Enfant?> createEnfant(Map<String, dynamic> enfantData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/enfants/'),
        headers: _headers,
        body: json.encode(enfantData),
      );
      
      _handleError(response);
      
      final data = json.decode(response.body);
      return Enfant.fromJson(data);
    } catch (e) {
      print('Erreur lors de la création de l\'enfant: $e');
      return null;
    }
  }

  // Mettre à jour un enfant
  Future<Enfant?> updateEnfant(String id, Map<String, dynamic> enfantData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/enfants/$id/'),
        headers: _headers,
        body: json.encode(enfantData),
      );
      
      _handleError(response);
      
      final data = json.decode(response.body);
      return Enfant.fromJson(data);
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'enfant: $e');
      return null;
    }
  }

  // Supprimer un enfant
  Future<bool> deleteEnfant(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/enfants/$id/'),
        headers: _headers,
      );
      
      _handleError(response);
      return true;
    } catch (e) {
      print('Erreur lors de la suppression de l\'enfant: $e');
      return false;
    }
  }

  // Ajouter un vaccin à un enfant
  Future<bool> ajouterVaccin(String enfantId, Map<String, dynamic> vaccinData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/enfants/$enfantId/vaccins/'),
        headers: _headers,
        body: json.encode(vaccinData),
      );
      
      _handleError(response);
      return true;
    } catch (e) {
      print('Erreur lors de l\'ajout du vaccin: $e');
      return false;
    }
  }

  // Récupérer les statistiques
  Future<Map<String, dynamic>> getStatistiques() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/statistiques/'),
        headers: _headers,
      );
      
      _handleError(response);
      
      return json.decode(response.body);
    } catch (e) {
      print('Erreur lors de la récupération des statistiques: $e');
      return {
        'nombre_enfants': 0,
        'taux_couverture_global': 0.0,
        'prochains_rendez_vous': 0,
      };
    }
  }

  // Récupérer les villages
  Future<List<String>> getVillages() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/villages/'),
        headers: _headers,
      );
      
      _handleError(response);
      
      final List<dynamic> data = json.decode(response.body);
      return data.map((village) => village['nom'] as String).toList();
    } catch (e) {
      print('Erreur lors de la récupération des villages: $e');
      return [];
    }
  }

  // Filtrer les enfants par village
  Future<List<Enfant>> getEnfantsByVillage(String village) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enfants/?village=$village'),
        headers: _headers,
      );
      
      _handleError(response);
      
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Enfant.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors du filtrage par village: $e');
      return [];
    }
  }

  // Filtrer les enfants par statut vaccinal
  Future<List<Enfant>> getEnfantsByStatutVaccinal(String statut) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enfants/?statut=$statut'),
        headers: _headers,
      );
      
      _handleError(response);
      
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Enfant.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors du filtrage par statut: $e');
      return [];
    }
  }
} 