package server.api.model.config;

import server.api.model.BaseObjectModel;

/**
 * Created by Christoph on 16.03.14.
 */
public class PageModel extends BaseObjectModel {
    private String uri;
    private String title;
    private FragmentsModel fragments;

    public String getUri() {
        return uri;
    }

    public void setUri(String uri) {
        this.uri = uri;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public FragmentsModel getFragments() {
        return fragments;
    }

    public void setFragments(FragmentsModel fragments) {
        this.fragments = fragments;
    }
}
