package server.api.model;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;

/**
 * Base implementation of a resource. Contains
 * all functionality to create a response
 *
 * @author Christoph Grundmann
 */
public class BaseResourceModel<T extends BaseObjectModel> {
    private List<T> objects = new ArrayList<>();
    private MetaModel meta = new MetaModel();

    public BaseResourceModel(Response.Status status, boolean error) {
        setHttpStatusCode(status);
        setErrorOccurred(error);
    }

    public BaseResourceModel() {
        this(Response.Status.OK, false);
    }

    /**
     * Gets the meta data of the response
     * @return The meta data
     */
    public MetaModel getMeta() { return meta; }

    /**
     * Sets the meta data of the response
     *
     * @param meta The meta data object
     * @return Instance of this
     */
    @Deprecated
    public BaseResourceModel<T> setMeta(MetaModel meta) {
        //this.meta = meta;
        return this;
    }

    /**
     * Gets the result set of the response
     * @return The result set
     */
    public List<T> getObjects() {
        return objects;
    }

    /**
     * Sets the result set of the response
     *
     * @param objects The result set
     * @return Instance of this
     */
    public BaseResourceModel<T> setObjects(List<T> objects) {
        this.objects.clear();
        this.objects.addAll(objects);
        return this;
    }

    /**
     * Parses this resource to JSON
     * @return The JSON representation of this resource
     */
    public Response toResponse() {
        Gson gson = new GsonBuilder()
                .disableHtmlEscaping()
                .serializeNulls()
                .create();

        String response = gson.toJson(this, getClass());

        return Response
                .status(getMeta().getHttpStatusCode())
                .entity(response)
                .build();
    }

    /**
     * Checks whether the result set is empty
     * @return <code>true</code> if the response has no items, <code>false</code> otherwise
     */
    public boolean isEmpty() {
        return objects == null || objects.isEmpty();
    }

    public BaseResourceModel<T> setHttpStatusCode(Response.Status httpStatusCode) {
        meta.setHttpStatusCode(httpStatusCode);
        return this;
    }

    public Response.Status getHttpStatusCode() {
        return meta.getHttpStatusCode();
    }

    public BaseResourceModel<T> setErrorOccurred(boolean errorOccurred) {
        meta.setErrorOccurred(errorOccurred);
        return this;
    }

    public boolean isErrorOccurred() {
        return meta.isErrorOccurred();
    }
}
