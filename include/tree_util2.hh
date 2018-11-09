/*

	A collection of miscellaneous utilities that operate on the templated
	tree.hh class.


	Copyright (C) 2001-2009  Kasper Peeters <kasper.peeters@aei.mpg.de>

	(At the moment this only contains a printing utility, thanks to Linda
	Buisman <linda.buisman@studentmail.newcastle.edu.au>)

   This program is free software: you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

#ifndef tree_util_hh_
#define tree_util_hh_

#include <iostream>
#include <fstream>
#include "tree.hh"
#include <string>

extern std::string ASTPATH;
int counter = 0;
//int parent;

namespace kptree {

    template<class T>
    void print_tree_bracketed(const tree<T>& t, std::ostream& str=std::cout);

    template<class T>
    void print_subtree_bracketed(const tree<T>& t, typename tree<T>::iterator iRoot,
                                 std::ostream& str=std::cout, int parent=0);



// Iterate over all roots (the head) and print each one on a new line
// by calling printSingleRoot.

    template<class T>
    void print_tree_bracketed(const tree<T>& t, std::ostream& str)
    {
        counter = 0; //reset this here in case someone calls print_tree multiple times
        std::ofstream ofs;
        ofs.open(ASTPATH, std::ofstream::out | std::ofstream::trunc);
        ofs << "graph G {" << std::endl;
        ofs.close();
        int headCount = t.number_of_siblings(t.begin());
        int headNum = 0;
        for(typename tree<T>::sibling_iterator iRoots = t.begin(); iRoots != t.end(); ++iRoots, ++headNum) {
            print_subtree_bracketed(t,iRoots,str, 0);
            if (headNum != headCount) {
                str << std::endl;
            }
        }
        ofs.open(ASTPATH, std::ios::app);
        ofs << "}" << std::endl;
        ofs.close();
    }


// Print everything under this root in a flat, bracketed structure.

    template<class T>
    void print_subtree_bracketed(const tree<T>& t, typename tree<T>::iterator iRoot, std::ostream& str, int parent)
    {
        std::ofstream ofile;
        ofile.open(ASTPATH, std::ios::app);
        if(t.empty()) return;
        if (t.number_of_children(iRoot) == 0) {
            //ofile << counter << ";" << std::endl;
            ofile << counter << "[label=" << **iRoot << "];" << std::endl;
            str << **iRoot;
            if (counter != 0) {
                ofile << parent << "--" << counter << ";" << std::endl;
            }
            counter++;
        }
        else {
            // parent
            //ofile << counter << ";" << std::endl;
            ofile << counter << "[label=" << **iRoot << "];" << std::endl;
            int new_parent = counter;
            if (counter != 0) {
                ofile << parent << "--" << counter << ";" << std::endl;
            }
            counter++;
            str << **iRoot;
            str << "(";
            // child1, ..., childn
            int siblingCount = t.number_of_siblings(t.begin(iRoot));
            int siblingNum;
            typename tree<T>::sibling_iterator iChildren;
            for (iChildren = t.begin(iRoot), siblingNum = 0; iChildren != t.end(iRoot); ++iChildren, ++siblingNum) {
                // recursively print child
                print_subtree_bracketed(t,iChildren,str, new_parent);

                // comma after every child except the last one
                if (siblingNum != siblingCount ) {
                    str << ", ";
                }
            }
            str << ")";
        }
    }

}

#endif