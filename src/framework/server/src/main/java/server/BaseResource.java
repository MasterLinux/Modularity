package server;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import server.model.BaseModel;
import server.model.ResponseModel;
import server.model.config.ApplicationModel;
import server.parameter.MetaBeanParam;
import server.util.ResponseBuilder;

import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import java.util.ArrayList;

/**
 * Created by masterlinux on 2/12/14.
 */
public class BaseResource {

    @Context
    protected UriInfo uriInfo;

    /**
     * Builds the response
     * @param metaParam
     * @param objects
     * @param <T>
     * @return
     */
    protected <T extends BaseModel> String buildResponse(MetaBeanParam metaParam, ArrayList<T> objects) {
        ResponseModel<T> response = new ResponseBuilder<T>()
                .setResourceUri(uriInfo.getRequestUri())
                .setLimit(metaParam.getLimit())
                .setOffset(metaParam.getOffset())
                .setObjects(objects)
                .build();

        Gson gson = new GsonBuilder()
                .disableHtmlEscaping()
                .serializeNulls()
                .create();

        return gson.toJson(response);
    }
}
