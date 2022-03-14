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

  DockingStation(this.id, this.name, this.installed, this.locked, this.nb_bikes,
      this.nb_empty_docks, this.nb_total_docks, this.lon, this.lat);

  /**
   * An empty constructor useful for initialisations
   */
  DockingStation.empty()
      : id = "empty",
        name = "empty",
        installed = false,
        locked = true,
        nb_bikes = 0,
        nb_empty_docks = 0,
        nb_total_docks = 0,
        lon = 0.0,
        lat = 0.0;
}
