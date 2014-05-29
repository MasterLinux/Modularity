package server.api.service;

import server.api.model.SessionsModel;
import server.data.dao.SessionsDAO;
import server.exception.AuthorizationException;
import server.exception.OperationException;
import server.exception.ResourceNotFoundException;
import server.exception.ServiceUnavailableException;

import javax.ws.rs.core.Response;

public class SessionService extends SecureService {

    public SessionService(String username, String password) {
        super(username, password);
    }

    public SessionService(String token) {
        super(token);
    }

    public Response getSession() {
        SessionsModel sessions = new SessionsModel();
        Response.Status status = Response.Status.OK;

        if(missingCredentials()) {
            status = Response.Status.BAD_REQUEST;
        } else if (!isAuthorized()) {
            status = Response.Status.UNAUTHORIZED;
        } else {
            try {
                sessions = SessionsDAO.getInstance().getSessionByUserId(getUserId());
            } catch (ServiceUnavailableException | OperationException e) {
                status = Response.Status.INTERNAL_SERVER_ERROR;
            } catch (ResourceNotFoundException e) {
                status = Response.Status.NOT_FOUND;
            }
        }

        return sessions.toResponse(status);
    }

    public Response createSession() {
        SessionsModel sessions = new SessionsModel();
        Response.Status status = Response.Status.CREATED;

        if(missingCredentials()) {
            status = Response.Status.BAD_REQUEST;
        } else if (!isAuthorized()) {
            status = Response.Status.UNAUTHORIZED;
        } else {
            try {
                sessions = SessionsDAO.getInstance().createSession(getUserId());
            } catch (ServiceUnavailableException | OperationException e) {
                status = Response.Status.INTERNAL_SERVER_ERROR;
            }
        }

        return sessions.toResponse(status);
    }

    public Response closeSession(int sessionId) {
        SessionsModel sessions = new SessionsModel();
        Response.Status status = Response.Status.OK;

        if (isInvalidId(sessionId) || missingCredentials()) {
            status = Response.Status.BAD_REQUEST;
        } else if (!isAuthorized()) {
            status = Response.Status.UNAUTHORIZED;
        }  else {
            try {
                sessions = SessionsDAO.getInstance().closeSession(sessionId, getAuthToken());
            } catch (ServiceUnavailableException | OperationException e) {
                status = Response.Status.INTERNAL_SERVER_ERROR;
            } catch (ResourceNotFoundException e) {
                status = Response.Status.NOT_FOUND;
            } catch (AuthorizationException e) {
                status = Response.Status.UNAUTHORIZED; //TODO remove and use isAuthorized instead
            }
        }

        return sessions.toResponse(status);
    }


}
