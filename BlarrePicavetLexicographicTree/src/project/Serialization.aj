package project;

import tree.LexicographicTree;
import java.io.Serializable;

import tree.*;

public aspect Serialization {
    declare parents : tree.LexicographicTree.java implements Serializable;

    void save(String filePath) {
        // TODO
    }

    void load(String filePath) {
        // TODO
    }


}
