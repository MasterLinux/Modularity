package server.data.dao;

import server.model.config.SessionsModel;

import java.util.logging.Logger;

/**
 * Created by Christoph on 03.04.2014.
 */
public class SessionsDAO extends BaseDAO {
    private static final Logger logger = Logger.getLogger(SessionsDAO.class.getName());
    private static SessionsDAO instance;

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

    public SessionsModel getNewSession(String username) {

        return null;
    }
}
