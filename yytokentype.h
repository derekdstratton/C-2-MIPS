#ifndef YYTOKENTYPE
# define YYTOKENTYPE
enum yytokentype
{
    IDENTIFIER = 258,
    INTEGER_CONSTANT = 259,
    FLOATING_CONSTANT = 260,
    CHARACTER_CONSTANT = 261,
    ENUMERATION_CONSTANT = 262,
    STRING_LITERAL = 263,
    SIZEOF = 264,
    PTR_OP = 265,
    INC_OP = 266,
    DEC_OP = 267,
    LEFT_OP = 268,
    RIGHT_OP = 269,
    LE_OP = 270,
    GE_OP = 271,
    EQ_OP = 272,
    NE_OP = 273,
    AND_OP = 274,
    OR_OP = 275,
    MUL_ASSIGN = 276,
    DIV_ASSIGN = 277,
    MOD_ASSIGN = 278,
    ADD_ASSIGN = 279,
    SUB_ASSIGN = 280,
    LEFT_ASSIGN = 281,
    RIGHT_ASSIGN = 282,
    AND_ASSIGN = 283,
    XOR_ASSIGN = 284,
    OR_ASSIGN = 285,
    TYPEDEF_NAME = 286,
    TYPEDEF = 287,
    EXTERN = 288,
    STATIC = 289,
    AUTO = 290,
    REGISTER = 291,
    CHAR = 292,
    SHORT = 293,
    INT = 294,
    LONG = 295,
    SIGNED = 296,
    UNSIGNED = 297,
    FLOAT = 298,
    DOUBLE = 299,
    CONST = 300,
    VOLATILE = 301,
    VOID = 302,
    STRUCT = 303,
    UNION = 304,
    ENUM = 305,
    ELIPSIS = 306,
    RANGE = 307,
    CASE = 308,
    DEFAULT = 309,
    IF = 310,
    ELSE = 311,
    SWITCH = 312,
    WHILE = 313,
    DO = 314,
    FOR = 315,
    GOTO = 316,
    CONTINUE = 317,
    BREAK = 318,
    RETURN = 319,
    ERROR = 320,
    SEMI = 321,
    OPENCUR = 322,
    CLOSCUR = 323,
    COMMA = 324,
    ASSIGN = 325,
    COLON = 326,
    OPENSQ = 327,
    CLOSSQ = 328,
    STAR = 329,
    OPENPAR = 330,
    CLOSEPAR = 331,
    TERNARY = 332,
    BAR = 333,
    XOR = 334,
    AND = 335,
    LESSTH = 336,
    GREATH = 337,
    PLUS = 338,
    MINUS = 339,
    SLASH = 340,
    MODULO = 341,
    TILDE = 342,
    BANG = 343,
    PERIOD = 344,
    NEWLINE = 345
};
#endif