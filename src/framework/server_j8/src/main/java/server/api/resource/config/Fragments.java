package server.api.resource.config;

import server.api.resource.BaseResource;
import server.api.parameter.MetaBeanParam;

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
