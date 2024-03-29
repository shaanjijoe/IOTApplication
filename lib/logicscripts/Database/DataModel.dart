import 'package:hive/hive.dart';
// part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel {

  //Concentration, Temperature, Pressure, Altitude, Humidity, Raining/Not Raining
  @HiveField(0)
  late DateTime timestamp;

  @HiveField(1)
  late double concentration;

  @HiveField(2)
  late double temperature;

  @HiveField(3)
  late double pressure;

  @HiveField(4)
  late double altitude;

  @HiveField(5)
  late double humidity;

  @HiveField(6)
  late bool rain;

  DataModel( this.altitude, this.concentration, this.humidity, this.pressure, this.rain, this.temperature, this.timestamp);
  // late
}


// import 'package:hive/hive.dart';
class DataModelAdapter extends TypeAdapter<DataModel> {
  @override
  final int typeId = 0;

  @override
  DataModel read(BinaryReader reader) {
    final timestampString = reader.readString();
    final concentration = reader.readDouble();
    final temperature = reader.readDouble();
    final pressure = reader.readDouble();
    final altitude = reader.readDouble();
    final humidity = reader.readDouble();
    final rain = reader.readBool();

    final timestamp = DateTime.parse(timestampString);

    return DataModel(
      altitude,
      concentration,
      humidity,
      pressure,
      rain,
      temperature,
      timestamp,
    );
  }

  @override
  void write(BinaryWriter writer, DataModel obj) {
    writer.writeString(obj.timestamp.toIso8601String());
    writer.writeDouble(obj.concentration);
    writer.writeDouble(obj.temperature);
    writer.writeDouble(obj.pressure);
    writer.writeDouble(obj.altitude);
    writer.writeDouble(obj.humidity);
    writer.writeBool(obj.rain);
  }
}
