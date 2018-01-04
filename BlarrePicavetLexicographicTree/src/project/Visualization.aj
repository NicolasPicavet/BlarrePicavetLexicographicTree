package project;

import gui.MainWindow;
import tree.AbstractNode;
import tree.LexicographicTree;
import tree.Node;
import tree.Mark;
import tree.EmptyNode;

import javax.swing.*;
import javax.swing.event.TreeModelListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.MutableTreeNode;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreeModel;
import javax.swing.tree.TreePath;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.List;

privileged public aspect Visualization {
	
    MainWindow mainWindow;

    /* TREE MODEL */

    declare parents : tree.LexicographicTree implements TreeModel;

    private DefaultTreeModel LexicographicTree.treeModel;

    private JTree LexicographicTree.view;

    public void LexicographicTree.setView(JTree jTree) {
        view = jTree;
        DefaultMutableTreeNode root = new DefaultMutableTreeNode(" ");
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

    private DefaultMutableTreeNode AbstractNode.treeNode = new DefaultMutableTreeNode(" ");

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

    // main
    pointcut mainPointcut(String[] args) : execution(public static void LexicographicTree.main(String[])) && args(args);
    after(String[] args) : mainPointcut(args) {
        System.out.println("Pointcut LT.main");

        // Open GUI
        mainWindow = new MainWindow("Arbre Lexicographic");
        mainWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainWindow.setVisible(true);
    }

    // value
    pointcut valueNodeConstructor() : call(public Node.new(AbstractNode, AbstractNode, char)) && args(AbstractNode, AbstractNode, char);
    after() returning(Node node) : valueNodeConstructor() {
        System.out.println("Pointcut Node.new: " + node.value);

        // Set the value of the Node to be displayed
        node.treeNode.setUserObject(node.value);
    }




    /*ADD*/

    // LT.add
    pointcut lexicographicTreeAddPointcut(String s, LexicographicTree tree) : call(AbstractNode AbstractNode.add(String)) && args(s) && this(tree);
    after(String s, LexicographicTree tree) returning(AbstractNode node) : lexicographicTreeAddPointcut(s, tree) {
        System.out.println("Pointcut LT.add: " + s);

        // Sorted insertion to List
        DefaultListModel listModel = mainWindow.getListModel();
        int i = 0;
        for (; i < listModel.size(); i++)
            if (((String) listModel.getElementAt(i)).compareTo(s) > 0)
                break;
        listModel.insertElementAt(s, i);

        // Add to JTree
        DefaultMutableTreeNode rootNode = (DefaultMutableTreeNode) tree.treeModel.getRoot();
        Enumeration rootChildren = rootNode.children();
        boolean rootHasChildren = rootChildren.hasMoreElements();
        // copy children references to a list
        List<DefaultMutableTreeNode> rootChildrenList = new ArrayList<>();
        while(rootChildren.hasMoreElements())
            rootChildrenList.add((DefaultMutableTreeNode) rootChildren.nextElement());
        rootNode.removeAllChildren();
        if (!rootHasChildren)
            // root level was empty, it is the first child added
            rootNode.add(node.treeNode);
        for (DefaultMutableTreeNode tn : rootChildrenList)
            // add all previous child to root
            rootNode.add(tn);

        // refresh JTree
        tree.treeModel.reload();
        mainWindow.expandAllNodes();
    }

    // set child !*.remove
    pointcut writeNodeChildAdd(Node node, AbstractNode newChild) : set(private AbstractNode Node.child) && !withincode(public * *.remove(String)) && args(newChild) && target(node);
    after(Node node, AbstractNode newChild) : writeNodeChildAdd(node, newChild) {
        System.out.println("Pointcut Node.set.child ADD");

        // Add Node child treeNode to Node treeNode
        node.treeNode.insert(newChild.treeNode, 0);
    }

    // set brother Mark.add
    pointcut writeMarkBrotherAdd(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : set(protected AbstractNode AbstractNode.brother) && withincode(public AbstractNode Mark.add(String)) && args(newBrotherValue) && this(executingNode) && target(targetNode);
    after(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : writeMarkBrotherAdd(executingNode, targetNode, newBrotherValue) {
        System.out.println("Pointcut Mark.set.brother ADD");

        // Mark line 28
        // executingNode and targetNode are the same
        // should not add if already present (added by Node line 54)
        DefaultMutableTreeNode parent = (DefaultMutableTreeNode) executingNode.treeNode.getParent();
        if (!parent.isNodeChild(newBrotherValue.treeNode))
            parent.add(newBrotherValue.treeNode);
    }

    // set brother Node.add
    pointcut writeNodeBrotherAdd(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : set(protected AbstractNode AbstractNode.brother) && withincode(public AbstractNode Node.add(String)) &&  args(newBrotherValue) && this(executingNode) && target(targetNode);
    after(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : writeNodeBrotherAdd(executingNode, targetNode, newBrotherValue) {
        System.out.println("Pointcut Node.set.brother ADD");

        DefaultMutableTreeNode parent = (DefaultMutableTreeNode) executingNode.treeNode.getParent();

        // Node line 54
        // executingNode and newBrotherValue are the same
        if (executingNode == newBrotherValue)
            parent.insert(targetNode.treeNode, parent.getIndex(executingNode.treeNode));

        // Node line 61
        else if(newBrotherValue.getParent() == null)
            parent.insert(newBrotherValue.treeNode, parent.getIndex(executingNode.treeNode) + 1);
    }



    /*REMOVE*/

    // LT.remove
    pointcut lexicographicTreeRemovePointcut(String s, LexicographicTree tree) : call(AbstractNode AbstractNode.remove(String)) && args(s) && this(tree);
    after(String s, LexicographicTree tree) returning(AbstractNode node) : lexicographicTreeRemovePointcut(s, tree) {
        System.out.println("Pointcut LT.remove: " + s);

        // Remove from List
        mainWindow.getListModel().removeElement(s);

        // Remove from JTree
        // nothing to do

        // refresh JTree
        tree.treeModel.reload();
        mainWindow.expandAllNodes();
    }

    // set child Node.remove
    pointcut writeNodeChildRemove(Node executingNode, AbstractNode newChildValue) : set(private AbstractNode Node.child) && withincode(public AbstractNode Node.remove(String)) && args(newChildValue) && this(executingNode);
    after(Node executingNode, AbstractNode newChildValue) : writeNodeChildRemove(executingNode, newChildValue) {
        System.out.println("Pointcut Node.set.child REMOVE");

        // Node line 73
        if (newChildValue instanceof EmptyNode)
            // executingNode has no child and need to remove itself from its parent
            executingNode.treeNode.removeFromParent();
    }

    // Mark.remove
    pointcut markRemove(Mark executingMark) : execution(public AbstractNode Mark.remove(String)) && this(executingMark);
    after(Mark executingMark) returning(AbstractNode returnedNode) : markRemove(executingMark) {
        System.out.println("Pointcut Mark.remove");

        // Mark line 35
        // returned value is the executingMark.brother
        // executingMark need to delete itself from its parent
        if (returnedNode != executingMark)
            executingMark.treeNode.removeFromParent();
    }

    /*
    TODO to remove if useless
    // set brother Mark.remove
    pointcut writeMarkBrotherRemove(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : set(protected AbstractNode AbstractNode.brother) && withincode(public AbstractNode Mark.remove(String)) && args(newBrotherValue) && this(executingNode) && target(targetNode);
    after(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : writeMarkBrotherRemove(executingNode, targetNode, newBrotherValue) {
        System.out.println("Pointcut Mark.set.brother REMOVE");

        // Mark line 36
    }

    // set brother Node.remove
    pointcut writeNodeBrotherRemove(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : set(protected AbstractNode AbstractNode.brother) && withincode(public AbstractNode Node.remove(String)) &&  args(newBrotherValue) && this(executingNode) && target(targetNode);
    after(AbstractNode executingNode, AbstractNode targetNode, AbstractNode newBrotherValue) : writeNodeBrotherRemove(executingNode, targetNode, newBrotherValue) {
        System.out.println("Pointcut Node.set.brother REMOVE");

        DefaultMutableTreeNode parent = (DefaultMutableTreeNode) executingNode.treeNode.getParent();

        // Node line 78
    }*/
}
