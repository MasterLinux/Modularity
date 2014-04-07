package server;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import server.model.BaseObjectModel;
import server.model.BaseResourceModel;
import server.parameter.MetaBeanParam;
import server.util.ResponseBuilder;

import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import java.util.List;

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
    @Deprecated
    protected <T extends BaseObjectModel> String buildResponse(MetaBeanParam metaParam, List<T> objects) {
        BaseResourceModel<T> response = new ResponseBuilder<T>()
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
