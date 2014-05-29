package server.util;

import server.api.model.BaseObjectModel;
import server.api.model.BaseResourceModel;
import server.api.model.MetaModel;

import javax.ws.rs.core.UriBuilder;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Christoph on 02.02.14.
 */
@Deprecated
public class ResponseBuilder<T extends BaseObjectModel> {
    private int defaultOffset = -1;
    private int defaultLimit = -1;
    private int offset = -1;
    private int limit = -1;
    private List<T> objects;
    private URI uri;

    public static final int DEFAULT_OFFSET = 0;
    public static final int DEFAULT_LIMIT = 20;

    public ResponseBuilder(int defaultLimit, int defaultOffset) {
        this.defaultLimit = defaultLimit;
        this.defaultOffset = defaultOffset;
    }

    public ResponseBuilder() {}

    public ResponseBuilder<T> setResourceUri(URI uri) {
        this.uri = uri;
        return this;
    }

    public ResponseBuilder<T> setObjects(List<T> objects) {
        this.objects = objects;
        return this;
    }

    public ResponseBuilder<T> setLimit(int limit) {
        this.limit = limit;
        return this;
    }

    /**
     * Sets the page offset
     * @param offset
     * @return
     */
    public ResponseBuilder<T> setOffset(int offset) {
        this.offset = offset;
        return this;
    }

    /**
     * Builds the response server.model
     * @return The response server.model
     */
    public BaseResourceModel<T> build() {
        boolean hasNext, hasPrevious;
        BaseResourceModel<T> response;
        List<T> objects = getObjects();
        URI uri = getResourceUri();
        int page, start, end,
                offset = getOffset(),
                limit = getLimit(),
                size = objects.size();
        List<T> filteredObjects;
        MetaModel meta;

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
        URI prevUri = getResourceUri(uri, offset - 1);
        URI nextUri = getResourceUri(uri, offset + 1);

        //create meta server.model
        meta = getMetaModel(limit, offset, size, filteredObjects,
                hasPrevious ? prevUri.toString() : null,
                hasNext ? nextUri.toString() : null
        );

        //set response
        response = new BaseResourceModel<T>();
        response.setObjects(filteredObjects);
        response.setMeta(meta);

        return response;
    }

    /**
     * Creates and gets the meta server.model for the response
     *
     * @param limit
     * @param offset
     * @param size
     * @param filteredObjects
     * @param prevUri
     * @param nextUri
     *
     * @return The required server.model
     */
    private MetaModel getMetaModel(
            int limit, int offset, int size,
            List<T> filteredObjects,
            String prevUri, String nextUri
    ) {
        MetaModel meta = new MetaModel();
        meta.setFilteredCount(filteredObjects.size());
        meta.setTotalCount(size);
        meta.setOffset(offset);
        meta.setLimit(limit);
        meta.setNext(nextUri);
        meta.setPrevious(prevUri);

        return meta;
    }

    /**
     * Creates and gets the URI of a specific resource
     * @param uri The URI of the resource
     * @param offset Pagination offset
     * @return The required URI
     */
    private URI getResourceUri(URI uri, int offset) {
        return UriBuilder.fromUri(uri)
                .replaceQueryParam("offset", offset)
                .scheme(null)
                .host(null)
                .port(-1)
                .build();
    }

    private int getOffset() {
        int val = offset > -1 ? offset : defaultOffset;
        return val > -1 ? val : DEFAULT_OFFSET;
    }

    private int getLimit() {
        int val = limit > -1 ? limit : defaultLimit;
        return val > -1 ? val : DEFAULT_LIMIT;
    }

    private List<T> getObjects() {
        return objects != null ? objects : new ArrayList<T>();
    }

    private URI getResourceUri() {
        return uri != null ? uri : URI.create("");
    }
}
