class DockingStation {
  final String id;
  final String name;
  final bool installed;
  final bool locked;
  final int nb_bikes;
  final int nb_empty_docks;
  final int nb_total_docks;
  final double lon;
  final double lat;

  DockingStation(
      this.id,
      this.name,
      this.installed,
      this.locked,
      this.nb_bikes,
      this.nb_empty_docks,
      this.nb_total_docks,
      this.lon,
      this.lat
      );
}