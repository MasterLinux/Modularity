package server.data;

/**
 * Created by Christoph on 21.03.2014.
 */
interface IDatabase {
    boolean connect();
    void disconnect();
}
