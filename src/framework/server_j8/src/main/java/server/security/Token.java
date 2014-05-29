package server.security;

import javax.crypto.*;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.ByteBuffer;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Representation of a secure token
 *
 * @author Christoph Grundmann
 */
public class Token {

    private static final int ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING = 42;
    private final byte[] secureToken;
    private final int strength;

    /**
     * Initializes and generates the token
     *
     * @param builder The builder which contains all information to generate the token
     */
    private Token(Builder builder) {
        this.strength = builder.strength;
        secureToken = encrypt(builder.keyPhrase, builder.phrases.get(0), buildSalt(builder.phrases));
    }

    /**
     * Builds a secure salt
     *
     * @param phrases Collection of phrases to generate salt
     * @return The generated salt
     */
    private byte[] buildSalt(ArrayList<byte[]> phrases) {
        byte[] bytes = phrases.get(0);

        for(byte[] phrase : phrases) {
            bytes = obfuscate(bytes, phrase);
        }

        return bytes;
    }

    /**
     * Builds the secret key used for encryption
     *
     * @param keyPhrase The phrase for generating the key
     * @param salt A salt for generating the key
     * @return The key or null on error
     */
    private SecretKeySpec buildKey(char[] keyPhrase, byte[] salt) {
        int iterations = salt.length * keyPhrase.length * this.strength;
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

    /**
     * Converts the given position to a byte
     *
     * @param position The position to convert
     * @return The byte representation of the position
     */
    private byte getByte(int position) {
        byte[] bytes = String.valueOf(position).getBytes();
        return bytes.length > 0 ? bytes[0] : (byte) ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING;
    }

    /**
     * Gets the byte array presentation
     * of this token
     *
     * @return The token as byte array
     */
    public byte[] getBytes() {
        return secureToken;
    }

    @Override
    public String toString() {
        return new String(secureToken);
    }

    /**
     * Returns <code>true</code> if the secure token is
     * <i>equal</i> to this password.
     *
     * @param secureToken The secure token to check for equality
     * @return <code>true</code> if both are equal, <code>false</code> otherwise
     */
    public boolean equals(byte[] secureToken) {
        return Arrays.equals(secureToken, this.secureToken);
    }

    /**
     * Builds a token
     */
    public static class Builder {

        private final ArrayList<byte[]> phrases;
        private final char[] keyPhrase;
        private final int strength;

        /**
         * Initializes the token builder
         *
         * @param phrase The initial phrase to generate the token
         * @param strength Strength to increase the security of the token
         */
        public Builder(String phrase, int strength) {
            this.phrases = new ArrayList<>();
            this.keyPhrase = phrase.toCharArray();
            this.strength = strength;

            this.phrases.add(phrase.getBytes());
        }

        /**
         * Adds a new phrase for token generation
         *
         * @param phrase The phrase to add
         * @return This builder
         */
        public Builder addPhrase(String phrase) {
            phrases.add(phrase.getBytes());
            return this;
        }

        /**
         * Adds a new phrase for token generation
         *
         * @param phrase The phrase to add
         * @return This builder
         */
        public Builder addPhrase(byte[] phrase) {
            phrases.add(phrase);
            return this;
        }

        /**
         * Adds a new phrase for token generation
         *
         * @param phrase The phrase to add
         * @return This builder
         */
        public Builder addPhrase(long phrase) {
            phrases.add(ByteBuffer.allocate(Long.SIZE/Byte.SIZE).putLong(phrase).array());
            return this;
        }

        /**
         * Adds a new phrase for token generation
         *
         * @param phrase The phrase to add
         * @return This builder
         */
        public Builder addPhrase(Class phrase) {
            phrases.add(phrase.getName().getBytes());
            return this;
        }

        /**
         * Builds the token
         *
         * @return The generated token
         */
        public Token build() {
            return new Token(this);
        }
    }
}
