package server;

import org.glassfish.grizzly.http.server.HttpServer;
import org.glassfish.jersey.grizzly2.httpserver.GrizzlyHttpServerFactory;
import org.glassfish.jersey.server.ResourceConfig;

import java.io.IOException;
import java.net.URI;

/**
 * Created by Christoph on 01.02.14.
 */
public class Server {
    private final HttpServer server;
    private URI uri;

    /**
     * Initializes the server
     * @param uri The URI of the server
     */
    public Server(URI uri) {
        this.uri = uri;

        //create server
        server = GrizzlyHttpServerFactory.createHttpServer(
                this.uri,
                new ResourceConfig()
                        .packages("server.api.config")
        );
    }

    /**
     * Gets the base URI of the server
     * @return
     */
    public URI getUri() {
        return uri;
    }

    /**
     * Starts the server
     * @throws IOException
     */
    public void start() throws IOException {
        server.start();
    }

    /**
     * Stops the server
     */
    public void stop() {
        if(!server.isStarted()) return;
        server.shutdownNow();
    }
}
