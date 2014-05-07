package server.api.model;

import javax.ws.rs.core.Response;

/**
 * Created by Christoph on 26.03.2014.
 */
public class SessionsModel extends BaseResourceModel<SessionModel> {

    public SessionsModel(Response.Status status, boolean error) {
        super(status, error);
    }

    public SessionsModel() {
        super();
    }
}
