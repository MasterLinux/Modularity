/**
 * Grammar for parsing the value of the embed query parameter
 * which looks like "page(offset_0,limit_5)_fragment"
 */
grammar EmbedValue;

embedQuery
        : resourceQuery ('_' resourceQuery)*
        ;

resourceQuery
        : resource argumentList?
        ;

argumentList
        : '(' argument (',' argument)* ')'
        ;

argument
        : filter '_' Expression
        ;

/**
 * available resources
 */
resource
        : 'application'
        | 'page'
        | 'fragment'
        | 'module'
        ;

/**
 * available filters
 */
filter
        : 'limit'
        | 'offset'
        ;

fragment
Expression
        : [a-zA-Z0-9]+
        ;
