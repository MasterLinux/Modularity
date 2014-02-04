part of lib.core;

class Module {
  String id;

  Module(this.id) {
  }

  Slot get printEvent {
    return new Slot((args) {
      //check whether all arguments are available
      var hasName = args.hasArgument("title");
      var hasHandler = args.hasArgument("handler");

      //if so execute handler
      if(hasName && hasHandler) {

        //get and cast arguments
        var handler = args["handler"] as Function;
        var title = args["title"] as String;

        //do crazy stuff
        handler(title);
      }
    });
  }

  Slot get printEventExpensive {
    return new Slot((args) {
      /*
      StringBuffer s = new StringBuffer();
      int n = 0;

      for(var i=0; i<100000000; i++) {
        n += i;
      }

      s.write(n);

      print((args["title"] as String) + " expensiv_" + "id" + " " + s.toString());
      */
    });
  }
}
