#include "include/tree.hh"
#include "include/tree_util.hh"

class SymbolTableNode {
public:
    SymbolTableNode() : x(3){};
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
    Subnode() : j('a'){std::cout << "this happened";};
    char j;
    friend std::ostream& operator<<(std::ostream& os, const Subnode& node) {
        node.print(os);
        std::cout << "this shouldnt happen, if it does oh no";
        return os;
    }

    void print(std::ostream& os) const override {
        std::cout << "i WANT this to happen";
        os << j;
    }
};


int main()
{
    //basic test
    tree<int> t;
    auto top = t.begin();
    auto next = t.insert(top, 0);
    //t.insert(next, 4);
    t.append_child(next, 1);
    auto here = t.append_child(next, 2);
    t.append_child(here, 4);
    auto deeper = t.insert(here, 3);
    t.append_child(deeper, 5);
    kptree::print_tree_bracketed(t);

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