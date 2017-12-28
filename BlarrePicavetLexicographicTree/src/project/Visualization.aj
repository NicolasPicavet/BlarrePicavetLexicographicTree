package project;

import gui.MainWindow;
import tree.AbstractNode;
import tree.LexicographicTree;

import javax.swing.*;
import javax.swing.event.TreeModelListener;
import javax.swing.tree.*;
import java.util.Enumeration;

privileged public aspect Visualization {

    JTree jTree;

    // TODO LexicographicTree
    // add pointcut on initialization
        // add reference to a new JTree
    // add pointcut on editions
        // use reference inside node to report change

    // TODO Mark
    // in JTree if brother exists then brother is child of this Mark parent

    // TODO Node
    // add reference to a JTree element

    /* TREE MODEL */

    declare parents : tree.LexicographicTree implements TreeModel;

    public Object LexicographicTree.getRoot() {
        return root;
    }

    public Object LexicographicTree.getChild(Object parent, int index) {
        return null;
    }

    public int LexicographicTree.getChildCount(Object parent) {
        return 0;
    }

    public boolean LexicographicTree.isLeaf(Object node) {
        return false;
    }

    public void LexicographicTree.valueForPathChanged(TreePath path, Object newValue) {

    }

    public int LexicographicTree.getIndexOfChild(Object parent, Object child) {
        return 0;
    }

    public void LexicographicTree.addTreeModelListener(TreeModelListener l) {

    }

    public void LexicographicTree.removeTreeModelListener(TreeModelListener l) {

    }

    /* TREE NODE */

    declare parents : tree.AbstractNode implements TreeNode;

    public int AbstractNode.getChildCount() {
        return 0;
    }

    public TreeNode AbstractNode.getChildAt(int childIndex) {
        return null;
    }

    public TreeNode AbstractNode.getParent() {
        return null;
    }

    public int AbstractNode.getIndex(TreeNode node) {
        return 0;
    }

    public boolean AbstractNode.getAllowsChildren() {
        return false;
    }

    public boolean AbstractNode.isLeaf() {
        return false;
    }

    public Enumeration AbstractNode.children() {
        return null;
    }

    /* POINTCUTS */

    pointcut mainPointcut(String[] args) : execution(public static void LexicographicTree.main(String[])) && args(args);
    after(String[] args) : mainPointcut(args) {
        System.out.println("Pointcut LT.main");
        MainWindow mainWindow = new MainWindow("Arbre Lexicographic");
        mainWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainWindow.setVisible(true);

        jTree = mainWindow.getJTree();
    }

    pointcut addNodePointcut(String s, LexicographicTree tree) : call(AbstractNode AbstractNode.add(String)) && args(s) && this(tree);
    after(String s, LexicographicTree tree) returning(AbstractNode node) : addNodePointcut(s, tree) {
        System.out.println("Pointcut LT.add: " + s);




        /*DefaultTreeModel model = (DefaultTreeModel) tree;
        DefaultMutableTreeNode root = (DefaultMutableTreeNode) model.getRoot();
        root.add(new DefaultMutableTreeNode("another_child"));
        model.reload(root);*/
    }

    pointcut removePointcut(String s) : call(boolean LexicographicTree.remove(String)) && args(s);
    after(String s) : removePointcut(s) {
        System.out.println("Pointcut LT.remove: " + s);
    }

    /*pointcut constructorNode() : call(Node.new());
    after() : constructorNode() {
        //System.out.println("Pointcut call aspect LT.new");
    }*/
}
