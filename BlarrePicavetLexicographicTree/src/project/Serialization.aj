package project;

import tree.LexicographicTree;

public aspect Serialization {
    declare parents : tree.LexicographicTree.java implements Serializable;

    private LexicographicTree instance = new LexicographicTree();

    void save(String filePath) {
        // TODO
    }

    void load(String filePath) {
        // TODO
    }


}
