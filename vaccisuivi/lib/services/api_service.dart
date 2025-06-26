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

  // Authentification - Connexion
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: _headers,
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'role': data['role'],
          'full_name': data['full_name'],
        };
      } else {
        return {
          'success': false,
          'message': 'Nom d\'utilisateur ou mot de passe incorrect',
        };
      }
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur',
      };
    }
  }

  // Authentification - Inscription
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: _headers,
        body: json.encode(userData),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Inscription réussie',
          'user': data,
        };
      } else {
        final errorData = json.decode(response.body);
        String errorMessage = 'Erreur lors de l\'inscription';
        
        if (errorData.containsKey('username')) {
          errorMessage = 'Ce nom d\'utilisateur existe déjà';
        } else if (errorData.containsKey('email')) {
          errorMessage = 'Cet email existe déjà';
        } else if (errorData.containsKey('password')) {
          errorMessage = 'Le mot de passe ne respecte pas les critères';
        }
        
        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion au serveur',
      };
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isAuthenticated() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify/'),
        headers: _headers,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la vérification d\'authentification: $e');
      return false;
    }
  }

  // Déconnexion
  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout/'),
        headers: _headers,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      return false;
    }
  }
} 