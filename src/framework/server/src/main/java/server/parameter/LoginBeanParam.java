package server.parameter;

import javax.ws.rs.HeaderParam;

/**
 * Created by Christoph on 03.04.2014.
 */
public class LoginBeanParam {
    private final String username;
    private final String password;

    /**
     * Initializes the login bean parameter
     * @param username The name of the user to login
     * @param password The password of the user to login
     */
    public LoginBeanParam(
            @HeaderParam("X-USER-NAME") String username,
            @HeaderParam("X-USER-PASSWORD") String password
    ) {
        this.username = username;
        this.password = password;
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
