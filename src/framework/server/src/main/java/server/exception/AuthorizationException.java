package server.exception;

/**
 * Created by masterlinux on 5/9/14.
 */
public class AuthorizationException extends Throwable {
    public AuthorizationException() {
        super("Authorization has failed.");
    }
}
