package server.api.config;

import junit.framework.Assert;
import org.junit.Test;
import server.api.BaseApiTest;

/**
 * Created by Christoph on 01.02.14.
 */
public class ApplicationsTest extends BaseApiTest {

    /**
     * Test to see that the message "Got it!" is sent in the response.
     */
    @Test
    public void testGetIt() {
        String responseMsg = getTarget().path("config/applications").queryParam("offset", "2").request().get(String.class);
        Assert.assertEquals("Got it!", responseMsg);
    }
}
