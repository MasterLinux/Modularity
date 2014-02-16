package server.api.config;

import server.BaseResource;
import server.model.config.ApplicationModel;
import server.parameter.MetaBeanParam;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import server.model.ResponseModel;
import server.util.ResponseBuilder;

import javax.ws.rs.BeanParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import java.util.ArrayList;

/**
 * Created by Christoph on 01.02.14.
 */
@Path("/applications")
public class Applications extends BaseResource {

    @GET
    @Produces("application/json")
    public String getApplications(
            @BeanParam MetaBeanParam metaParam
    ) {
        ArrayList<ApplicationModel> objects = new ArrayList<ApplicationModel>();

        ApplicationModel application;
        for(int i=0; i<60; i++) {
            application = new ApplicationModel();
            application.setName("application_" + i);
            application.setId(i);

            objects.add(application);
        }

        return buildResponse(metaParam, objects);
    }
}
