package server.api;

import org.glassfish.grizzly.http.server.HttpServer;
import org.glassfish.jersey.grizzly2.httpserver.GrizzlyHttpServerFactory;
import org.glassfish.jersey.server.ResourceConfig;
import org.junit.After;
import org.junit.Before;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import java.net.URI;

/**
 * Created by Christoph on 07.05.2014.
 */
public class BaseApiTest {
    private HttpServer server;
    private WebTarget target;

    @Before
    public void setUp() throws Exception {
        ResourceConfig rc = new ResourceConfig()
                .packages("server.api.resource")
                .packages("server.api.resource.config");

        server = GrizzlyHttpServerFactory.createHttpServer(URI.create("http://localhost:9090"), rc);
        server.start();

        Client c = ClientBuilder.newClient();
        target = c.target("http://localhost:9090");
    }

    @After
    public void tearDown() throws Exception {
        server.shutdownNow();
    }

    protected WebTarget getTarget() {
        return target;
    }
}
