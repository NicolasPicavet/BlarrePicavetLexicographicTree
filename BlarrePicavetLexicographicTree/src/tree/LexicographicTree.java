package tree;

public class LexicographicTree {

	// TODO
	// add pointcut on initialization
		// add reference to a new JTree
	// add pointcut on editions
		// use reference inside node to report change

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
		// TODO Auto-generated method stub

	}

}
