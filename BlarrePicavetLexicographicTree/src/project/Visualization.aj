package project;

import gui.MainWindow;
import tree.AbstractNode;
import tree.LexicographicTree;
import tree.Node;

import javax.swing.*;
import javax.swing.event.TreeModelListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreeModel;
import javax.swing.tree.TreePath;
import java.util.Enumeration;

privileged public aspect Visualization {

    /* TREE MODEL */

    declare parents : tree.LexicographicTree implements TreeModel;

    private DefaultTreeModel LexicographicTree.treeModel;

    private JTree LexicographicTree.view;

    public void LexicographicTree.setView(JTree jTree) {
        view = jTree;
        DefaultMutableTreeNode root = new DefaultMutableTreeNode("");
        treeModel = new DefaultTreeModel(root);
        view.setModel(treeModel);
    }

    public Object LexicographicTree.getRoot() {
        return treeModel.getRoot();
    }

    public Object LexicographicTree.getChild(Object parent, int index) {
        return treeModel.getChild(parent, index);
    }

    public int LexicographicTree.getChildCount(Object parent) {
        return treeModel.getChildCount(parent);
    }

    public boolean LexicographicTree.isLeaf(Object node) {
        return treeModel.isLeaf(node);
    }

    public void LexicographicTree.valueForPathChanged(TreePath path, Object newValue) {
        treeModel.valueForPathChanged(path, newValue);
    }

    public int LexicographicTree.getIndexOfChild(Object parent, Object child) {
        return treeModel.getIndexOfChild(parent, child);
    }

    public void LexicographicTree.addTreeModelListener(TreeModelListener l) {
        treeModel.addTreeModelListener(l);
    }

    public void LexicographicTree.removeTreeModelListener(TreeModelListener l) {
        treeModel.removeTreeModelListener(l);
    }

    /* TREE NODE */

    declare parents : tree.AbstractNode implements TreeNode;

    private DefaultMutableTreeNode AbstractNode.treeNode = new DefaultMutableTreeNode("");

    public int AbstractNode.getChildCount() {
        return treeNode.getChildCount();
    }

    public TreeNode AbstractNode.getChildAt(int childIndex) {
        return treeNode.getChildAt(childIndex);
    }

    public TreeNode AbstractNode.getParent() {
        return treeNode.getParent();
    }

    public int AbstractNode.getIndex(TreeNode node) {
        return treeNode.getIndex(node);
    }

    public boolean AbstractNode.getAllowsChildren() {
        return treeNode.getAllowsChildren();
    }

    public boolean AbstractNode.isLeaf() {
        return treeNode.isLeaf();
    }

    public Enumeration AbstractNode.children() {
        return treeNode.children();
    }

    /* POINTCUTS */

    pointcut mainPointcut(String[] args) : execution(public static void LexicographicTree.main(String[])) && args(args);
    after(String[] args) : mainPointcut(args) {
        System.out.println("Pointcut LT.main");
        MainWindow mainWindow = new MainWindow("Arbre Lexicographic");
        mainWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainWindow.setVisible(true);
    }

    pointcut lexicographicTreeAddPointcut(String s, LexicographicTree tree) : call(AbstractNode AbstractNode.add(String)) && args(s) && this(tree);
    after(String s, LexicographicTree tree) returning(AbstractNode node) : lexicographicTreeAddPointcut(s, tree) {
        System.out.println("Pointcut LT.add: " + s);
        DefaultMutableTreeNode root = ((DefaultMutableTreeNode) tree.getRoot());
        root.add(node.treeNode);
        // TODO use events to report changes
        tree.treeModel.nodeChanged((TreeNode) tree.getRoot());
        tree.treeModel.reload();
    }

    pointcut constructorNodePointcut() : call(public Node.new(AbstractNode, AbstractNode, char)) && args(AbstractNode, AbstractNode, char);
    after() returning(Node node) : constructorNodePointcut() {
        System.out.println("Pointcut Node.new: " + node.value);
        node.treeNode.setUserObject(node.value);
    }

    pointcut writeNodeChild(Node node, AbstractNode newChild) : set(private AbstractNode Node.child) && args(newChild) && target(node);
    /*before(Node node, AbstractNode newChild) : writeNodeChild(node, newChild) {
        System.out.println("Pointcut before Node.set.child");
        if (node.treeNode.isNodeChild(newChild.treeNode))
            node.treeNode.remove(newChild.treeNode);
    }*/
    after(Node node, AbstractNode newChild) : writeNodeChild(node, newChild) {
        System.out.println("Pointcut after Node.set.child");
        node.treeNode.insert(newChild.treeNode, 0);
    }

    pointcut writeAbstractNodeBrother(AbstractNode abstractNode, AbstractNode newBrother) : set(protected AbstractNode AbstractNode.brother) && args(newBrother) && target(abstractNode);
    after(AbstractNode abstractNode, AbstractNode newBrother) : writeAbstractNodeBrother(abstractNode, newBrother) {
        System.out.println("Pointcut after AbstractNode.set.brother");
        if (newBrother != null) {
            // left
            DefaultMutableTreeNode parent = (DefaultMutableTreeNode) newBrother.treeNode.getParent();
            if (parent != null)
                // TODO the insertion is at the correct index but for whatever reason its not done correctly
                parent.insert(abstractNode.treeNode, parent.getIndex(newBrother.treeNode));
            else {
                // right
                parent = (DefaultMutableTreeNode) abstractNode.treeNode.getParent();
                if (parent != null)
                    parent.insert(newBrother.treeNode, parent.getIndex(abstractNode.treeNode) + 1);
            }
        }
    }

}
