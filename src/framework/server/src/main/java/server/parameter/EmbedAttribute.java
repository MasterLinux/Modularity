package server.parameter;

public class EmbedAttribute {
    private String key;
    private String value;

    public EmbedAttribute(String key, String value) {
        this.value = value;
        this.key = key;
    }

    static EmbedAttribute parse(String value) {
        String[] keyValue = value.split("_");
        return new EmbedAttribute(keyValue[0], keyValue[1]); //TODO throw exception if not valid?
    }

    public String getKey() {
        return key;
    }

    public String getValue() {
        return value;
    }
}
