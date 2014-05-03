package server.api.resource;

import server.data.dao.SessionsDAO;
import server.api.parameter.LoginBeanParam;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/**
 * Resource to get, create or delete sessions.
 *
 * @author Christoph Grundmann
 */
@Path("/sessions")
public class Sessions extends BaseResource {

    /**
     * Gets a session by login credentials of the user who owns the session
     *
     * @param sessionId The ID of the session to get
     * @param login The login credentials of the user to login
     * @return The session as JSON string
     */
    @GET
    @Path("/{id: [0-9]+}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getSessionByLoginCredentials(
            @PathParam("id") @DefaultValue("-1") int sessionId,
            @BeanParam LoginBeanParam login
    ) {
        if(!login.isAuthorized()) {
            throw new WebApplicationException(Response.Status.UNAUTHORIZED);
        }

        //invalid session id
        if(sessionId == -1) {
            throw new WebApplicationException(Response.Status.BAD_REQUEST);
        }

        return SessionsDAO.getInstance().getSession(login.getUserId()).toResponse();
    }

    /**
     * Creates a session by login credentials of the user to login
     *
     * @param login The login credentials of the user to login
     * @return The new session as JSON string
     */
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String createSessionByLoginCredentials(
            @BeanParam LoginBeanParam login
    ) {
        if(!login.isAuthorized()) {
            throw new WebApplicationException(Response.Status.UNAUTHORIZED);
        }

        return SessionsDAO.getInstance().createSession(login.getUserId()).toResponse();
    }
}
