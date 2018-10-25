#include "include/tree.hh"
#include "include/tree_util.hh"

int main()
{
    tree<int> t;
    auto top = t.begin();
    auto next = t.insert(top, 0);
    //t.insert(next, 4);
    t.append_child(next, 1);
    auto here = t.append_child(next, 2);
    t.append_child(here, 4);
    auto deeper = t.insert(here, 3);
    t.append_child(deeper, 5);

    //t.insert(top, 10);

    kptree::print_tree_bracketed(t);
    return 0;
}