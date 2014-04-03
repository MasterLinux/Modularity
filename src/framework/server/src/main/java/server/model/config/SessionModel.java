package server.model.config;

import server.model.BaseObjectModel;

/**
 * Representation of a session
 */
public class SessionModel extends BaseObjectModel {
    private String lastLogin;
    private String expirationTime;
    private String authToken;

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
