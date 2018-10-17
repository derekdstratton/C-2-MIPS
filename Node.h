#ifndef PROJECT_NODE_H
#define PROJECT_NODE_H

#include <ostream>
using namespace std;

class Node {
  public:
    Node(int var);
    int i;
    void * thing;
    friend ostream& operator<<(ostream& os, const Node& node);
};


#endif //PROJECT_NODE_H
