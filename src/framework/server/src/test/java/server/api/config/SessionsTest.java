package server.api.config;

import junit.framework.Assert;
import org.junit.Test;
import server.api.Api;
import server.api.BaseApiTest;
import server.api.mock.UserMock;
import server.api.model.UserModel;

import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.core.MediaType;

/**
 * Created by Christoph on 07.05.2014.
 */
public class SessionsTest extends BaseApiTest {

    @Test(expected = NotAuthorizedException.class)
    public void testGetIt() {
        UserModel model = UserMock.getRegisteredUserWithMinimumInfo();

        String responseMsg = getTarget()
                .path("sessions")
                .request()
                .accept(MediaType.APPLICATION_JSON)
                .header(Api.HEADER_USER_NAME, model.getUsername())
                .header(Api.HEADER_USER_PASSWORD, model.getPassword())
                .get(String.class);

        Assert.assertEquals("Got it!", responseMsg);
    }
}
