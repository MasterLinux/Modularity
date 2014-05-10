package server.data.dao;

import server.api.model.SessionModel;
import server.api.model.SessionsModel;
import server.data.MySQLDatabase;
import server.exception.*;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.logging.Logger;

/**
 * DAO to create, update and delete sessions.
 *
 * @author Christoph Grundmann
 */
public class SessionsDAO extends BaseDAO { //TODO implements SessionDataSource as interface?
    private static final Logger logger = Logger.getLogger(SessionsDAO.class.getName());
    private static SessionsDAO instance;

    /**
     * Statement to select a specific session by the ID of the user who owns this session
     */
    private static final String SQL_SELECT_BY_USER_ID = "SELECT id, user_id, last_login, expiration_time, auth_token, is_expired FROM session WHERE user_id = ?";

    /**
     * Statement to select a specific session by its ID
     */
    private static final String SQL_SELECT_BY_ID = "SELECT id, user_id, last_login, expiration_time, auth_token, is_expired FROM session WHERE id = ?";

    /**
     * Statement to insert a new session into the database
     */
    private static final String SQL_INSERT = "INSERT INTO session (user_id, last_login, expiration_time, auth_token, is_expired) VALUES (?, ?, ?, ?, ?)";

    /**
     * Statement to delete a specific session by its ID
     */
    private static final String SQL_DELETE_BY_ID = "DELETE FROM session WHERE id=? AND auth_token=?";

    /**
     * Statement to update the authenticate token of a session of a specific user
     */
    private static final String SQL_UPDATE_AUTH_TOKEN = "UPDATE session SET is_expired=?, auth_token=? WHERE user_id=?";

    //column names
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_USER_ID = "user_id";
    private static final String COLUMN_LAST_LOGIN = "last_login";
    private static final String COLUMN_EXPIRATION_TIME = "expiration_time";
    private static final String COLUMN_AUTH_TOKEN = "auth_token";
    private static final String COLUMN_IS_EXPIRED = "is_expired";

    /**
     * Initializes the data access object
     */
    private SessionsDAO() {
        //does nothing
    }

