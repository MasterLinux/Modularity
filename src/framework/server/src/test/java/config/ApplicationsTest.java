package config;

import junit.framework.Assert;
import org.glassfish.grizzly.http.server.HttpServer;
import org.glassfish.jersey.grizzly2.httpserver.GrizzlyHttpServerFactory;
import org.glassfish.jersey.server.ResourceConfig;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import java.net.URI;

/**
 * Created by Christoph on 01.02.14.
 */
public class ApplicationsTest {
    private HttpServer server;
    private WebTarget target;

    @Before
    public void setUp() throws Exception {
        ResourceConfig rc = new PackagesResourceConfig("com.javarest.javarest2");
        server = GrizzlyHttpServerFactory.createHttpServer(URI.create("http://localhost:9090"));
        server.start();

        Client c = ClientBuilder.newClient();
        target = c.target("http://localhost:9090");
    }

    @After
    public void tearDown() throws Exception {
        server.shutdownNow();
    }

    /**
     * Test to see that the message "Got it!" is sent in the response.
     */
    @Test
    public void testGetIt() {
        String responseMsg = target.path("applications").request().get(String.class);
        Assert.assertEquals("Got it!", responseMsg);
    }
}
