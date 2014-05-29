package server.api.resource.config;

import server.api.parameter.MetaBeanParam;

import javax.ws.rs.BeanParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by Christoph on 16.03.14.
 */
@Path("/config/resources")
public class Resources {

    @GET
    @Produces("application/json")
    public String getResources(
            @BeanParam MetaBeanParam metaParam
    ) {


        return null;
    }
}
