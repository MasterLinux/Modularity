package config;

import com.google.gson.Gson;
import config.model.ApplicationModel;
import model.MetaModel;
import model.ResponseModel;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import java.util.ArrayList;

/**
 * Created by Christoph on 01.02.14.
 */
@Path("/applications")
public class Applications {

    @GET
    @Produces("application/json")
    public String getApplications() {
        ResponseModel<ApplicationModel> response = new ResponseModel<ApplicationModel>();

        MetaModel meta = new MetaModel();
        meta.setFilteredCount(1);
        meta.setLimit(1);
        meta.setNext("bla");
        meta.setOffset(1);
        meta.setPrevious("bla-1");
        meta.setTotalCount(1);

        response.setMeta(meta);

        ApplicationModel application = new ApplicationModel();
        application.setName("wusa");

        ArrayList<ApplicationModel> objects = new ArrayList<ApplicationModel>();
        objects.add(application);

        response.setObjects(objects);

        Gson gson = new Gson();

        return gson.toJson(response);
    }
}