    /**
     * Gets the instance of this data access object
     *
     * @return The instance of the data access object
     */
    public static SessionsDAO getInstance() {
        if (instance == null) {
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
    public SessionsModel createSession(int userId) throws
            ServiceUnavailableException,
            ResourceNotFoundException,
            OperationException {

        MySQLDatabase db = MySQLDatabase.getInstance();
        SessionsModel response = getSessionByUserId(userId);

        //check whether the response exists
        boolean exists = !response.isEmpty();

        //check whether the response is expired
        boolean isExpired = !exists || response.getObjects().get(0).isExpired();

        if (db.isConnected()) {
            //refresh current response if exists
            if (exists && isExpired) {
                response = refreshSession(userId);
            }

            //otherwise create a new response
            else if (!exists) {
                try {
                    Date timeNow = getDate();

                    PreparedStatement statement = db.getConnection().prepareStatement(SQL_INSERT);
                    statement.setInt(1, userId);
                    statement.setDate(2, timeNow);
                    statement.setDate(3, timeNow); //TODO add one day -> expiration time
                    statement.setString(4, buildAuthToken());
                    statement.setBoolean(5, false);

                    //get new created response on success
                    if (statement.executeUpdate() > 0) {
                        response = getSessionByUserId(userId);
                    }

                    //session could not be created
                    else {
                        throw new OperationException(
                                OperationException.ErrorCode.FAIL_TO_CREATE
                        );
                    }

                    statement.close();

                } catch (SQLException e) {
                    logger.warning(SQL_EXECUTION_ERROR + e.getMessage());

                    throw new OperationException(
                            OperationException.ErrorCode.FAIL_TO_CREATE
                    );
                }
            }
        } else {
            logger.warning(DATABASE_CONNECTION_ERROR);
            throw new ServiceUnavailableException();
        }

        return response;
    }

    /**
     * Refreshes the session of a specific user
     *
     * @param userId ID of the user which session should be refreshed
     * @return The refreshed session
     */
    private SessionsModel refreshSession(int userId) throws
            ServiceUnavailableException,
            ResourceNotFoundException,
            OperationException {

        MySQLDatabase db = MySQLDatabase.getInstance();
        SessionsModel response;

        if (db.isConnected()) {
            try {
                PreparedStatement statement = db.getConnection().prepareStatement(SQL_UPDATE_AUTH_TOKEN);
                statement.setBoolean(1, false);
                statement.setString(2, buildAuthToken());
                statement.setInt(3, userId);

                //get updated session on success
                if (statement.executeUpdate() > 0) {
                    response = getSessionByUserId(userId);
                }

                //session does not exist
                else {
                    throw new ResourceNotFoundException();
                }

                statement.close();

            } catch (SQLException e) {
                logger.warning(SQL_EXECUTION_ERROR + e.getMessage());

                throw new OperationException(
                        OperationException.ErrorCode.FAIL_TO_UPDATE
                );
            }
        } else {
            logger.warning(DATABASE_CONNECTION_ERROR);
            throw new ServiceUnavailableException();
        }

        return response;
    }

    private String buildAuthToken() {
        return "auth_token_" + new Random().nextDouble(); //TODO implement
    }

    private Date getDate() { //TODO move to util class
        java.util.Calendar cal = java.util.Calendar.getInstance();
        return new Date(cal.getTimeInMillis());
    }

    /**
     * Gets a specific session
     *
     * @param id   ID of a user or the session
     * @param type The type of the given ID
     * @return The session
     */
    private SessionsModel getSession(int id, IdType type) throws
            ResourceNotFoundException,
            ServiceUnavailableException,
            OperationException {

        MySQLDatabase db = MySQLDatabase.getInstance();
        List<SessionModel> sessions = new ArrayList<>(1);
        SessionsModel response = new SessionsModel();

        if (db.isConnected()) {
            try {
                PreparedStatement statement = null;

                //select statement
                switch (type) {
                    case USER_ID:
                        statement = db.getConnection().prepareStatement(SQL_SELECT_BY_USER_ID);
                        break;

                    case SESSION_ID:
                        statement = db.getConnection().prepareStatement(SQL_SELECT_BY_ID);
                        break;
                }

                statement.setInt(1, id);

                ResultSet result = statement.executeQuery();

                if (result.first()) {
                    SessionModel session = new SessionModel();

                    session.setExpirationTime(result.getDate(COLUMN_EXPIRATION_TIME).toString());
                    session.setLastLogin(result.getDate(COLUMN_LAST_LOGIN).toString());
                    session.setAuthToken(result.getString(COLUMN_AUTH_TOKEN));
                    session.setUserId(result.getInt(COLUMN_USER_ID));
                    session.setId(result.getInt(COLUMN_ID));
                    session.setExpired(result.getBoolean(COLUMN_IS_EXPIRED));

                    sessions.add(session);
                }

                //session does not exist
                else {
                    throw new ResourceNotFoundException();
                }

            } catch (SQLException e) {
                logger.warning(SQL_EXECUTION_ERROR + e.getMessage());

                throw new OperationException(
                        OperationException.ErrorCode.FAIL_TO_GET
                );
            }
        } else {
            logger.warning(DATABASE_CONNECTION_ERROR);
            throw new ServiceUnavailableException();
        }

        return (SessionsModel) response.setObjects(sessions);
    }

    /**
     * Gets a session of a specific user
     *
     * @param id ID of the user who owns the session
     * @return The session of the user with the given ID
     */
    public SessionsModel getSessionByUserId(int id) throws
            ServiceUnavailableException,
            ResourceNotFoundException,
            OperationException {

        return getSession(id, IdType.USER_ID);
    }

    /**
     * Gets a session by its ID
     *
     * @param id ID of the session to get
     * @return The session
     */
    public SessionsModel getSessionById(int id) throws
            ServiceUnavailableException,
            ResourceNotFoundException,
            OperationException {

        return getSession(id, IdType.SESSION_ID);
    }

    /**
     * Closes and deletes the session of a specific user
     *
     * @param id        The ID of the session to close
     * @param authToken The token to authenticate for this action
     * @return The closed session or an empty response if session does not exists or the authentication fails
     */
    public SessionsModel closeSession(int id, String authToken) throws
            ServiceUnavailableException,
            ResourceNotFoundException,
            AuthorizationException,
            OperationException {

        MySQLDatabase db = MySQLDatabase.getInstance();
        SessionsModel response = this.getSessionById(id);

        if (db.isConnected()) {
            if (!response.isEmpty()) {
                try {
                    PreparedStatement statement = db.getConnection().prepareStatement(SQL_DELETE_BY_ID);
                    statement.setInt(1, id);
                    statement.setString(2, authToken);

                    //update expiration flag on success
                    if (statement.executeUpdate() > 0) {
                        SessionModel session = response.getObject(0);
                        session.setAuthToken(null);
                        session.setExpired(true);
                    }

                    //otherwise the authorization has failed
                    else {
                        throw new AuthorizationException();
                    }

                    statement.close();
                }

                //unknown SQL error
                catch (SQLException e) {
                    logger.warning(SQL_EXECUTION_ERROR + e.getMessage());

                    throw new OperationException(
                            OperationException.ErrorCode.FAIL_TO_DELETE
                    );
                }

            } else {
                throw new ResourceNotFoundException();
            }
        }

        //database server is unreachable
        else {
            logger.warning(DATABASE_CONNECTION_ERROR);
            throw new ServiceUnavailableException();
        }

        return response;
    }

    /**
     * Type of ID
     */
    private enum IdType {
        USER_ID,
        SESSION_ID
    }
}
