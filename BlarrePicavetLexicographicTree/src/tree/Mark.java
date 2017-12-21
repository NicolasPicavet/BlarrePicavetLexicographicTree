package tree;

public class Mark extends AbstractNode {

	public Mark(AbstractNode brother) {
		super(brother);
	}

	@Override
	public boolean contains(String s) {
		return s.isEmpty() || brother.contains(s);
	}

	@Override
	public boolean prefix(String s) {
		return s.isEmpty() || brother.prefix(s);
	}

	@Override
	public int elementsCount() {
		return 1 + brother.elementsCount();
	}

	@Override
	public AbstractNode add(String s) throws ImpossibleChangeException {
		if (s.isEmpty())
			throw new ImpossibleChangeException("adding was not possible");
		brother = brother.add(s);
		return this;
	}

	@Override
	public AbstractNode remove(String s) throws ImpossibleChangeException {
		if (s.isEmpty())
			return brother;
		brother = brother.remove(s);
		return this;
	}

	@Override
	public String toString(String s) {
		return s + "\n" + brother.toString(s);
	}

}
