package server.data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Implementation of the MySQL database
 */
public class MySQLDatabase {
    private static MySQLDatabase database;
    private Connection connection;
    private String serverAddress;
    private String serverDatabaseName;
    private String serverLogin;

    /**
     * Initializes the MySQL database
     */
    private MySQLDatabase() {
        //does nothing
    }

    /**
     * Gets the instance of the MySQL database
     * @return The instance of the database
     */
    public static MySQLDatabase getInstance() {
        if(database == null) {
            database = new MySQLDatabase();
        }

        return database;
    }

    /**
     * Sets the IP address and the port of MySQL server
     * @param ip The IP adress of the MySQL server
     * @return The instance of the database
     */
    public MySQLDatabase setAddress(String ip, String port) {
        StringBuilder builder = new StringBuilder(ip);

        //add port if set
        if(port != null) {
            builder
                .append(":")
                .append(port);
        }

        builder.append("/");

        serverAddress = builder.toString();
        return this;
    }

    /**
     * Sets the database name which will be accessed
     * @param name The name of the database to open
     * @return The instance of the database
     */
    public MySQLDatabase setDatabaseName(String name) {
        serverDatabaseName = name;
        return this;
    }

    /**
     * Sets the login required to connect to the database
     * @param username The login name of the database user
     * @param password The password of the database user
     * @return The instance of the database
     */
    public MySQLDatabase setLogin(String username, String password) {
        StringBuilder builder = new StringBuilder("user=").append(username);

        if(password != null) {
            builder.append("&password=").append(password);
        }

        serverLogin = builder.toString();
        return this;
    }

    /**
     * Builds the database URL
     * @return The URL of the database
     */
    private String buildDatabaseUrl() {
        //TODO add error handling for missing arguments
        return "jdbc:mysql://" + serverAddress + serverDatabaseName + "?" + serverLogin;
    }

    /**
     * Gets the MySQL connection.
     * @return Whether the connection could be opened
     */
    public boolean connect() {
        boolean isConnected = false;

        //disconnect before reconnecting
        disconnect(); //TODO log warning when already connected?


        if(tryRegisterConnector()) {
            try {
                this.connection = DriverManager.getConnection(buildDatabaseUrl());
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

        return isConnected;
    }

    /**
     * Closes the database connection
     */
    public void disconnect() { //TODO return true on success?
        try {
            if(isConnected()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace(); //TODO add error handling
        }
    }

    /**
     * Gets database connection
     * @return The database connection or null if not initially connected
     */
    public Connection getConnection() {
        return connection;
    }

    /**
     * Checks whether the database connection is open
     * @return true when connection is open, false otherwise
     */
    public boolean isConnected() {
        try {
            if(connection != null && !connection.isClosed()) {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace(); //TODO add error handling
        }

        return false;
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
