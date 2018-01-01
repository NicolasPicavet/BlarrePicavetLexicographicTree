package project;

import gui.MainWindow;
import tree.AbstractNode;
import tree.LexicographicTree;
import tree.Node;

import javax.swing.*;
import javax.swing.event.TreeModelListener;
import javax.swing.tree.*;
import java.util.Enumeration;

privileged public aspect Visualization {

    //JTree jTree;

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

    private DefaultTreeModel LexicographicTree.treeModel;

    private JTree LexicographicTree.view;

    public void LexicographicTree.setView(JTree jTree) {
        view = jTree;
    }

    public DefaultMutableTreeNode LexicographicTree.getRoot() {
        return root.treeNode;
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

    private DefaultMutableTreeNode AbstractNode.treeNode = new DefaultMutableTreeNode("default");

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
    }

    pointcut addNodePointcut(String s, LexicographicTree tree) : call(AbstractNode AbstractNode.add(String)) && args(s) && this(tree);
    after(String s, LexicographicTree tree) returning(AbstractNode node) : addNodePointcut(s, tree) {
        System.out.println("Pointcut LT.add: " + s);
    }

    /*pointcut constructorLexicographicTree() : call(public LexicographicTree.new());
    after() returning(LexicographicTree tree) : constructorLexicographicTree() {
        System.out.println("Pointcut LT.new");
        tree.treeModel = new DefaultTreeModel(tree.getRoot());
        tree.view.setModel(tree.treeModel);
    }*/

    pointcut setViewPointcut(LexicographicTree tree) : call(void LexicographicTree.setView(JTree)) && target(tree);
    after(LexicographicTree tree) : setViewPointcut(tree) {
        System.out.println("Pointcut LT.set.view");
        tree.treeModel = new DefaultTreeModel(tree.getRoot());
        tree.view.setModel(tree.treeModel);
    }

    pointcut writeNodeValue(char newValue, Node node) : set(private char Node.value) && args(newValue) && target(node);
    after(char newValue, Node node) : writeNodeValue(newValue, node) {
        System.out.println("Pointcut Node.set.value: " + newValue);
        node.treeNode = new DefaultMutableTreeNode(newValue);
    }

    /*pointcut writeNodeChild(Node node) : set(private AbstractNode Node.child) && args(AbstractNode) && target(node);
    before(Node node) : writeNodeChild(node) {
        System.out.println("Pointcut before Node.set.child");
        node.treeNode.remove(node.child.treeNode);
    }
    after(Node node) : writeNodeChild(node) {
        System.out.println("Pointcut after Node.set.child");
        node.treeNode.add(node.child.treeNode);
    }*/

    /*pointcut writeAbstractNodeBrother(AbstractNode abstractNode) : set(protected AbstractNode AbstractNode.brother) && args(AbstractNode) && target(abstractNode);
    before(AbstractNode abstractNode) : writeAbstractNodeBrother(abstractNode) {
        System.out.println("Pointcut before AbstractNode.set.brother");
        DefaultMutableTreeNode parent = (DefaultMutableTreeNode) abstractNode.treeNode.getParent();
        if (abstractNode.brother != null)
            parent.remove(abstractNode.brother.treeNode);
    }
    after(AbstractNode abstractNode) : writeAbstractNodeBrother(abstractNode) {
        System.out.println("Pointcut after AbstractNode.set.brother");
        DefaultMutableTreeNode parent = (DefaultMutableTreeNode) abstractNode.treeNode.getParent();
        if (abstractNode.brother != null)
            parent.add(abstractNode.brother.treeNode);
    }*/

}
