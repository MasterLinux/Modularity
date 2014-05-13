package server.api.resource;

import server.api.Api;
import server.api.parameter.LoginBeanParam;
import server.api.service.SessionService;

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
        return new SessionService(login.getUsername(), login.getPassword()).getSession();
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
        return new SessionService(login.getUsername(), login.getPassword()).createSession();
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
            @PathParam("id") @DefaultValue(Api.DEFAULT_VALUE_UNSET_ID) int sessionId,
            @HeaderParam(Api.HEADER_AUTH_TOKEN) String token
    ) {
        return new SessionService(token).closeSession(sessionId);
    }
}
