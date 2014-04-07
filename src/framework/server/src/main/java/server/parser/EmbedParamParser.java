package server.parser;

import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CharStream;

import java.io.IOException;

/**
 * Created by Christoph on 10.03.14.
 */
public class EmbedParamParser {
    void parse(String fileName) throws IOException {
        CharStream input = new ANTLRFileStream(fileName);
        //EmbedParamLexer lexer = new EmbedParamLexer(input);
    }
}
