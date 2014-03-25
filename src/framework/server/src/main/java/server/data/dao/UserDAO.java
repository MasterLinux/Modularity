package server.data.dao;

import server.data.MySQLDatabase;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * A data access object (DAO) to get or add users
 * into the database.
 */
public class UserDAO {
    private static UserDAO instance;

    /**
     * Statement to insert a new user into the database
     */
    private static final String SQL_INSERT = "INSERT INTO user (username, prename, surname, birthday, street, city, country, house_number, postal_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    /**
     * Statement to select a specific user by its ID
     */
//    private static final String SQL_SELECT_BY_ID = "SELECT name, version, start_uri, language FROM application WHERE id = ?";

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
    private UserDAO() {
        //does nothing
    }

    /**
     * Gets the instance of this data access object
     * @return The instance of the data access object
     */
    public static UserDAO getInstance() {
        if(instance == null) {
            instance = new UserDAO();
        }

        return instance;
    }


//    /**
//     * Gets an user by its ID
//     * @param id The ID of the user
//     * @return The user or an emtpy list if not exists
//     */
//    public List<ApplicationModel> get(int id) {
//        List<ApplicationModel> applications = new ArrayList<ApplicationModel>();
//        MySQLDatabase db = MySQLDatabase.getInstance();
//
//        if(db.isConnected()) {
//            try {
//                PreparedStatement statement = db.getConnection().prepareStatement(SQL_SELECT_BY_ID);
//                statement.setInt(1, id);
//
//                ResultSet result = statement.executeQuery();
//
//                if(result.first()) {
//                    ApplicationModel application;
//
//                    do {
//                        application = new ApplicationModel();
//                        application.setName(result.getString(COLUMN_NAME));
//                        application.setVersion(result.getString(COLUMN_VERSION));
//                        application.setStartUri(result.getString(COLUMN_START_URI));
//                        application.setLanguage(result.getString(COLUMN_LANGUAGE));
//                        //TODO set other values
//
//                        applications.add(application);
//
//                    } while (result.next());
//                }
//
//            } catch (SQLException e) {
//                e.printStackTrace(); //TODO add error handling
//            }
//        } else {
//            //TODO add error handling -> logging?
//        }
//
//        return applications;
//    }

    /**
     * Adds a new user
     *
     * @param username
     * @param prename
     * @param surname
     * @param birthday
     * @param street
     *
     * @return true when the user is added successfully, false otherwise
     */
    public boolean add(String username, String prename, String surname, Date birthday, String street, String city, String country, String houseNumber, String postalCode) {
        MySQLDatabase db = MySQLDatabase.getInstance();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_INSERT);
                statement.setString(1, username);
                statement.setString(2, prename);
                statement.setString(3, surname);
                statement.setDate(4, birthday);
                statement.setString(5, street);
                statement.setString(6, city);
                statement.setString(7, country);
                statement.setString(8, houseNumber);
                statement.setString(9, postalCode);

                //try to execute statement
                if(statement.execute()) {
                    return true;
                }

            } catch (SQLException e) {
                e.printStackTrace(); //TODO add error handling
            }
        } else {
            //TODO add error handling -> logging?
        }

        return false;
    }
}
