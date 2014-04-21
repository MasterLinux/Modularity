package server.api.model;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.List;

/**
 * Created by Christoph on 02.02.14.
 */
public class BaseResourceModel<T extends BaseObjectModel> {
    private MetaModel meta;
    private List<T> objects;

    public MetaModel getMeta() { return meta; }

    /**
     * Sets the meta data of the response
     *
     * @param meta The meta data object
     * @return Instance of this
     */
    public BaseResourceModel<T> setMeta(MetaModel meta) {
        this.meta = meta;
        return this;
    }

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
        this.objects = objects;
        return this;
    }

    /**
     * Parses this resource to JSON
     * @return The JSON representation of this resource
     */
    public String toResponse() {
        Gson gson = new GsonBuilder()
                .disableHtmlEscaping()
                .serializeNulls()
                .create();

        return gson.toJson(this, getClass());
    }

    /**
     * Checks whether the result set is empty
     * @return <code>true</code> if the response has no items, <code>false</code> otherwise
     */
    public boolean isEmpty() {
        return objects == null || objects.isEmpty();
    }
}
