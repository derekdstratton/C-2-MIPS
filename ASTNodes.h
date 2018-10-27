#ifndef PROJECT_ASTNODES_H
#define PROJECT_ASTNODES_H

#include <list>
#include "include/tree.hh"

class ASTNode {
public:
    ASTNode() {
        nodeLabel = "NA";
        //cout << "default";
    }
    ASTNode(string label, int line, int col, list<ASTNode*> children) {
        nodeLabel = label;
        lineNum = line;
        colNum = col;
        childrenNodes = children;
    }

    list<ASTNode*> getChildren() {
        return childrenNodes;
    }

    /** Copies the ASTNode into a tree.hh tree
     *
     * @param root
     * @param ast A tree.hh to be copied into
     */
    static void copyTree(ASTNode*& root, tree<ASTNode*> & ast) {
        //Make sure the ast is clear
        ast.clear();
        //first insert the top
        auto firstNode = ast.insert(ast.begin(), root);
        //now add the children
        copyTreeHelper(root, ast, firstNode);

    }

    virtual int getType(){
        //todo this should not be a int, it should be an enum
        //also this should throw some type of error if called, only for derived
        return -1; //fail
    };
    //todo make a virtual get value function for returning the value. what type should it be?


    friend std::ostream& operator<<(std::ostream& os, const ASTNode& node) {
        node.printNode(os);
        return os;
    }
protected:
    string nodeLabel;
    int lineNum;
    int colNum;
    list<ASTNode *> childrenNodes;
    //source code?
    virtual void printNode(std::ostream& os) const {
        os << nodeLabel;
    }

    /**
     *
     * @param src_node
     * @param ast
     * @param iRoot
     */
    static void copyTreeHelper(ASTNode*& src_node, tree<ASTNode*> & ast, typename tree<ASTNode*>::iterator iRoot) {
        //Node has children, insert them
        if (src_node->getChildren().size() != 0) {
            for (auto &child : src_node->getChildren()) {
                cout << *child;
                auto newRoot = ast.append_child(iRoot, child);
                copyTreeHelper(child, ast, newRoot);
            }
        }
    }
};

class TypeValueNode : ASTNode {
public:
    TypeValueNode(string label, int line, int col, list<ASTNode*> children, int val, string type) {
        nodeLabel = label;
        lineNum = line;
        colNum = col;
        childrenNodes = children;
        nodeVal = val;
        //todo deal with type using enum
    };
private:
    int nodeVal;
    void printNode(std::ostream& os) const {
        os << nodeLabel << ": " << nodeVal;
    }
};

#endif //PROJECT_ASTNODES_H
