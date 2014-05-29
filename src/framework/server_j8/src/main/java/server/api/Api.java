package server.api;

/**
 * Created by Christoph on 19.04.2014.
 */
public class Api {
    public static final String HEADER_USER_NAME = "X-USER-NAME";
    public static final String HEADER_USER_PASSWORD = "X-USER-PASSWORD";
    public static final String HEADER_AUTH_TOKEN = "X-AUTH-TOKEN";

    @Deprecated
    public static final String HEADER_APPLICATION_TOKEN = "X-APPLICATION-TOKEN";

    //default values
    public static final String DEFAULT_VALUE_UNSET_ID = "-1";
}
