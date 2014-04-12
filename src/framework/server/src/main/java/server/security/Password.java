package server.security;

/**
 * Representation of a password. Used to avoid
 * the using of String. In addition it encrypts
 * the password
 *
 * @author Christoph Grundmann
 * @since 1.0.0
 */
public class Password {
    private final byte[] secureToken;

    /**
     * Creates a new password
     *
     * @param phrase String representation of the password
     */
    public Password(String phrase) {
        secureToken = phrase.getBytes();
    }

    /**
     * Gets the encrypted secure token
     * representing the password
     *
     * @return The secure token used as password
     */
    public byte[] getSecureToken() {
        return secureToken;
    }

    @Override
    public String toString() {
        //TODO implement secure solution
        return super.toString();
    }
}
