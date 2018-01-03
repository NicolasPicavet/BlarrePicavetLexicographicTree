package gui;

import com.intellij.uiDesigner.core.GridConstraints;
import com.intellij.uiDesigner.core.GridLayoutManager;
import com.intellij.uiDesigner.core.Spacer;
import tree.LexicographicTree;

import javax.swing.*;
import javax.swing.tree.DefaultTreeCellRenderer;

import java.awt.*;
import java.awt.event.*;
import java.text.Collator;

public class MainWindow extends JFrame {

	private JTree tree;
	private JTabbedPane tabPanel;
	private JList list;
	private JTextField inputText;
	private JButton addButton;
	private JButton deleteButton;
	private JButton searchButton;
	private JButton prefixButton;
	private JPanel menuPane;
	private JPanel actionBar;
	private JPanel treeTab;
	private JPanel listTab;
	private JPanel view;
	private JTextPane statusText;

	private JMenuBar menuBar = new JMenuBar();
	private JMenu fileMenu = new JMenu("File");
	private JMenuItem loadMenuItem = new JMenuItem("Load");
	private JMenuItem saveMenuItem = new JMenuItem("Save");
	private JMenu helpMenu = new JMenu("Help");

	private static DefaultListModel<String> listModel = new DefaultListModel<>();

	private LexicographicTree lexicographicTree;

	public MainWindow(String title) {
		super(title);
		setContentPane(view);
		pack();
		init();
	}

