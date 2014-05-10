package server.exception;

/**
 * Created by masterlinux on 5/9/14.
 */
public class DataSourceAuthorizationException extends Throwable {
    public DataSourceAuthorizationException() {
        super("Authorization failed.");
    }
}
