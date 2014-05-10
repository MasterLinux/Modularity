package server.exception;

/**
 * Created by masterlinux on 5/9/14.
 */
public class DataSourceNotFoundException extends Throwable {
    public DataSourceNotFoundException() {
        super("Requested data source not found.");
    }
}
