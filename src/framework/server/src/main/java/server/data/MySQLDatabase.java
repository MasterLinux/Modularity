package server.data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Implementation of the MySQL database
 */
public class MySQLDatabase {
    private final String dbUrl;
    private boolean isConnected;

    public MySQLDatabase(String ipAddress, String databaseName, String username, String password) {
        this.dbUrl = String.format(
            "jdbc:mysql://%s/%s?user=%s&password=%s",
            ipAddress, databaseName,
            username, password
        );
    }


    /**
     * Gets the MySQL connection.
     * @return
     */
    public Connection connect() {
        Connection connection = null;

        if(tryRegisterConnector()) {
            try {
                connection = DriverManager.getConnection(dbUrl);
                isConnected = true;
            }

            catch (SQLException e) {
                //TODO add error handling
                System.out.println("SQLException: " + e.getMessage());
                System.out.println("SQLState: " + e.getSQLState());
                System.out.println("VendorError: " + e.getErrorCode());
                e.printStackTrace();
            }
        }

        return connection;
    }


    public void disconnect() {

    }

    /**
     * Tries to register the MySQL connector
     * @return Returns true when the connector is registered, false otherwise
     */
    private boolean tryRegisterConnector() {
        boolean isRegistered = false;

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            isRegistered = true;
        }

        catch (ClassNotFoundException e) {
            e.printStackTrace(); //TODO implement error handling
        }

        catch (InstantiationException e) {
            e.printStackTrace(); //TODO implement error handling
        }

        catch (IllegalAccessException e) {
            e.printStackTrace(); //TODO implement error handling
        }

        return isRegistered;
    }
}
