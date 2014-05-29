package server.data.dao;

import org.apache.http.util.TextUtils;
import server.Server;
import server.api.model.UserModel;
import server.data.MySQLDatabase;
import server.security.Token;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * A data access object (DAO) to get or add users
 * into the database.
 */
public class UsersDAO {
    private static final Logger logger = Logger.getLogger(Server.class.getName());
    private static UsersDAO instance;

    /**
     * Statement to insert a new user into the database
     */
    private static final String SQL_INSERT = "INSERT INTO user (username, secure_token, prename, surname, birthday, street, house_number, postal_code, city, country) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    /**
     * Statement to select a specific user by its ID
     */
    private static final String SQL_SELECT_BY_ID = "SELECT id, username, prename, surname, birthday, street, house_number, postal_code, city, country FROM user WHERE id = ?";

    /**
     * Statement to select a specific user by its username
     */
    private static final String SQL_SELECT_BY_USERNAME = "SELECT id, username, prename, surname, birthday, street, house_number, postal_code, city, country FROM user WHERE username = ?";

    /**
     * Statement to select all required authorization data of a specific user by its ID
     */
    private static final String SQL_SELECT_FOR_AUTHORIZATION = "SELECT secure_token FROM user WHERE id = ?";

    //column names
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_USERNAME = "username";
    private static final String COLUMN_PRENAME = "prename";
    private static final String COLUMN_SURNAME = "surname";
    private static final String COLUMN_BIRTHDAY = "birthday";
    private static final String COLUMN_STREET = "street";
    private static final String COLUMN_CITY = "city";
    private static final String COLUMN_COUNTRY = "country";
    private static final String COLUMN_HOUSE_NUMBER = "house_number";
    private static final String COLUMN_POSTAL_CODE = "postal_code";
    private static final String COLUMN_SECURE_TOKEN = "secure_token";

    /**
     * Initializes the data access object
     */
    private UsersDAO() {
        //does nothing
    }

    /**
     * Gets the instance of this data access object
     * @return The instance of the data access object
     */
    public static UsersDAO getInstance() {
        if(instance == null) {
            instance = new UsersDAO();
        }

        return instance;
    }

    /**
     * Gets an user by its username
     * @param name The username of the user to get
     * @return The user or an emtpy list if not exists
     */
    public List<UserModel> getByUsername(String name) {
        MySQLDatabase db = MySQLDatabase.getInstance();
        List<UserModel> users = new ArrayList<>();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_SELECT_BY_USERNAME);
                statement.setString(1, name);

                ResultSet result = statement.executeQuery();

                if(result.first()) {
                    UserModel user;

                    do {
                        user = new UserModel();
                        user.setId(result.getInt(COLUMN_ID));
                        user.setUsername(result.getString(COLUMN_USERNAME));
                        user.setPrename(result.getString(COLUMN_PRENAME));
                        user.setSurname(result.getString(COLUMN_SURNAME));
                        user.setBirthdayDate(result.getDate(COLUMN_BIRTHDAY));
                        user.setStreet(result.getString(COLUMN_STREET));
                        user.setHouseNumber(result.getString(COLUMN_HOUSE_NUMBER));
                        user.setPostalCode(result.getString(COLUMN_POSTAL_CODE));
                        user.setCity(result.getString(COLUMN_CITY));
                        user.setCountry(result.getString(COLUMN_COUNTRY));
                        //TODO set other values

                        users.add(user);

                    } while (result.next());
                }

            } catch (SQLException e) {
                //TODO add error handling
            }
        } else {
            //TODO add error handling
        }

        return users;
    }

    /**
     * Gets an user by its ID
     * @param id The ID of the user
     * @return The user or an emtpy list if not exists
     */
    public List<UserModel> getById(int id) {
        MySQLDatabase db = MySQLDatabase.getInstance();
        List<UserModel> users = new ArrayList<>();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_SELECT_BY_ID);
                statement.setInt(1, id);

                ResultSet result = statement.executeQuery();

                if(result.first()) {
                    UserModel user;

                    do {
                        user = new UserModel();
                        user.setId(result.getInt(COLUMN_ID));
                        user.setUsername(result.getString(COLUMN_USERNAME));
                        user.setPrename(result.getString(COLUMN_PRENAME));
                        user.setSurname(result.getString(COLUMN_SURNAME));
                        user.setBirthdayDate(result.getDate(COLUMN_BIRTHDAY));
                        user.setStreet(result.getString(COLUMN_STREET));
                        user.setHouseNumber(result.getString(COLUMN_HOUSE_NUMBER));
                        user.setPostalCode(result.getString(COLUMN_POSTAL_CODE));
                        user.setCity(result.getString(COLUMN_CITY));
                        user.setCountry(result.getString(COLUMN_COUNTRY));
                        //TODO set other values

                        users.add(user);

                    } while (result.next());
                }

            } catch (SQLException e) {
                //TODO add error handling
            }
        } else {
            //TODO add error handling
        }

        return users;
    }

    /**
     * Registers a new user
     *
     * @param username Login name of the user
     * @param prename The prename of the user
     * @param surname The surname of the user
     * @param birthday The Birthday of the user
     * @param street The street name of the user's home
     * @param houseNumber The house number of the user's home
     * @param postalCode The postal code of the user's home
     * @param city The city of the user's home
     * @param country The country of the user's home
     *
     * @return <code>true</code> when the user is added successfully, <code>false</code> otherwise
     */
    public boolean register(String username, Token password, String prename, String surname, Date birthday, String street, String houseNumber, String postalCode, String city, String country) {
        MySQLDatabase db = MySQLDatabase.getInstance();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_INSERT);

                //required fields
                statement.setString(1, username);
                statement.setBytes(2, password.getBytes());

                //optional fields
                setOptionalField(3, prename, statement);
                setOptionalField(4, surname, statement);
                setOptionalField(5, birthday, statement);
                setOptionalField(6, street, statement);
                setOptionalField(7, houseNumber, statement);
                setOptionalField(8, postalCode, statement);
                setOptionalField(9, city, statement);
                setOptionalField(10, country, statement);

                //try to execute statement
                statement.execute();
                statement.close();

                return true;

            } catch (SQLException e) {
                logger.warning("Unable to add user to database, caused by a missing field."); //TODO use constant error messages
            }
        } else {
            logger.warning("Unable to add user to database, because the database connection is not established."); //TODO use constant error messages
        }

        return false;
    }

    private void setOptionalField(int index, Date value, PreparedStatement statement) throws SQLException {
        if(value == null) {
            statement.setNull(index, Types.DATE);
        } else {
            statement.setDate(index, value);
        }
    }

    private static void setOptionalField(int index, String value, PreparedStatement statement) throws SQLException {
        if(TextUtils.isEmpty(value)) {
            statement.setNull(index, Types.VARCHAR);
        } else {
            statement.setString(index, value);
        }
    }

    /**
     * Checks whether a specific user is authorized
     *
     * @param id The ID of the user
     * @param password The password of the user to check for authorization
     * @return <code>true</code> if the user is authorized, <code>false</code> otherwise
     */
    public boolean isAuthorized(int id, Token password) {
        MySQLDatabase db = MySQLDatabase.getInstance();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_SELECT_FOR_AUTHORIZATION);
                statement.setInt(1, id);

                ResultSet result = statement.executeQuery();

                if(result.first()) {
                    byte[] secureToken = result.getBytes(COLUMN_SECURE_TOKEN);

                    if(password.equals(secureToken)) {
                        return true;
                    }
                }

            } catch (SQLException e) {
                //TODO add error handling
            }
        } else {
            //TODO add error handling
        }

        return false;
    }
}
