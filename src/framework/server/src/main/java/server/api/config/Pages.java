package server.api.config;

import server.parameter.MetaBeanParam;

import javax.ws.rs.BeanParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by Christoph on 16.03.14.
 */
@Path("/config/pages")
public class Pages {

    @GET
    @Produces("application/json")
    public String getPages(
            @BeanParam MetaBeanParam metaParam
    ) {


        return "";
    }
}
