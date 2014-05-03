package server.data.dao;

import server.data.MySQLDatabase;
import server.api.model.SessionModel;
import server.api.model.SessionsModel;

import java.sql.Date;
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

    private static final String SQL_SELECT_BY_USER_ID = "SELECT id, user_id, last_login, expiration_time, auth_token FROM session WHERE user_id = ?";

    /**
     * Statement to insert a new application into the database
     */
    private static final String SQL_INSERT = "INSERT INTO session (user_id, last_login, expiration_time, auth_token) VALUES (?, ?, ?, ?)";

    //column names
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_USER_ID = "user_id";
    private static final String COLUMN_LAST_LOGIN = "last_login";
    private static final String COLUMN_EXPIRATION_TIME = "expiration_time";
    private static final String COLUMN_AUTH_TOKEN = "auth_token";

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
     * Creates a new session for a specific
     * application and user. If an already open
     * session exists than this session will
     * be returned.
     *
     * @param userId The ID of the user of the required session
     * @return The session or a closed session on error
     */
    public SessionsModel createSession(int userId) {
        MySQLDatabase db = MySQLDatabase.getInstance();
        SessionsModel session;

        //return already opened session
        if((session = getSession(userId)).isEmpty() && db.isConnected()) { //TODO check whether the session isn't expired, if so create a new one
            try {
                Date timeNow = getDate();

                PreparedStatement statement = db.getConnection().prepareStatement(SQL_INSERT);
                statement.setInt(1, userId);
                statement.setDate(2, timeNow);
                statement.setDate(3, timeNow); //TODO add one day -> expiration time
                statement.setString(4, "auth_token"); //TODO generate auth token

                //try to execute statement
                statement.execute();
                statement.close();

                //get new created session
                session = getSession(userId);

            } catch (SQLException e) {
                //TODO add error handling
            }
        } else {
            //TODO add error handling
        }

        return session;
    }

    private Date getDate() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        return new Date(cal.getTimeInMillis());
    }

    /**
     * Gets a session of a specific user
     *
     * @param userId ID of the user
     * @return The session of the user or null if not exists
     */
    public SessionsModel getSession(int userId) {
        MySQLDatabase db = MySQLDatabase.getInstance();
        List<SessionModel> sessions = new ArrayList<>(1);
        SessionsModel response = new SessionsModel();

        if(db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_SELECT_BY_USER_ID);
                statement.setInt(1, userId);

                ResultSet result = statement.executeQuery();

                if(result.first()) {
                    SessionModel session = new SessionModel();

                    session.setExpirationTime(result.getDate(COLUMN_EXPIRATION_TIME).toString());
                    session.setLastLogin(result.getDate(COLUMN_LAST_LOGIN).toString());
                    session.setAuthToken(result.getString(COLUMN_AUTH_TOKEN));
                    session.setUserId(result.getInt(COLUMN_USER_ID));
                    session.setId(result.getInt(COLUMN_ID));

                    sessions.add(session);
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
     * Closes the session of a specific user
     *
     * @param userId The ID of the user
     * @return <code>true</code> if the session is successfully closed, <code>false</code> otherwise
     * //TODO return closed session
     */
    public boolean closeSession(int userId) {
        return true;
    }
}
