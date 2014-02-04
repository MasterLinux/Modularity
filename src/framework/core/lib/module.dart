part of lib.core;

class Module {
  String id;

  Module(this.id) {
  }

  Slot get printEvent {
    return new Slot((args) {
      print((args["text"] as String) + " lol");
    });
  }

  Slot get printEventExpensive {
    return new Slot((args) {
      StringBuffer s = new StringBuffer();
      int n = 0;

      for(var i=0; i<100000000; i++) {
        n += i;
      }

      s.write(n);

      print((args["text"] as String) + " expensiv_" + "id" + " " + s.toString());
    });
  }
}
