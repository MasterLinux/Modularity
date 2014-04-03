package server.model;

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

    public void setMeta(MetaModel meta) { this.meta = meta; }

    public List<T> getObjects() {
        return objects;
    }

    public void setObjects(List<T> objects) {
        this.objects = objects;
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
}
