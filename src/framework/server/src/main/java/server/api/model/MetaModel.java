package server.api.model;

import javax.ws.rs.core.Response;

/**
 * Created by Christoph on 02.02.14.
 */
public class MetaModel {
    private int offset;
    private int limit;
    private int filteredCount;
    private int totalCount;
    private String next;
    private String previous;
    private boolean errorOccurred;

    public int getOffset() {
        return offset;
    }

    public void setOffset(int offset) {
        this.offset = offset;
    }

    public int getLimit() {
        return limit;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

    public int getFilteredCount() {
        return filteredCount;
    }

    public void setFilteredCount(int filteredCount) {
        this.filteredCount = filteredCount;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public String getNext() {
        return next;
    }

    public void setNext(String next) {
        this.next = next;
    }

    public String getPrevious() {
        return previous;
    }

    public void setPrevious(String previous) {
        this.previous = previous;
    }

    @Deprecated
    public void setHttpStatusCode(Response.Status httpStatusCode) {

    }

    @Deprecated
    public void setErrorOccurred(boolean errorOccurred) {
        this.errorOccurred = errorOccurred;
    }

    @Deprecated
    public boolean isErrorOccurred() {
        return errorOccurred;
    }
}
