package project;

import gui.MainWindow;
import tree.AbstractNode;
import tree.LexicographicTree;
import tree.Node;

import javax.swing.*;
import javax.swing.event.TreeModelListener;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.MutableTreeNode;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreeModel;
import javax.swing.tree.TreePath;

import java.util.Comparator;
import java.util.Enumeration;

privileged public aspect Visualization {
	
    MainWindow mainWindow;

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
        mainWindow = new MainWindow("Arbre Lexicographic");
        mainWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainWindow.setVisible(true);
    }

    pointcut lexicographicTreeAddPointcut(String s, LexicographicTree tree) : call(AbstractNode AbstractNode.add(String)) && args(s) && this(tree);
    after(String s, LexicographicTree tree) returning(AbstractNode node) : lexicographicTreeAddPointcut(s, tree) {
        System.out.println("Pointcut LT.add: " + s);
        
        //Add to List
        mainWindow.getListModel().add(0, s);
        mainWindow.sortList();
		
        //Add to JTree
        DefaultMutableTreeNode root = ((DefaultMutableTreeNode) tree.getRoot());
        root.add(node.treeNode);
        tree.treeModel.nodeChanged((TreeNode) tree.getRoot());
        sortTree(root); //Sort JTree first level
        tree.treeModel.reload();
        
        mainWindow.expandAllNodes();
    }

    pointcut constructorNodePointcut() : call(public Node.new(AbstractNode, AbstractNode, char)) && args(AbstractNode, AbstractNode, char);
    after() returning(Node node) : constructorNodePointcut() {
        System.out.println("Pointcut Node.new: " + node.value);
        node.treeNode.setUserObject(node.value);
    }

    pointcut writeNodeChild(Node node, AbstractNode newChild) : set(private AbstractNode Node.child) && args(newChild) && target(node);
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
    
    
	/**
	 * Sort jTree alphabetically Taken from
	 * https://java-swing-tips.blogspot.fr/2013/09/how-to-sort-jtree-nodes.html
	 * 
	 * @param root
	 */
	public static void sortTree(DefaultMutableTreeNode root) {
		Enumeration e = root.depthFirstEnumeration();
		while (e.hasMoreElements()) {
			DefaultMutableTreeNode node = (DefaultMutableTreeNode) e.nextElement();
			if (!node.isLeaf()) {
				sort(node);
			}
		}
	}

	public static Comparator<DefaultMutableTreeNode> tnc = new Comparator<DefaultMutableTreeNode>() {
		@Override
		public int compare(DefaultMutableTreeNode a, DefaultMutableTreeNode b) {
			// Sort the parent and child nodes separately:
			if (a.isLeaf() && !b.isLeaf()) {
				return 1;
			} else if (!a.isLeaf() && b.isLeaf()) {
				return -1;
			} else {
				String sa = a.getUserObject().toString();
				String sb = b.getUserObject().toString();
				return sa.compareToIgnoreCase(sb);
			}
		}
	};

	// selection sort
	public static void sort(DefaultMutableTreeNode parent) {
		int n = parent.getChildCount();
		for (int i = 0; i < n - 1; i++) {
			int min = i;
			for (int j = i + 1; j < n; j++) {
				if (tnc.compare((DefaultMutableTreeNode) parent.getChildAt(min),
						(DefaultMutableTreeNode) parent.getChildAt(j)) > 0) {
					min = j;
				}
			}
			if (i != min) {
				MutableTreeNode a = (MutableTreeNode) parent.getChildAt(i);
				MutableTreeNode b = (MutableTreeNode) parent.getChildAt(min);
				parent.insert(b, i);
				parent.insert(a, min);
			}
		}
	}

}
