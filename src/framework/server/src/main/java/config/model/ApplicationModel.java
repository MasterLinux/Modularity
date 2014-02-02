package config.model;

import model.BaseModel;

/**
 * Model which describes an application
 * @author Christoph Grundmann
 */
public class ApplicationModel extends BaseModel {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
