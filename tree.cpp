#include "include/tree.hh"
#include "include/tree_util.hh"

int main()
{
    tree<int> t;
    auto top = t.begin();
    auto next = t.insert(top, 3);
    //t.insert(next, 4);
    t.append_child(next, 5);
    auto here = t.append_child(next, 6);
    t.append_child(here, 7);
    auto deeper = t.insert(here, 8);
    t.append_child(deeper, 44);

    //t.insert(top, 10);

    kptree::print_tree_bracketed(t);
    return 0;
}