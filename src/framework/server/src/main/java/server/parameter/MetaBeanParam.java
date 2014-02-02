package server.parameter;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.QueryParam;

/**
 * Created by Christoph on 02.02.14.
 */
public class MetaBeanParam {
    private int limit;
    private int offset;

    public MetaBeanParam(
            @DefaultValue("20") @QueryParam("limit") int limit,
            @DefaultValue("0") @QueryParam("offset") int offset
    ) {
        this.limit = limit;
        this.offset = offset;
    }

    public int getLimit() {
        return limit;
    }

    public int getOffset() {
        return offset;
    }
}
