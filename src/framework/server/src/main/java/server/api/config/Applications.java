package server.api.config;

import com.google.gson.Gson;
import server.BaseResource;
import server.data.dao.ApplicationsDAO;
import server.model.config.ApplicationModel;
import server.parameter.MetaBeanParam;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;


/**
 * Created by Christoph on 01.02.14.
 */
@Path("/config/applications")
public class Applications extends BaseResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/{id: [0-9]+}")
    public String getApplicationById(
            @PathParam("id") int id,
            @BeanParam MetaBeanParam metaParam
    ) {
        return buildResponse(metaParam, ApplicationsDAO.getInstance().getById(id)); //TODO ID needs to be dynamically
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String getApplications(
            @BeanParam MetaBeanParam metaParam
    ) {
        return buildResponse(metaParam, ApplicationsDAO.getInstance().getById(-1)); //TODO use another method
    }

    /**
     * Adds a new application into the database
     * @param id Authentication token of the user who owns the application
     * @param body JSON which contains all information of the application to add
     *             <code>
     *             {
     *                  "name": "application_name",
     *                  "version": "1.0.0a",
     *                  "startUri": "page_uri",
     *                  "language": "de-DE"
     *             }
     *             </code>
     */
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public void addApplication(
            @HeaderParam("X-AUTH-TOKEN") @DefaultValue("-1") int id,
            String body
    ) {
        ApplicationModel application = new Gson().fromJson(body, ApplicationModel.class);

        if(id > -1) {
            ApplicationsDAO.getInstance().add(
                application.getName(),
                application.getVersion(),
                application.getStartUri(),
                application.getLanguage(),
                id
            );
        } else {
            //TODO throw exception?
        }

        //TODO return added application
    }
}
