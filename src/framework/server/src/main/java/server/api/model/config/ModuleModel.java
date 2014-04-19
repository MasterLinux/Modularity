package server.api.model.config;

import server.api.model.BaseObjectModel;

/**
 * Created by Christoph on 16.03.14.
 */
public class ModuleModel extends BaseObjectModel {
    private String lib;
    private String name;
    //TODO find solution for config

    public String getLib() {
        return lib;
    }

    public void setLib(String lib) {
        this.lib = lib;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
