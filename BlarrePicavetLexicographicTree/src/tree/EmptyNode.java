package tree;

public class EmptyNode extends AbstractNode {

	public EmptyNode() {
		super(null);
	}

	@Override
	public boolean contains(String s) {
		return false;
	}

	@Override
	public boolean prefix(String s) {
		return false;
	}

	@Override
	public int elementsCount() {
		return 0;
	}

	@Override
	public AbstractNode add(String s) throws ImpossibleChangeException {
		AbstractNode n = new Mark(this);
		for (int i = s.length() - 1; i >= 0; i --)
			n = new Node(new EmptyNode(), n, s.charAt(i));
		return n;
	}

	@Override
	public AbstractNode remove(String s) throws ImpossibleChangeException {
		throw new ImpossibleChangeException("remove is not possible");
	}

	@Override
	public String toString(String s) {
		return "";
	}

}
