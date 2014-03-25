package server.api.config;

import server.BaseResource;
import server.data.dao.ApplicationsDAO;
import server.parameter.MetaBeanParam;

import javax.ws.rs.BeanParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * Created by Christoph on 01.02.14.
 */
@Path("/config/applications")
public class Applications extends BaseResource {

    @GET
    @Produces("application/json")
    public String getApplications(
            @BeanParam MetaBeanParam metaParam
    ) {
        return buildResponse(metaParam, ApplicationsDAO.getInstance().get(0)); //TODO ID needs to be dynamically
    }
}
