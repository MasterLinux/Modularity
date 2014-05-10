package server.exception;

/**
 * Created by masterlinux on 5/9/14.
 */
public class DataSourceDeletionException extends Throwable {
    public DataSourceDeletionException() {
        super("Data source could not be deleted.");
    }
}
