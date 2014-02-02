package server.model;

import java.util.List;

/**
 * Created by Christoph on 02.02.14.
 */
public class ResponseModel<T extends BaseModel> {
    private ResponseMetaModel meta;
    private List<T> objects;

    public ResponseMetaModel getMeta() { return meta; }

    public void setMeta(ResponseMetaModel meta) { this.meta = meta; }

    public List<T> getObjects() {
        return objects;
    }

    public void setObjects(List<T> objects) {
        this.objects = objects;
    }
}
