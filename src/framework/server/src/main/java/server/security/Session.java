package server.security;

/**
 * Created by Christoph on 11.04.2014.
 */
public class Session {

    private final int userId;
    private final String appToken;

    /**
     * Creates a new session for a specific user
     * and application
     *
     * @param userId The ID of the user
     * @param appToken The application token
     */
    public Session(int userId, String appToken) {
        this.userId = userId;
        this.appToken = appToken;

        //create other session data
        //lastLogin = new Date();
        //expirationTime;
    }

    /**
     * Gets the secure token which identifies
     * the session
     *
     * @return The secure token
     */
    public String getSecureToken() {  //replace string with a more secure solution?
        StringBuilder builder = new StringBuilder();

        return builder      //TODO implement more complex algorithm
                .append(this.userId)
                .append(this.appToken)
                .toString();
    }
}
