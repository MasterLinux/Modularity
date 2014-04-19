package server.data.dao;

import server.Server;
import server.data.MySQLDatabase;
import server.data.type.UserRole;
import server.api.model.UserModel;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
    private static final String SQL_INSERT = "INSERT INTO user (username, prename, surname, birthday, street, house_number, postal_code, city, country) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    /**
     * Statement to select a specific user by its ID
     */
    private static final String SQL_SELECT_BY_ID = "SELECT id, username, prename, surname, birthday, street, house_number, postal_code, city, country FROM user WHERE id = ?";

    /**
     * Statement to select a specific user by its username
     */
    private static final String SQL_SELECT_BY_USERNAME = "SELECT id, username, prename, surname, birthday, street, house_number, postal_code, city, country FROM user WHERE username = ?";


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
    private static final String COLUMN_PASSWORD = "password";

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
     * @param userRole The role of the user, used as access level
     * @param name The username of the user to get
     * @return The user or an emtpy list if not exists
     */
    public List<UserModel> getByUsername(UserRole userRole, String name) {
        boolean hasFullAccess = userRole == UserRole.Administrator || userRole == UserRole.Owner;
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

                        //get another info just if the user has the right for full access
                        if(hasFullAccess) {
                            user.setBirthday(result.getDate(COLUMN_BIRTHDAY).toString());
                            user.setStreet(result.getString(COLUMN_STREET));
                            user.setHouseNumber(result.getString(COLUMN_HOUSE_NUMBER));
                            user.setPostalCode(result.getString(COLUMN_POSTAL_CODE));
                            user.setCity(result.getString(COLUMN_CITY));
                            user.setCountry(result.getString(COLUMN_COUNTRY));
                        }
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
     * @param userRole The role of the user, used as access level
     * @param id The ID of the user
     * @return The user or an emtpy list if not exists
     */
    public List<UserModel> getById(UserRole userRole, int id) {
        boolean hasFullAccess = userRole == UserRole.Administrator || userRole == UserRole.Owner;
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

                        //get another info just if the user has the right for full access
                        if(hasFullAccess) {
                            user.setBirthday(result.getDate(COLUMN_BIRTHDAY).toString());
                            user.setStreet(result.getString(COLUMN_STREET));
                            user.setHouseNumber(result.getString(COLUMN_HOUSE_NUMBER));
                            user.setPostalCode(result.getString(COLUMN_POSTAL_CODE));
                            user.setCity(result.getString(COLUMN_CITY));
                            user.setCountry(result.getString(COLUMN_COUNTRY));
                        }
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
    public boolean register(String username, String prename, String surname, Date birthday, String street, String houseNumber, String postalCode, String city, String country) {
        MySQLDatabase db = MySQLDatabase.getInstance();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_INSERT);
                statement.setString(1, username);
                statement.setString(2, prename);
                statement.setString(3, surname);
                statement.setDate(4, birthday);
                statement.setString(5, street);
                statement.setString(6, houseNumber);
                statement.setString(7, postalCode);
                statement.setString(8, city);
                statement.setString(9, country);

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
}
