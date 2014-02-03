part of lib.core.event;

abstract class EventArgs {
  EventArgs() {
  }

  Object operator [](String name) {
    var mirror = reflect(this);

    try {
      var field = mirror.getField(new Symbol(name));

      if(field.hasReflectee) {
        return field.reflectee;
      }

    } catch(e) {
      print(e);
    }

    return null;
  }
}
