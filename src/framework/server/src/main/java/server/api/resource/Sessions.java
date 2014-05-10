package server.api.resource;

import org.apache.http.util.TextUtils;
import server.api.Api;
import server.api.model.SessionsModel;
import server.api.parameter.LoginBeanParam;
import server.data.dao.SessionsDAO;
import server.exception.*;
import server.exception.ServiceUnavailableException;

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
        SessionsModel sessions = new SessionsModel();
        Response.Status status = Response.Status.OK;

        if(login.isBadRequest()) {
            status = Response.Status.BAD_REQUEST;
        } else if (!login.isAuthorized()) {
            status = Response.Status.UNAUTHORIZED;
        } else {
            try {
                sessions = SessionsDAO.getInstance().getSessionByUserId(login.getUserId());
            } catch (ServiceUnavailableException | OperationException e) {
                status = Response.Status.INTERNAL_SERVER_ERROR;
            } catch (ResourceNotFoundException e) {
                status = Response.Status.NOT_FOUND;
            }
        }

        return sessions.toResponse(status);
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
        SessionsModel sessions = new SessionsModel();
        Response.Status status = Response.Status.CREATED;

        if(login.isBadRequest()) {
            status = Response.Status.BAD_REQUEST;
        } else if (!login.isAuthorized()) {
            status = Response.Status.UNAUTHORIZED;
        } else {
            try {
                sessions = SessionsDAO.getInstance().createSession(login.getUserId());
            } catch (ServiceUnavailableException | OperationException e) {
                status = Response.Status.INTERNAL_SERVER_ERROR;
            } catch (ResourceNotFoundException e) {
                status = Response.Status.NOT_FOUND;
            }
        }

        return sessions.toResponse(status);
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
        SessionsModel sessions = new SessionsModel();
        Response.Status status = Response.Status.OK;

        //validate required parameter
        if (sessionId == -1 || TextUtils.isEmpty(token)) {
            status = Response.Status.BAD_REQUEST;
        } else {
            try {
                sessions = SessionsDAO.getInstance().closeSession(sessionId, token);
            } catch (ServiceUnavailableException | OperationException e) {
                status = Response.Status.INTERNAL_SERVER_ERROR;
            } catch (ResourceNotFoundException e) {
                status = Response.Status.NOT_FOUND;
            } catch (AuthorizationException e) {
                status = Response.Status.UNAUTHORIZED;
            }
        }

        return sessions.toResponse(status);
    }
}
