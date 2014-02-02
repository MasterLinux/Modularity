package server.model;

/**
 * Base implementation of a server.model
 * @author Christoph Grundmann
 */
public class BaseModel {
    private int id;
    private String resourceUri;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getResourceUri() {
        return resourceUri;
    }

    public void setResourceUri(String resourceUri) {
        this.resourceUri = resourceUri;
    }
}
