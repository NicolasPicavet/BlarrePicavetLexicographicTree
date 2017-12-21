package tree;

public abstract class AbstractNode {

	protected AbstractNode brother;

	public AbstractNode(AbstractNode brother) {
		if (brother == null && !(this instanceof EmptyNode))
			throw new IllegalArgumentException("Null is not allowed for brother");
		this.brother = brother;
	}

	public abstract boolean contains(String s);

	public abstract boolean prefix(String s);

	public abstract int elementsCount();

	public abstract AbstractNode add(String s) throws ImpossibleChangeException;

	public abstract AbstractNode remove(String s) throws ImpossibleChangeException;

	public abstract String toString(String s); // return elements separated by \n

	public static void main(String[] args) {
		LexicographicTree tree = new LexicographicTree();
		System.out.print("Current state: ");
		System.out.println("--->" + tree.toString() + "<---");
		System.out.println(tree.elementsCount());
		System.out.println("adding \"java\": " + tree.add("java"));
		System.out.println("adding \"programming\": " + tree.add("programming"));
		System.out.println("adding \"program\": " + tree.add("program"));
		System.out.println("adding \"practical\": " + tree.add("practical"));
		System.out.print("Current state: ");
		System.out.println("--->" + tree.toString() + "<---");
		System.out.println(tree.elementsCount());
		System.out.println("adding \"program\": " + tree.add("program"));
		System.out.println("adding \"program\": " + tree.add("program"));
		System.out.println("adding \"paradigm\": " + tree.add("paradigm"));
		System.out.print("Current state: ");
		System.out.println("--->" + tree.toString() + "<---");
		System.out.println(tree.elementsCount());
		System.out.println("removing \"absent\": " + tree.remove("absent"));
		System.out.println("removing \"elsewhere\": " + tree.remove("elsewhere"));
		System.out.println("removing \"paradigm\": " + tree.remove("paradigm"));
		System.out.print("Current state: ");
		System.out.println("--->" + tree.toString() + "<---");
		System.out.println(tree.elementsCount());
		
		tree.save(System.getProperty("user.dir")+"/"+"test.txt");
		
	}

}
