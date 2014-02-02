package util;

import model.BaseModel;
import model.MetaModel;
import model.ResponseModel;

import javax.ws.rs.core.UriBuilder;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Christoph on 02.02.14.
 */
public class ResponseModelUtil<T extends BaseModel> {
    private ResponseModel<T> response;

    public ResponseModelUtil(URI uri, List<T> objects, int limit, int offset) {
        boolean hasNext, hasPrevious;
        int page, start, end, size;
        List<T> filteredObjects;
        MetaModel meta;

        size = objects.size();

        //calc page
        page = offset + 1;

        //calc start end end index
        end = limit * page;
        start = end - limit;

        //adjust start end end
        end = end > size ? size : end;
        start = start < 0 ? 0 : start;

        //check for next and prev page
        hasNext = end < size;
        hasPrevious = start > 0;

        //get filtered object list
        if(start <= size) {
            filteredObjects = objects.subList(start, end);
        }
        //or an empty list if start is out of bounce
        else {
            filteredObjects = new ArrayList<T>();
        }

        //create resource uri
        URI prevUri = UriBuilder.fromUri(uri)
                .replaceQueryParam("offset", offset - 1)
                .scheme(null)
                .host(null)
                .port(-1)
                .build();

        URI nextUri = UriBuilder.fromUri(uri)
                .replaceQueryParam("offset", offset + 1)
                .scheme(null)
                .host(null)
                .port(-1)
                .build();

        //create meta model
        meta = new MetaModel();
        meta.setFilteredCount(filteredObjects.size());
        meta.setTotalCount(size);
        meta.setOffset(offset);
        meta.setLimit(limit);
        meta.setNext(hasNext ? nextUri.toString() : null);
        meta.setPrevious(hasPrevious ? prevUri.toString() : null);

        //set response
        response = new ResponseModel<T>();
        response.setObjects(filteredObjects);
        response.setMeta(meta);
    }

    public ResponseModel<T> get() {
        return response;
    }
}
