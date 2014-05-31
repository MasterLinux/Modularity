part of publicise.server;

@api.Group("/sessions")
class Session {

  @api.Route("/:id")
  String getSessions(String id) => "test";

  @api.Route("/?", methods: const [api.POST])
  String createSession(@api.Body(api.JSON) Map user) => "test2";

  @api.Route("/:id", methods: const [api.DELETE])
  String deleteSession() => "test3";
}