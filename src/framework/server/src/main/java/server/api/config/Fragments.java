package server.api.config;

import server.BaseResource;
import server.parameter.MetaBeanParam;

import javax.ws.rs.BeanParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by Christoph on 16.03.14.
 */
@Path("/config/fragments")
public class Fragments extends BaseResource {

    @GET
    @Produces("application/json")
    public String getFragments(
            @BeanParam MetaBeanParam metaParam
    ) {


        return null;
    }
}
