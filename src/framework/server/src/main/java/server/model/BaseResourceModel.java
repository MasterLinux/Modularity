package server.model;

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
}
