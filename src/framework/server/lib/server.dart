library publicise.server;

import 'package:redstone/server.dart' as api;

part 'api/session.dart';

main() {
  var server = new Server();
  server.start();
}

class Server {
  Server() {
    //TODO configure server;
  }

  void start() {
    api.setupConsoleLog();
    api.start();
  }
}
