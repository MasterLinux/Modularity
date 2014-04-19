package server.api.parameter;

import server.api.Api;
import server.security.Password;

import javax.ws.rs.HeaderParam;

/**
 * Bean parameter used to check whether
 * the consumer is authorized to
 * use the API
 *
 * @author Christoph Grundmann
 */
public class LoginBeanParam {
    private final Password password;
    private final String username;
    private final String appToken;
    private int userId;

    /**
     * Initializes the login bean parameter
     * @param username The name of the user to login
     * @param password The password of the user to login
     * @param appToken The token of the application
     */
    public LoginBeanParam(
            @HeaderParam(Api.HEADER_USER_NAME) String username,
            @HeaderParam(Api.HEADER_USER_PASSWORD) String password,
            @HeaderParam(Api.HEADER_APPLICATION_TOKEN) String appToken
    ) {
        this.password = new Password(username, password, getClass().toGenericString());
        this.username = username; //TODO get user ID directly?
        this.appToken = appToken;
    }

    //private void validateUser()

    /**
     * Checks whether the user is authorized to
     * use this API.
     *
     * @return <code>true</code> if the user is authorized, <code>false</code> otherwise
     */
    public boolean isAuthorized() {
        //TODO implement

        return true;
    }

    /**
     * Gets the user ID of the user
     * @return The ID of the user
     */
    public int getUserId() {
        return userId;
    }
}
