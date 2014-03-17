package server.data.dao;

import server.model.config.ApplicationModel;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by Christoph on 17.03.14.
 */
public class ApplicationsDAO {
    private static ApplicationsDAO instance;
    private LinkedList<ApplicationModel> models;

    private ApplicationsDAO() {
        models = new LinkedList<ApplicationModel>();

        ApplicationModel app;
        for(int i=0; i<50; i++) {
            app = new ApplicationModel();
            app.setId(i);
            app.setName("app_" + i);
            app.setAuthor("aPuerto GmbH");
            app.setDefaultLanguage("de-DE");
            app.setStartUri("home");
            app.setVersion("1.0." + i);
            app.setResourceUri("/applications/" + i);

            models.add(app);
        }
    }

    public static ApplicationsDAO getInstance() {
        if(instance == null) {
            instance = new ApplicationsDAO();
        }

        return instance;
    }

    public List<ApplicationModel> get() {
        return models;
    }

    public List<ApplicationModel> get(int limit, int offset, int applicationId) {
        int size = models.size();
        int fromIndex = limit * offset;
        int toIndex = fromIndex + limit;

        if(fromIndex < size) {
            if(toIndex >= size) {
                toIndex = size-1;
            }

            return models.subList(fromIndex, toIndex);
        }

        return new LinkedList<ApplicationModel>();
    }
}
