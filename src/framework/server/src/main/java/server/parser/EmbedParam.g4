/**
 * Grammar for parsing the value of the embed query parameter
 * which looks like "page(offset_0,limit_5).fragment"
 */
grammar EmbedParam;

embedQuery
        : resourceQuery (QUERY_SEPARATOR resourceQuery)*
        ;

resourceQuery
        : resource filterList?
        ;

filterList
        : ARGUMENT_LIST_START filter (ARGUMENT_SEPARATOR filter)* ARGUMENT_LIST_END
        ;

/**
 * available resources
 */
resource
        : RESOURCE_APPLICATIONS
        | RESOURCE_PAGES
        | RESOURCE_FRAGMENTS
        | RESOURCE_MODULES
        ;

/**
 * available filters
 */
filter
        : numberFilter FILTER_EQUALS IntQuery
        ;

numberFilter
        : FILTER_LIMIT
        | FILTER_OFFSET
        ;

CharQuery
        : [a-zA-Z0-9]+
        ;

IntQuery
        : [0-9]+
        ;

//separators
ARGUMENT_SEPARATOR : ',';
ARGUMENT_LIST_START : '(';
ARGUMENT_LIST_END : ')';
QUERY_SEPARATOR : '.';

//operators
FILTER_EQUALS : '_';

//resources
RESOURCE_APPLICATIONS : 'applications';
RESOURCE_PAGES : 'pages';
RESOURCE_FRAGMENTS : 'fragments';
RESOURCE_MODULES : 'modules';

//filters
FILTER_LIMIT : 'limit';
FILTER_OFFSET : 'offset';