	private void init() {

		lexicographicTree = new LexicographicTree();

		// Models
		lexicographicTree.setView(tree);
		list.setModel(listModel);

		// Menu
		fileMenu.add(loadMenuItem);
		fileMenu.add(saveMenuItem);
		menuBar.add(fileMenu);
		menuBar.add(helpMenu);
		setJMenuBar(menuBar);

		// Listeners
		addButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				addText();
			}
		});
		deleteButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				removeText();
			}
		});
		searchButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				String toSearch = inputText.getText();
				if (lexicographicTree.contains(toSearch))
					statusText.setText("\"" + toSearch + "\" found");
				else
					statusText.setText("\"" + toSearch + "\" not found");
			}
		});
		prefixButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				String toSearch = inputText.getText();
				if (lexicographicTree.prefix(toSearch))
					statusText.setText("\"" + toSearch + "\" found");
				else
					statusText.setText("\"" + toSearch + "\" not found");
			}
		});
		inputText.addKeyListener(new KeyAdapter() {
			@Override
			public void keyTyped(KeyEvent e) {
				if (e.getKeyChar() == e.VK_ENTER)
					addText();
				super.keyTyped(e);
			}
		});
		
		list.addMouseListener(new MouseAdapter() {
		    public void mouseClicked(MouseEvent evt) {
		        if (evt.getClickCount() == 2) { // Double-click detected
		            int index = list.locationToIndex(evt.getPoint());
		            inputText.setText( (String)list.getModel().getElementAt(index) );
		        }
		    }
		});

		loadMenuItem.addActionListener(new OpenFileListener());
		saveMenuItem.addActionListener(new SaveFileListener());

		// Remove folder icon
		DefaultTreeCellRenderer renderer = (DefaultTreeCellRenderer) tree.getCellRenderer();
		renderer.setLeafIcon(null);
		renderer.setClosedIcon(null);
		renderer.setOpenIcon(null);
	}

	public void addText() {
		String toAdd = inputText.getText();
		if (lexicographicTree.add(toAdd))
			statusText.setText("\"" + toAdd + "\" added");
		else
			statusText.setText("\"" + toAdd + "\" not added");
	}

	public void removeText() {
		String toRemove = inputText.getText();
		if (lexicographicTree.remove(toRemove))
			statusText.setText("\"" + toRemove + "\" removed");
		else
			statusText.setText("\"" + toRemove + "\" not removed");
	}

	public void sortList() {
		int numItems = listModel.getSize();
		String[] a = new String[numItems];
		for (int i = 0; i < numItems; i++)
			a[i] = (String) listModel.getElementAt(i);
		sortArray(Collator.getInstance(), a);
		for (int i = 0; i < numItems; i++)
			listModel.setElementAt(a[i], i);
	}

	public void sortArray(Collator collator, String[] strArray) {
		String tmp;
		if (strArray.length == 1)
			return;
		for (int i = 0; i < strArray.length; i++) {
			for (int j = i + 1; j < strArray.length; j++) {
				if (collator.compare(strArray[i], strArray[j]) > 0) {
					tmp = strArray[i];
					strArray[i] = strArray[j];
					strArray[j] = tmp;
				}
			}
		}
	}

	private void reset() {
		lexicographicTree = new LexicographicTree();
		lexicographicTree.setView(tree);
		listModel = new DefaultListModel<>();
		list.setModel(listModel);
	}

	/**
	 * "Open" dialog (based on:
	 * https://stackoverflow.com/questions/3548140/how-to-open-and-save-using-java)
	 */
	class OpenFileListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			JFileChooser c = new JFileChooser();
			int rVal = c.showOpenDialog(MainWindow.this);
			if (rVal == JFileChooser.APPROVE_OPTION) {
				reset();
				if (lexicographicTree.load(c.getCurrentDirectory().toString() + "/" + c.getSelectedFile().getName()))
					statusText.setText(c.getSelectedFile().getName() + " file loaded");
			}
		}
	}

	/**
	 * "Save" dialog
	 */
	class SaveFileListener implements ActionListener {
		public void actionPerformed(ActionEvent e) {
			JFileChooser c = new JFileChooser();
			int rVal = c.showSaveDialog(MainWindow.this);
			if (rVal == JFileChooser.APPROVE_OPTION) {
				if (lexicographicTree.save(c.getCurrentDirectory().toString() + "/" + c.getSelectedFile().getName()))
					statusText.setText(c.getSelectedFile().getName() + " file saved");
			}
		}
	}

	public DefaultListModel<String> getListModel() {
		return listModel;
	}

	/**
	 * Expand all JTree nodes Taken from
	 * https://stackoverflow.com/questions/15210979/how-do-i-auto-expand-a-jtree-when-setting-a-new-treemodel
	 * 
	 * @param tree
	 * @param startingIndex
	 * @param rowCount
	 */
	public void expandAllNodes() {
		for (int i = 0; i < tree.getRowCount(); i++) {
			tree.expandRow(i);
		}
	}

	{
		// GUI initializer generated by IntelliJ IDEA GUI Designer
		// >>> IMPORTANT!! <<<
		// DO NOT EDIT OR ADD ANY CODE HERE!
		$$$setupUI$$$();
	}

	/**
	 * Method generated by IntelliJ IDEA GUI Designer >>> IMPORTANT!! <<< DO NOT
	 * edit this method OR call it in your code!
	 *
	 * @noinspection ALL
	 */
	private void $$$setupUI$$$() {
		view = new JPanel();
		view.setLayout(new GridLayoutManager(4, 1, new Insets(0, 0, 0, 0), -1, -1));
		tabPanel = new JTabbedPane();
		view.add(tabPanel,
				new GridConstraints(2, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, null,
						new Dimension(200, 200), null, 0, false));
		treeTab = new JPanel();
		treeTab.setLayout(new GridLayoutManager(1, 1, new Insets(0, 0, 0, 0), -1, -1));
		tabPanel.addTab("Tree", treeTab);
		final JScrollPane scrollPane1 = new JScrollPane();
		scrollPane1.setVerticalScrollBarPolicy(22);
		treeTab.add(scrollPane1,
				new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_WANT_GROW,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_WANT_GROW, null, null, null,
						0, false));
		tree = new JTree();
		scrollPane1.setViewportView(tree);
		listTab = new JPanel();
		listTab.setLayout(new GridLayoutManager(1, 1, new Insets(0, 0, 0, 0), -1, -1));
		tabPanel.addTab("List", listTab);
		final JScrollPane scrollPane2 = new JScrollPane();
		scrollPane2.setVerticalScrollBarPolicy(22);
		listTab.add(scrollPane2,
				new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_WANT_GROW,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_WANT_GROW, null, null, null,
						0, false));
		list = new JList();
		scrollPane2.setViewportView(list);
		actionBar = new JPanel();
		actionBar.setLayout(new GridLayoutManager(1, 5, new Insets(0, 10, 0, 10), -1, -1));
		view.add(actionBar,
				new GridConstraints(1, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW,
						GridConstraints.SIZEPOLICY_FIXED, null, null, null, 0, false));
		inputText = new JTextField();
		actionBar.add(inputText,
				new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_WEST, GridConstraints.FILL_HORIZONTAL,
						GridConstraints.SIZEPOLICY_WANT_GROW, GridConstraints.SIZEPOLICY_FIXED, null,
						new Dimension(150, 26), null, 0, false));
		addButton = new JButton();
		addButton.setText("Add");
		actionBar.add(addButton,
				new GridConstraints(0, 1, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW,
						GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
		deleteButton = new JButton();
		deleteButton.setText("Delete");
		actionBar.add(deleteButton,
				new GridConstraints(0, 2, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW,
						GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
		searchButton = new JButton();
		searchButton.setText("Search");
		actionBar.add(searchButton,
				new GridConstraints(0, 3, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW,
						GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
		prefixButton = new JButton();
		prefixButton.setText("Prefix");
		actionBar.add(prefixButton,
				new GridConstraints(0, 4, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW,
						GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
		menuPane = new JPanel();
		menuPane.setLayout(new GridLayoutManager(1, 1, new Insets(0, 10, 0, 10), -1, -1));
		view.add(menuPane,
				new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH,
						GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW,
						GridConstraints.SIZEPOLICY_FIXED, null, null, null, 0, false));
		final Spacer spacer1 = new Spacer();
		menuPane.add(spacer1, new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER,
				GridConstraints.FILL_HORIZONTAL, GridConstraints.SIZEPOLICY_WANT_GROW, 1, null, null, null, 0, false));
		statusText = new JTextPane();
		statusText.setMargin(new Insets(3, 10, 3, 10));
		view.add(statusText, new GridConstraints(3, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH,
				GridConstraints.SIZEPOLICY_WANT_GROW, GridConstraints.SIZEPOLICY_FIXED, null, null, null, 0, false));
	}

	/**
	 * @noinspection ALL
	 */
	public JComponent $$$getRootComponent$$$() {
		return view;
	}

}
