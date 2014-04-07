package server.model.config;

import server.model.BaseObjectModel;

/**
 * Model which describes an application
 * @author Christoph Grundmann
 */
public class ApplicationModel extends BaseObjectModel {
    private String name;
    private String version;
    private String author; //TODO get user model instead?
    private String startUri;
    private String language;
    private ResourcesModel resources;
    private PagesModel pages;
    private TasksModel tasks;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getStartUri() {
        return startUri;
    }

    public void setStartUri(String startUri) {
        this.startUri = startUri;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public ResourcesModel getResources() {
        return resources;
    }

    public void setResources(ResourcesModel resources) {
        this.resources = resources;
    }

    public PagesModel getPages() {
        return pages;
    }

    public void setPages(PagesModel pages) {
        this.pages = pages;
    }

    public TasksModel getTasks() {
        return tasks;
    }

    public void setTasks(TasksModel tasks) {
        this.tasks = tasks;
    }
}
