package server.api.service;

import org.apache.http.util.TextUtils;
import server.api.Api;
import server.api.model.UserModel;
import server.data.dao.UsersDAO;
import server.security.Password;

import java.util.List;

/**
 * Base implementation for secure services
 * which needs any kind of authorization
 *
 * @author Christoph Grundmann
 */
public abstract class SecureService {
    protected static final int UNKNOWN_USER_ID = -1;
    private final AuthorizationType authType;
    private int userId = UNKNOWN_USER_ID;
    private Password password;
    private String authToken;

    public SecureService(String username, String password) {
        this.authType = AuthorizationType.CREDENTIALS;
        if(!TextUtils.isEmpty(username) && !TextUtils.isEmpty(password)) {
            this.password = new Password(username, password, UserModel.class.toGenericString());
            this.userId = getUserId(username);
        }
    }

    public SecureService(String authToken) {
        this.authType = AuthorizationType.AUTH_TOKEN;
        this.authToken = authToken;
    }

    /**
     * Gets the ID of a specific user by its username
     * @param username The name of the user who`s ID is required
     * @return The ID of the user or <code>-1</code> if user not exists
     */
    private int getUserId(String username) {
        List<UserModel> users = UsersDAO.getInstance().getByUsername(username);

        if(users.isEmpty()) {
            return UNKNOWN_USER_ID;
        }

        return users.get(0).getId();
    }

    /**
     * Gets the ID of the user who tries to get
     * a resource from server.
     *
     * @return The ID of the logged in user or BaseService.UNKNOWN_USER_ID on error
     */
    protected int getUserId() {
        return userId;
    }

    /**
     * Gets the auth token of the user who tries to get
     * a resource from server
     *
     * @return The auth token or <code>null</code> on error
     */
    protected String getAuthToken() {
        return authToken;
    }

    /**
     * Checks whether the user is authorized to
     * use this API.
     *
     * @return <code>true</code> if the user is authorized, <code>false</code> otherwise
     */
    protected boolean isAuthorized() {
        boolean isAuthorized = false;

        switch (authType) {
            case CREDENTIALS:
                isAuthorized = userId != UNKNOWN_USER_ID && UsersDAO.getInstance().isAuthorized(userId, password);
                break;
            case AUTH_TOKEN:
                isAuthorized = !TextUtils.isEmpty(authToken); //TODO && UsersDAO.getInstance().isAuthorized(authToken);
        }

        return isAuthorized;
    }

    /**
     * Checks whether there are missing credentials
     * @return <code>true</code> if the auth token or the username and password are missing, <code>false</code> otherwise
     */
    protected boolean missingCredentials() {
        boolean missingCredentials = false;

        switch (authType) {
            case CREDENTIALS:
                missingCredentials = userId == UNKNOWN_USER_ID || password == null;
                break;
            case AUTH_TOKEN:
                missingCredentials = !TextUtils.isEmpty(authToken);
        }

        return missingCredentials;
    }

    /**
     * Checks whether the given ID is not valid
     * @param id ID to check
     * @return <code>true</code> if the ID isn't valid, <code>false</code> otherwise
     */
    protected boolean isInvalidId(int id) {
        return Api.DEFAULT_VALUE_UNSET_ID.equals(String.valueOf(id));
    }

    /**
     * Type of authorization
     */
    private enum AuthorizationType {
        AUTH_TOKEN, CREDENTIALS
    }
}
