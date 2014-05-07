package server.api.resource;

import org.apache.http.util.TextUtils;
import server.api.Api;
import server.api.model.SessionsModel;
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
     * Gets the current session of a specific user
     *
     * @param login The login credentials of the user who owns the session
     * @return The session as JSON string
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSession(
            @BeanParam LoginBeanParam login
    ) {
        SessionsModel sessions;

        if (!login.isAuthorized()) {
            sessions = new SessionsModel(Response.Status.UNAUTHORIZED, true);
        } else {
            sessions = SessionsDAO.getInstance().getSessionByUserId(login.getUserId());
        }

        return sessions.toResponse();
    }

    /**
     * Creates a new session
     *
     * @param login The login credentials of the user to login
     * @return The new session as JSON string
     */
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    public Response createSession(
            @BeanParam LoginBeanParam login
    ) {
        SessionsModel sessions;

        if (!login.isAuthorized()) {
            sessions = new SessionsModel(Response.Status.UNAUTHORIZED, true);
        } else {
            sessions = SessionsDAO.getInstance().createSession(login.getUserId());
        }

        return sessions.toResponse();
    }

    /**
     * Closes a specific session by its ID.
     *
     * @param sessionId The ID of the session to close
     * @param token     The token to check for authentication
     * @return The closed session
     */
    @DELETE
    @Path("/{id: [0-9]+}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response closeSessionById(
            @PathParam("id") @DefaultValue("-1") int sessionId,
            @HeaderParam(Api.HEADER_AUTH_TOKEN) String token
    ) {
        SessionsModel sessions;

        //validate required parameter
        if (sessionId == -1 || TextUtils.isEmpty(token)) {
            sessions = new SessionsModel(Response.Status.BAD_REQUEST, true);
        } else {
            sessions = SessionsDAO.getInstance().closeSession(sessionId, token);
        }

        return sessions.toResponse();
    }
}
