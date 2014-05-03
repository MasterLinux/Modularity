package server.api.parameter;

import server.api.Api;
import server.api.model.UserModel;
import server.data.dao.UsersDAO;
import server.security.Password;

import javax.ws.rs.HeaderParam;
import java.util.List;

/**
 * Bean parameter used to check whether
 * the consumer is authorized to
 * use the API
 *
 * @author Christoph Grundmann
 */
public class LoginBeanParam {
    private final Password password;
    private int userId;

    private static final int UNKNOWN_USER_ID = -1;

    /**
     * Initializes the login bean parameter
     * @param username The name of the user to login
     * @param password The password of the user to login
     */
    public LoginBeanParam(
            @HeaderParam(Api.HEADER_USER_NAME) String username,
            @HeaderParam(Api.HEADER_USER_PASSWORD) String password
    ) {
        this.password = new Password(username, password, UserModel.class.toGenericString());
        this.userId = getUserId(username);
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
     * Checks whether the user is authorized to
     * use this API.
     *
     * @return <code>true</code> if the user is authorized, <code>false</code> otherwise
     */
    public boolean isAuthorized() {
        return userId != UNKNOWN_USER_ID &&
                UsersDAO.getInstance().isAuthorized(userId, password);
    }

    /**
     * Gets the user ID of the user
     * @return The ID of the user
     */
    public int getUserId() {
        return userId;
    }
}
