package server.api.parameter;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.QueryParam;
import java.util.LinkedList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by Christoph on 02.02.14.
 */
public class MetaBeanParam {
    private int limit;
    private int offset;
    private LinkedList<EmbedParameter> embed;

    public MetaBeanParam(
            @QueryParam("limit") @DefaultValue("20") int limit,
            @QueryParam("offset") @DefaultValue("0") int offset,
            @QueryParam("embed") String embed
    ) {
        this.limit = limit;
        this.offset = offset;
        this.embed = new LinkedList<EmbedParameter>();//parseEmbedValue(embed); //TODO use parser
    }

    /**
     * Gets the number of results per page
     * @return Expected number of results per page
     */
    public int getLimit() {
        return limit;
    }

    /**
     * Gets the pagination offset which is the same
     * as the page number. Starting at 0
     * @return Pagination offset
     */
    public int getOffset() {
        return offset;
    }

    /**
     * Gets the list of found embed parameter
     * @return Embed parameter
     */
    public LinkedList<EmbedParameter> getEmbed() {
        return embed;
    }

    /**
     * Checks whether the value of the embed query parameter is valid
     * @param value The value to validate
     * @return True if the value is valid, false otherwise
     */
    private boolean validateEmbedValue(String value) {
        Pattern pattern = Pattern.compile("([a-zA-Z]+(\\(([a-zA-Z]+_\\d+)(,[a-zA-Z]+_\\d+)*\\))*)(_[a-zA-Z]+(\\(([a-zA-Z]+_\\d+)(,[a-zA-Z]+_\\d+)*\\))*)*");
        return pattern.matcher(value).matches();
    }

    /**
     * TODO implement fast and more secure parser
     * Parses the value of the embed query parameter
     * @param value The value to parse
     * @return The list of found embed parameter
     */
    private LinkedList<EmbedParameter> parseEmbedValue(String value) {
        LinkedList<EmbedParameter> params = new LinkedList<EmbedParameter>();

        if(!validateEmbedValue(value)) {
            //TODO throw exception?
            return params;
        }

        //find embed parameter
        Pattern pattern = Pattern.compile("([a-zA-Z]+(\\(([a-zA-Z]+_\\d+)(,[a-zA-Z]+_\\d+)*\\))*)");
        Matcher matcher = pattern.matcher(value);

        while (matcher.find()) {
            String match = matcher.group();
            EmbedParameter param = EmbedParameter.parse(match);

            //find attributes
            Pattern attrPattern = Pattern.compile("[a-zA-Z]+_\\d+");
            Matcher attrMatcher = attrPattern.matcher(match);

            while (attrMatcher.find()) {
                param.addAttribute(EmbedAttribute.parse(attrMatcher.group()));
            }

            params.add(param);
        }

        return params;
    }
}
