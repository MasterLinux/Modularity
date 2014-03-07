package server.parameter;

import java.util.HashMap;

public class EmbedParameter {
    private String name;
    private HashMap<String, EmbedAttribute> attributes;

    public EmbedParameter(String name) {
        attributes = new HashMap<String, EmbedAttribute>();
        this.name = name;
    }

    static EmbedParameter parse(String value) {
        String[] keyValue = value.split("\\(([a-zA-Z]+_\\d+)(,([a-zA-Z]+_\\d+))*\\)");
        return new EmbedParameter(keyValue[0]); //TODO throw exception on error
    }

    public String getName() {
        return name;
    }

    public void addAttribute(EmbedAttribute attr) {
        attributes.put(attr.getKey(), attr);
    }

    public EmbedAttribute getAttribute(String key) {
        return attributes.get(key);
    }
}
