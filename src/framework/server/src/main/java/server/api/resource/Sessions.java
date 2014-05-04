package server.api.resource;

import org.apache.http.util.TextUtils;
import server.api.Api;
import server.api.parameter.LoginBeanParam;
import server.data.dao.SessionsDAO;

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
     * Gets a specific session by its ID
     *
     * @param sessionId The ID of the session to get
     * @param login The login credentials of the user who owns the session
     * @return The session as JSON string
     */
    @GET
    @Path("/{id: [0-9]+}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getSessionById(
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

        return SessionsDAO.getInstance().getSessionByUserId(login.getUserId()).toResponse();
    }

    /**
     * Creates a new session
     *
     * @param login The login credentials of the user to login
     * @return The new session as JSON string
     */
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public String createSession(
            @BeanParam LoginBeanParam login
    ) {
        if(!login.isAuthorized()) {
            throw new WebApplicationException(Response.Status.UNAUTHORIZED);
        }

        return SessionsDAO.getInstance().createSession(login.getUserId()).toResponse();
    }

    /**
     * Closes a specific session by its ID.
     *
     * @param sessionId The ID of the session to close
     * @param token The token to check for authentication
     * @return The closed session
     */
    @DELETE
    @Path("/{id: [0-9]+}")
    @Produces(MediaType.APPLICATION_JSON)
    public String closeSessionById(
            @PathParam("id") @DefaultValue("-1") int sessionId,
            @HeaderParam(Api.HEADER_AUTH_TOKEN) String token
    ) {
        if(sessionId == -1 || TextUtils.isEmpty(token)) {
            throw new WebApplicationException(Response.Status.BAD_REQUEST);
        }

        return SessionsDAO.getInstance().closeSession(sessionId, token).toResponse();
    }
}
