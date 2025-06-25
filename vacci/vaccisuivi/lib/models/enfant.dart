import 'package:json_annotation/json_annotation.dart';

part 'enfant.g.dart';

@JsonSerializable()
class Enfant {
  final String id;
  final String nom;
  final String sexe;
  final String village;
  @JsonKey(name: 'date_naissance')
  final DateTime dateNaissance;
  @JsonKey(name: 'historique_vaccins')
  final List<Vaccin> historiqueVaccins;
  @JsonKey(name: 'prochain_vaccin')
  final Vaccin? prochainVaccin;

  Enfant({
    required this.id,
    required this.nom,
    required this.sexe,
    required this.village,
    required this.dateNaissance,
    required this.historiqueVaccins,
    this.prochainVaccin,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateNaissance.year;
    if (now.month < dateNaissance.month || 
        (now.month == dateNaissance.month && now.day < dateNaissance.day)) {
      age--;
    }
    return age;
  }

  double get tauxCouverture {
    if (historiqueVaccins.isEmpty) return 0.0;
    return (historiqueVaccins.length / 12) * 100; // 12 vaccins recommandés
  }

  Map<String, dynamic> toJson() => _$EnfantToJson(this);

  factory Enfant.fromJson(Map<String, dynamic> json) => _$EnfantFromJson(json);
}

@JsonSerializable()
class Vaccin {
  final String id;
  final String nom;
  @JsonKey(name: 'date_administration')
  final DateTime dateAdministration;
  final String statut; // 'reçu', 'en_attente', 'retard'
  final String? notes;

  Vaccin({
    required this.id,
    required this.nom,
    required this.dateAdministration,
    required this.statut,
    this.notes,
  });

  Map<String, dynamic> toJson() => _$VaccinToJson(this);

  factory Vaccin.fromJson(Map<String, dynamic> json) => _$VaccinFromJson(json);
} 