#include "include/tree.hh"
#include "include/tree_util2.hh"

class Node {
public:
    Node() : x(3){};
    ~Node();
    int x;
    friend std::ostream& operator<<(std::ostream& os, const Node& node) {
        node.print(os);
        return os;
    }
    virtual void print(std::ostream& os) const {
        os << x;
    }
};

class Subnode : public Node{
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
    tree<Node*> t2;
    auto top2 = t2.begin();
    Node * x = new Node();
    auto next2 = t2.insert(top2, x);
    Node * y = new Subnode();
    t2.append_child(next2, y);
    kptree::print_tree_bracketed(t2);

    return 0;
}