#ifndef ASTNODETYPE
# define ASTNODETYPE

#include <string>

enum ASTNODETYPE {
    ASTNODE,
    ASSIGNNODE,
    BITWISENODE,
    DECLNODE,
    FORNODE,
    IFNODE,
    LOGICALNODE,
    NONENODE,
    RELATIONALNODE,
    RETURNNODE,
    SEQNODE,
    TYPENODE,
    ARRAYNODE,
    BINARYMATHNODE,
    CASTNODE,
    CHARNODE,
    FLOATNODE,
    FUNCNODE,
    IDENTIFIERNODE,
    INTNODE,
    STRINGNODE,
    UNARYNODE,
    WHILENODE
};

inline std::string nodeTypeToString(int token) {
    std::string str;
    switch (token) {
        case ASTNODE:
            str = "ASTNODE";
            break;
        case ASSIGNNODE:
            str = "ASSIGNNODE";
            break;
        case BITWISENODE:
            str = "BITWISENODE";
            break;
        case DECLNODE:
            str = "DECLNODE";
            break;
        case FORNODE:
            str = "FORNODE";
            break;
        case IFNODE:
            str = "IFNODE";
            break;
        case LOGICALNODE:
            str = "LOGICALNODE";
            break;
        case NONENODE:
            str = "NONENODE";
            break;
        case RELATIONALNODE:
            str = "RELATIONALNODE";
            break;
        case RETURNNODE:
            str = "RETURNNODE";
            break;
        case SEQNODE:
            str = "SEQNODE";
            break;
        case TYPENODE:
            str = "TYPENODE";
            break;
        case ARRAYNODE:
            str = "ARRAYNODE";
            break;
        case BINARYMATHNODE:
            str = "BINARYMATHNODE";
            break;
        case CASTNODE:
            str = "CASTNODE";
            break;
        case CHARNODE:
            str = "CHARNODE";
            break;
        case FLOATNODE:
            str = "FLOATNODE";
            break;
        case FUNCNODE:
            str = "FUNCNODE";
            break;
        case IDENTIFIERNODE:
            str = "IDENTIFIERNODE";
            break;
        case INTNODE:
            str = "INTNODE";
            break;
        case STRINGNODE:
            str = "STRINGNODE";
            break;
        case UNARYNODE:
            str = "UNARYNODE";
            break;
        case WHILENODE:
            str = "WHILENODE";
            break;
        default:
            str = "NODETYPENOTDEFINED";
            break;
    }
    return str;
}

#endif