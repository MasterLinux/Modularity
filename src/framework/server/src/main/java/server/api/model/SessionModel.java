package server.api.model;

/**
 * Representation of a session
 */
public class SessionModel extends BaseObjectModel {
    private String lastLogin;
    private String expirationTime;
    private String authToken;     //TODO rename to secureToken?

    public String getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(String lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getExpirationTime() {
        return expirationTime;
    }

    public void setExpirationTime(String expirationTime) {
        this.expirationTime = expirationTime;
    }

    public String getAuthToken() {
        return authToken;
    }

    public void setAuthToken(String authToken) {
        this.authToken = authToken;
    }
}
