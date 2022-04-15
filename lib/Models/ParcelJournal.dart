class ParcelJournal{
  final int id;
  final String nom;
  final double surface;
  final int totaleImplantation;
  final bool etatArrosage;
  final bool typeArrosage;

  final String date;
  final double temperature;
  final double humidite;
  final double humidite_sol;

  ParcelJournal(this.id, this.nom, this.surface, this.totaleImplantation, this.etatArrosage, this.typeArrosage, this.date, this.temperature, this.humidite, this.humidite_sol);



}