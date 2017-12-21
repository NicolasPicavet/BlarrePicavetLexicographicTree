package tree;

public class Node extends AbstractNode {

	private char value;
	private AbstractNode child;

	public Node(AbstractNode brother, AbstractNode child, char value) {
		super(brother);
		if (child == null || child instanceof EmptyNode)
			throw new IllegalArgumentException("Null or EmptyNode is not allowed for child");
		this.value = value;
		this.child = child;
	}

	@Override
	public boolean contains(String s) {
		if (s.isEmpty())
			return false;
		char c = s.charAt(0);
		if (c < value)
			return false;
		if (c == value)
			return child.contains(s.substring(1));
		return brother.contains(s);
	}

	@Override
	public boolean prefix(String s) {
		if (s.isEmpty())
			return true;
		char c = s.charAt(0);
		if (c < value)
			return false;
		if (c == value)
			return child.prefix(s.substring(1));
		return brother.prefix(s);
	}

	@Override
	public int elementsCount() {
		return child.elementsCount() + brother.elementsCount();
	}

	@Override
	public AbstractNode add(String s) throws ImpossibleChangeException {
		if (s.isEmpty())
			return new Mark(this);
		char c = s.charAt(0);
		if (c < value) {
			AbstractNode n = new Mark(new EmptyNode());
			for (int i = s.length() - 1; i >= 0; i --)
				n = new Node(new EmptyNode(), n, s.charAt(i));
			n.brother = this;
			return n;
		}
		if (c == value) {
			child = child.add(s.substring(1));
			return this;
		}
		brother = brother.add(s);
		return this;
	}

	@Override
	public AbstractNode remove(String s) throws ImpossibleChangeException {
		if (s.isEmpty())
			throw new ImpossibleChangeException("remove is not possible");
		char c = s.charAt(0);
		if (c < value)
			throw new ImpossibleChangeException("remove is not possible");
		if (c == value) {
			child = child.remove(s.substring(1));
			if (child instanceof EmptyNode)
				return brother;
			return this;
		}
		brother = brother.remove(s);
		return this;
	}

	@Override
	public String toString(String s) {
		return child.toString(s + value) + brother.toString(s);
	}

}
