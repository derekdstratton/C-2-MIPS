#include <iostream>
#include <string>
#include <fstream>

//#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/undirected_graph.hpp>
#include <boost/graph/graphviz.hpp>

typedef boost::undirected_graph<boost::no_property> Graph;

int main(int argc, char*argv[])
{
    if(argc < 2)
    {
        std::cerr << "Required: filename.dot" << std::endl;
        return -1;
    }
    std::string filename = argv[1];
    std::ofstream fout(filename.c_str());

    Graph g;
    Graph::vertex_descriptor v0 = g.add_vertex();
    Graph::vertex_descriptor v1 = g.add_vertex();
    boost::add_edge(v0,v1,g);

    boost::write_graphviz(fout,g);

    return 0;
}