package server.api.model;

/**
 * Base implementation of an object model
 * @author Christoph Grundmann
 */
public class BaseObjectModel {
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
