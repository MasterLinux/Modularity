package server.parameter;

import server.data.type.UserRole;
import server.util.StringUtility;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.HeaderParam;

/**
 * Header bean parameter which is used for
 * authentication
 */
public class SessionBeanParam {
    private int userId;
    private UserRole role;
    private String token;

    /**
     * Initialises the session bean parameter
     * @param userId ID of the user
     * @param role Role which defines the access level. Like "admin" or "customer"
     * @param token The authentication token
     */
    public SessionBeanParam(
            @HeaderParam("X-USER-ID") @DefaultValue("-1") int userId,
            @HeaderParam("X-USER-ROLE") String role,
            @HeaderParam("X-AUTH-TOKEN") String token
    ) {
        this.userId = userId;
        this.token = token;
        this.role = getUserRole(role);
    }

    /**
     * Gets the role of the user who requested the resource
     * @param role The role as string
     * @return The role as UserRole representation
     */
    private UserRole getUserRole(String role) {
        role = StringUtility.IsNullOrEmpty(role) ? "unauthorized" : role;
        UserRole r;

        switch (role)  {
            case "customer":
                if(isOwner()) {
                    r = UserRole.Owner;
                } else {
                    r = UserRole.Customer;
                }
                break;
            case "admin":
                r = UserRole.Administrator;
                break;
            default:
                r = UserRole.Unauthorized;
                break;
        }

        return r;
    }

    /**
     * Checks whether the user who requested
     * the specific resource is the owner of it.
     *
     * @return <code>true</code> if the user is the owner of this resource, <code>false</code> otherwise
     */
    private boolean isOwner() {
        return false; //TODO check whether the current user is the owner of the resource
    }

    /**
     * Checks whether the user is logged in
     * @return <code>true</code> when the user is authorized for the current action, <code>false</code> otherwise
     */
    public boolean isAuthorized() {
        if(userId >= 0 && !StringUtility.IsNullOrEmpty(token)) {
            return true; //TODO get login state with the help of a SessionDAO
        }

        return false;
    }

    /**
     * Gets the role of the user
     * @return The user role of the user
     */
    public UserRole getRole() {
        return role;
    }
}
