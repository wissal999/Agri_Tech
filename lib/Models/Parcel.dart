class Parcel {
  final int id;
  final String nom;
  final double surface;
  final int totaleImplantation;
  final bool etatArrosage;
  final bool typeArrosage;

  Parcel({required this.id, required this.nom, required this.surface, required this.totaleImplantation, required this.etatArrosage, required this.typeArrosage});
  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(
        id: json['id'],
        nom: json['nom'],
        surface: json['surface'],
        totaleImplantation: json['totaleImplantation'],
        etatArrosage: json['etatArrosage'],

        typeArrosage: json['typeArrosage'],
    );
  }

}
