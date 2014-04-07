package server.parameter;

import javax.ws.rs.HeaderParam;

/**
 * Bean parameter used to check whether
 * the consumer is authorized to
 * use the API
 *
 * @author Christoph Grundmann
 */
public class LoginBeanParam {
    private final String username;
    private final String password;
    private final String appToken;

    /**
     * Initializes the login bean parameter
     * @param username The name of the user to login
     * @param password The password of the user to login
     * @param appToken The token of the application
     */
    public LoginBeanParam(
            @HeaderParam("X-USER-NAME") String username, //TODO implement BaseParam with all existing header as static final class member
            @HeaderParam("X-USER-PASSWORD") String password,
            @HeaderParam("X-APPLICATION-TOKEN") String appToken
    ) {
        this.username = username;
        this.password = password;
        this.appToken = appToken;
    }

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
     * Gets the username of the user
     * @return The username of the user
     */
    public String getUsername() {
        return username;
    }
}
