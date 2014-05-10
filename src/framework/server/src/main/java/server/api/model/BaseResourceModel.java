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
     * @deprecated Use getObject instead
     */
    @Deprecated
    public List<T> getObjects() {
        return objects;
    }

    /**
     * Gets a specific object by its index
     * @param index Index of the object to get
     * @return The object or <code>null</code> if not exists
     */
    public T getObject(int index) {
        if(objects != null && objects.size() > index) {
            return objects.get(index);
        }

        return null;
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
     * Parses this response to JSON
     * @param httpStatusCode HTTP status code of this response
     * @return The JSON representation of this resource
     */
    public Response toResponse(Response.Status httpStatusCode) {
        Gson gson = new GsonBuilder()
                .disableHtmlEscaping()
                .serializeNulls()
                .create();

        String response = gson.toJson(this, getClass());

        return Response
                .status(httpStatusCode)
                .entity(response)
                .build();
    }

    /**
     * Parses this resource to JSON
     * @return The JSON representation of this resource
     */
    public Response toResponse() {
        return toResponse(Response.Status.OK);
    }

    /**
     * Checks whether the result set is empty
     * @return <code>true</code> if the response has no items, <code>false</code> otherwise
     */
    public boolean isEmpty() {
        return objects == null || objects.isEmpty();
    }

    @Deprecated
    public BaseResourceModel<T> setHttpStatusCode(Response.Status httpStatusCode) {
        meta.setHttpStatusCode(httpStatusCode);
        return this;
    }

    @Deprecated
    public Response.Status getHttpStatusCode() {
        return meta.getHttpStatusCode();
    }

    @Deprecated
    public BaseResourceModel<T> setErrorOccurred(boolean errorOccurred) {
        meta.setErrorOccurred(errorOccurred);
        return this;
    }

    @Deprecated
    public boolean isErrorOccurred() {
        return meta.isErrorOccurred();
    }
}
