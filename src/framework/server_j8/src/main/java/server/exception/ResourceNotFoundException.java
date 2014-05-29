package server.exception;

/**
 * Created by masterlinux on 5/9/14.
 */
public class ResourceNotFoundException extends Throwable {
    public ResourceNotFoundException() {
        super("Requested data source not found.");
    }
}
