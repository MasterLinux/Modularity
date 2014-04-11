package server.api.config;

import server.BaseResource;
import server.data.dao.SessionsDAO;
import server.parameter.LoginBeanParam;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * Created by Christoph on 03.04.2014.
 */
@Path("/sessions")
public class Sessions extends BaseResource {

    /**
     * Gets a session by its ID
     *
     * @param login The login credentials of the user to login
     *
     * @return The session as JSON string
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String getSessionByLoginCredentials(
            @BeanParam LoginBeanParam login
    ) {
        if(!login.isAuthorized()) {
            throw new WebApplicationException(Response.Status.UNAUTHORIZED);
        }

        return SessionsDAO.getInstance().createSession(login.getUserId()).toResponse();
    }
}
