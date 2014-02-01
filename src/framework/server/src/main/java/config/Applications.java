package config;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by Christoph on 01.02.14.
 */
@Path("/applications")
public class Applications {

    @GET
    @Produces("application/json")
    public String getApplications() {
        return "lol";
    }
}
