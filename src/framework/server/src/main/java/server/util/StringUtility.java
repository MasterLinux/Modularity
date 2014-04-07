package server.util;

/**
 * Created by Christoph on 28.03.2014.
 */
public class StringUtility {

    /**
     * Checks whether the given string is null or empty
     * @param value The string to check
     * @return <code>true</code> if the string is null or empty, <code>false</code> otherwise
     */
    public static boolean IsNullOrEmpty(String value) {
        return value == null || value.length() == 0;
    }
}
