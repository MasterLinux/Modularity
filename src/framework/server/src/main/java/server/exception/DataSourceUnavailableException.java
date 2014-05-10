package server.exception;

/**
 * Created by masterlinux on 5/9/14.
 */
public class DataSourceUnavailableException extends Throwable {
    public DataSourceUnavailableException() {
        super("Database unreachable. Please check whether the database connection is etablished");
    }
}
