package project;

import javax.swing.tree.TreeModel;
import javax.swing.tree.TreeNode;

import tree.*;

public aspect Visualization {



    // TODO LexicographicTree
    // add pointcut on initialization
        // add reference to a new JTree
    // add pointcut on editions
        // use reference inside node to report change

    // TODO Mark
    // in JTree if brother exists then brother is child of this Mark parent

    // TODO Node
    // add reference to JTree element

    /*declare parents : tree.LexicographicTree implements TreeModel;

    declare parents : tree.AbstractNode implements TreeNode;*/

    pointcut addPointcut(String s) : call(boolean LexicographicTree.add(String)) && args(s);

    after(String s) : addPointcut(s) {
        //System.out.println("Pointcut call aspect LT.add: " + s);
    }
}
