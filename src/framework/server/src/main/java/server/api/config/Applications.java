package server.api.config;

import server.BaseResource;
import server.model.config.ApplicationModel;
import server.parameter.MetaBeanParam;

import javax.ws.rs.BeanParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
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
            application.setName("application_" + i + "_" + metaParam.getEmbed());
            application.setId(i);

            objects.add(application);
        }

        return buildResponse(metaParam, objects);
    }
}
