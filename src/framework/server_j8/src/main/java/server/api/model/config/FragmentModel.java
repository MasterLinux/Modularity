package server.api.model.config;

import server.api.model.BaseObjectModel;

/**
 * Created by Christoph on 16.03.14.
 */
public class FragmentModel extends BaseObjectModel {
    private String title;
    private String parent;
    private ModulesModel modules;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getParent() {
        return parent;
    }

    public void setParent(String parent) {
        this.parent = parent;
    }

    public ModulesModel getModules() {
        return modules;
    }

    public void setModules(ModulesModel modules) {
        this.modules = modules;
    }
}
