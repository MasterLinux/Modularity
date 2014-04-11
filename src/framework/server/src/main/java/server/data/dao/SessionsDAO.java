package server.data.dao;

import server.data.MySQLDatabase;
import server.model.config.SessionModel;
import server.model.config.SessionsModel;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by Christoph on 03.04.2014.
 */
public class SessionsDAO extends BaseDAO {
    private static final Logger logger = Logger.getLogger(SessionsDAO.class.getName());
    private static SessionsDAO instance;

    private static final String SQL_SELECT_BY_USER_ID = "";

    /**
     * Initializes the data access object
     */
    private SessionsDAO() {
        //does nothing
    }

    /**
     * Gets the instance of this data access object
     * @return The instance of the data access object
     */
    public static SessionsDAO getInstance() {
        if(instance == null) {
            instance = new SessionsDAO();
        }

        return instance;
    }

    /**
     * Creates a new session for the user with
     * the given user ID. If an already open
     * session exists than this session will
     * be closed.
     *
     * @param userId The ID of the user
     * @return The session or a closed session on error
     */
    public SessionsModel createSession(int userId) {
        MySQLDatabase db = MySQLDatabase.getInstance();
        List<SessionModel> sessions = new ArrayList<>(1);
        SessionsModel response = new SessionsModel();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_SELECT_BY_USER_ID);
                statement.setInt(1, userId);

                ResultSet result = statement.executeQuery();

                if(result.first()) {

                }

            } catch (SQLException e) {
                //TODO add error handling
            }
        } else {
            //TODO add error handling
        }

        return (SessionsModel) response.setObjects(sessions);
    }

    /**
     * Gets a session of a specific user
     *
     * @param userId ID of the user
     * @return The session of the user or null if not exists
     */
    public SessionsModel getSession(int userId) {

        return null;
    }

    /**
     * Closes the session of a specific user
     *
     * @param userId The ID of the user
     * @return <code>true</code> if the session is successfully closed, <code>false</code> otherwise
     */
    public boolean closeSession(int userId) {
        return true;
    }
}
