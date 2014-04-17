package server.security;

import javax.crypto.*;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

/**
 * Representation of a password. Used to avoid
 * the using of String. In addition it encrypts
 * the password
 *
 * @author Christoph Grundmann
 * @since 1.0.0
 */
public class Password {
    private static final int FACTOR_ITERATIONS = 3;
    private final byte[] secureToken;

    /**
     * Creates a new password
     *
     * @param keyPhrase The phrase for generating the key
     * @param passPhrase String representation of the password
     * @param salt A salt to obfuscate the password
     */
    public Password(String keyPhrase, String passPhrase, String salt) {
        secureToken = encrypt(keyPhrase.toCharArray(), passPhrase.getBytes(), salt.getBytes());
    }

    /**
     * Builds the secret key used for encryption
     *
     * @param keyPhrase The phrase for generating the key
     * @param salt A salt for generating the key
     * @return The key or null on error
     */
    private SecretKeySpec buildKey(char[] keyPhrase, byte[] salt) {
        int iterations = salt.length * keyPhrase.length * FACTOR_ITERATIONS;
        SecretKeyFactory keyFactory;
        SecretKeySpec keySpec;
        SecretKey secretKey;

        try {
            keyFactory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");

            secretKey = keyFactory.generateSecret(
                    new PBEKeySpec(keyPhrase, salt, iterations, 128)
            );

            keySpec = new SecretKeySpec(secretKey.getEncoded(), "AES");

        } catch (InvalidKeySpecException |
                NoSuchAlgorithmException e) {

            keySpec = null;
        }

        return keySpec;
    }

    /**
     * Encrypts the password phrase
     *
     * @param token Password phrase as byte array
     * @param salt A salt to obfuscate the password
     * @return The encrypted password phrase or an empty byte array on error
     */
    private byte[] encrypt(char[] keyPhrase, byte[] token, byte[] salt) {
        byte[] encryptedToken;
        Cipher aes;

        try {
            aes = Cipher.getInstance("AES/ECB/PKCS5Padding");
            aes.init(Cipher.ENCRYPT_MODE, buildKey(keyPhrase, salt));

            //encrypt the data
            encryptedToken = aes.doFinal(obfuscate(token, salt));
        }

        //catch all exceptions
        catch (NoSuchAlgorithmException |
                NoSuchPaddingException |
                BadPaddingException |
                IllegalBlockSizeException |
                InvalidKeyException e) {

            encryptedToken = new byte[0];
        }

        return encryptedToken;
    }

    /**
     * Obfuscates the password phrase with the help of the salt
     *
     * @param token Password phrase as byte array
     * @param salt A salt to obfuscate the password
     * @return The obfuscated password phrase
     */
    private byte[] obfuscate(byte[] token, byte[] salt) {
        int max = Math.max(token.length, salt.length),
            size = max * 2;

        byte[] obfuscatedToken = new byte[size],
                maxBytes = token.length == max ? token : salt,
                minBytes = token.length == max ? salt : token,
                newMinBytes = new byte[max];

        for(int i=0; i<max; i++) {
            newMinBytes[i] = minBytes.length > i ? minBytes[i] : getByte(i);

            byte tokenByte = maxBytes[i],
                 saltByte = newMinBytes[i];

            int x = 2*i,
                y = x+1;

            obfuscatedToken[x] = tokenByte;
            obfuscatedToken[y] = saltByte;
        }

        return obfuscatedToken;
    }

    private byte getByte(int position) {
        byte[] bytes = String.valueOf(position).getBytes();
        return bytes.length > 0 ? bytes[0] : (byte) 42;
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
