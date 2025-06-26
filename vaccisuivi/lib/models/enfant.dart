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
  @JsonKey(name: 'lieu_naissance')
  final String lieuNaissance;
  @JsonKey(name: 'groupe_sanguin')
  final String groupeSanguin;
  final String allergies;
  @JsonKey(name: 'antecedents_medicaux')
  final String antecedentsMedicaux;
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
    required this.lieuNaissance,
    required this.groupeSanguin,
    required this.allergies,
    required this.antecedentsMedicaux,
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

  factory Enfant.fromJson(Map<String, dynamic> json) {
    return Enfant(
      id: json['id'].toString(),
      nom: json['nom'].toString(),
      sexe: json['sexe'].toString(),
      village: json['village'].toString(),
      dateNaissance: DateTime.parse(json['date_naissance'].toString()),
      lieuNaissance: json['lieu_naissance']?.toString() ?? 'Non spécifié',
      groupeSanguin: json['groupe_sanguin']?.toString() ?? 'Non spécifié',
      allergies: json['allergies']?.toString() ?? '',
      antecedentsMedicaux: json['antecedents_medicaux']?.toString() ?? '',
      historiqueVaccins: (json['historique_vaccins'] as List<dynamic>?)
          ?.map((e) => Vaccin.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      prochainVaccin: json['prochain_vaccin'] == null
          ? null
          : Vaccin.fromJson(json['prochain_vaccin'] as Map<String, dynamic>),
    );
  }
}

@JsonSerializable()
class Vaccin {
  final String id;
  final String nom;
  @JsonKey(name: 'date_administration')
  final DateTime dateAdministration;
  final String statut; // 'reçu', 'en_attente', 'retard'
  final String? notes;
  final String? lieu;

  Vaccin({
    required this.id,
    required this.nom,
    required this.dateAdministration,
    required this.statut,
    this.notes,
    this.lieu,
  });

  Map<String, dynamic> toJson() => _$VaccinToJson(this);

  factory Vaccin.fromJson(Map<String, dynamic> json) => _$VaccinFromJson(json);
} 