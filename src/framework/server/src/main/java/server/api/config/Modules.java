package server.api.config;

import server.parameter.MetaBeanParam;

import javax.ws.rs.BeanParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by Christoph on 16.03.14.
 */
@Path("/config/modules")
public class Modules {

    @GET
    @Produces("application/json")
    public String getModules(
            @BeanParam MetaBeanParam metaParam
    ) {


        return null;
    }

}
