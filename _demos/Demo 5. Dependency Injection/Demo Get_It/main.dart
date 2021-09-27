import 'package:get_it/get_it.dart';


class Database {
  String get version => "database";
}

class TestDatabase extends Database {
  @override
  String get version => "in memory database";
}

void setupLocator() {
  GetIt.I.registerSingleton<Database>(Database());
}

void main() {
  setupLocator();

  Database db = GetIt.I.get<Database>();
  print(db.version);
}
