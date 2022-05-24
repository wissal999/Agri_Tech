class Farm{
  final int id;
  final String nomFerme;
  final String lieuFerme;


  Farm({required this.id,required this.nomFerme,required this.lieuFerme});

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      nomFerme: json['nom'],
      lieuFerme: json['lieu']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "nomFerme": nomFerme,
      "lieuFerme":lieuFerme
    };
  }
}