#include "include/tree.hh"
#include "include/tree_util2.hh"

class SymbolTableNode {
public:
    SymbolTableNode() : x(3){};
    ~SymbolTableNode();
    int x;
    friend std::ostream& operator<<(std::ostream& os, const SymbolTableNode& node) {
        node.print(os);
        return os;
    }
    virtual void print(std::ostream& os) const {
        os << x;
    }
};

class Subnode : public SymbolTableNode{
public:
    Subnode() : j('d'){/*std::cout << "this happened";*/};
    ~Subnode();
    char j;
    friend std::ostream& operator<<(std::ostream& os, const Subnode& node) {
        node.print(os);
        std::cout << "this shouldnt happen, if it does oh no";
        return os;
    }

    void print(std::ostream& os) const override {
        //std::cout << "i WANT this to happen";
        os << j;
    }
};


int main()
{
    //NOTE: This goes along with tree_util2.hh. Tree util2 is designed to (and only)
    //works with tree's templated with a pointer of some sort tree<something*>
    //We want to pass pointers to allow for polymorphism with the various node types

    //inheritance test
    tree<SymbolTableNode*> t2;
    auto top2 = t2.begin();
    SymbolTableNode * x = new SymbolTableNode();
    auto next2 = t2.insert(top2, x);
    SymbolTableNode * y = new Subnode();
    t2.append_child(next2, y);
    kptree::print_tree_bracketed(t2);

    return 0;
}