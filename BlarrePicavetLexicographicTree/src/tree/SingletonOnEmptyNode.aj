package tree;

public aspect SingletonOnEmptyNode {
	private EmptyNode instance = new EmptyNode();
	
	pointcut emptyNodeConstructorCall(Object caller) : call (public EmptyNode.new()) && ! within(SingletonOnEmptyNode) && this(caller);
	
	EmptyNode around(Object caller) : emptyNodeConstructorCall(caller) {
		System.out.println("Class of the caller: " + caller.getClass().getSimpleName());
		return instance;
	}

}
