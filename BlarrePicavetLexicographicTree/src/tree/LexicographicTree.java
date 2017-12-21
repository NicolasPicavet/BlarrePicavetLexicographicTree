package tree;

import gui.MainWindow;

import javax.swing.*;

public class LexicographicTree {

	private AbstractNode root;

	public LexicographicTree() {
		root = new EmptyNode();
	}

	public boolean contains(String s) {
		return root.contains(s);
	}

	public boolean prefix(String s) {
		return root.prefix(s);
	}

	public int elementsCount() {
		return root.elementsCount();
	}

	public boolean add(String s) {
		try {
			root = root.add(s);
			return true;
		} catch (ImpossibleChangeException e) {
			return false;
		}
	}

	public boolean remove(String s) {
		try {
			root = root.remove(s);
			return true;
		} catch (ImpossibleChangeException e) {
			return false;
		}
	}

	public String toString() {
		return root.toString("");
	}

	public static void main(String[] args) {
		JFrame frame = new JFrame("Arbre Lexicographic");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		frame.setContentPane(MainWindow.getInstance().getView());

		frame.pack();
		frame.setVisible(true);
	}

}
