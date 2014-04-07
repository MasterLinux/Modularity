package server.data.dao;

import server.data.MySQLDatabase;
import server.model.config.ApplicationModel;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * A data access object (DAO) to get or add applications
 * into the database.
 */
public class ApplicationsDAO {
    private static ApplicationsDAO instance;

    /**
     * Statement to insert a new application into the database
     */
    private static final String SQL_INSERT = "INSERT INTO application (name, version, start_uri, language, user_id) VALUES (?, ?, ?, ?, ?)";

    /**
     * Statement to select a specific application by its ID
     */
    private static final String SQL_SELECT_BY_ID = "SELECT id, name, version, start_uri, language FROM application WHERE id = ?";

    //column names
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_NAME = "name";
    private static final String COLUMN_VERSION = "version";
    private static final String COLUMN_START_URI = "start_uri";
    private static final String COLUMN_LANGUAGE = "language";

    /**
     * Initializes the data access object
     */
    private ApplicationsDAO() {
        //does nothing
    }

    /**
     * Gets the instance of this data access object
     * @return The instance of the data access object
     */
    public static ApplicationsDAO getInstance() {
        if(instance == null) {
            instance = new ApplicationsDAO();
        }

        return instance;
    }

    /**
     * Gets an application by its ID
     * @param id The ID of the application
     * @return The application or an emtpy list if not exists
     */
    public List<ApplicationModel> getById(int id) {
        List<ApplicationModel> applications = new ArrayList<>();
        MySQLDatabase db = MySQLDatabase.getInstance();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_SELECT_BY_ID);
                statement.setInt(1, id);

                ResultSet result = statement.executeQuery();

                if(result.first()) {
                    ApplicationModel application;

                    do {
                        application = new ApplicationModel();
                        application.setId(result.getInt(COLUMN_ID));
                        application.setName(result.getString(COLUMN_NAME));
                        application.setVersion(result.getString(COLUMN_VERSION));
                        application.setStartUri(result.getString(COLUMN_START_URI));
                        application.setLanguage(result.getString(COLUMN_LANGUAGE));
                        //TODO set other values

                        applications.add(application);

                    } while (result.next());
                }

                statement.close();

            } catch (SQLException e) {
                e.printStackTrace(); //TODO add error handling
            }
        } else {
            //TODO add error handling -> logging?
        }

        return applications;
    }

    /**
     * Adds a new application
     *
     * @param name Name of the application to add
     * @param version Version number of the application
     * @param startUri Page URI of the first page displayed
     * @param language Language code of the default language
     * @param userId ID of the user who owns this application
     *
     * @return <code>true</code> when the application is added successfully, <code>false</code> otherwise
     */
    public boolean add(String name, String version, String startUri, String language, int userId) {
        MySQLDatabase db = MySQLDatabase.getInstance();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_INSERT);
                statement.setString(1, name);
                statement.setString(2, version);
                statement.setString(3, startUri);
                statement.setString(4, language);
                statement.setInt(5, userId);

                //try to execute statement
                statement.execute();
                statement.close();

                return true;

            } catch (SQLException e) {
                e.printStackTrace(); //TODO add error handling
            }
        } else {
            //TODO add error handling -> logging?
        }

        return false;
    }
}
