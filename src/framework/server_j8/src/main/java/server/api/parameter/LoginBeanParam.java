package server.api.parameter;

import server.api.Api;

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

    /**
     * Initializes the login bean parameter
     * @param username The name of the user to login
     * @param password The password of the user to login
     */
    public LoginBeanParam(
            @HeaderParam(Api.HEADER_USER_NAME) String username,
            @HeaderParam(Api.HEADER_USER_PASSWORD) String password
    ) {

        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }
}
