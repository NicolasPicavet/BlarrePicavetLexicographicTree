package gui;

import com.intellij.uiDesigner.core.GridConstraints;
import com.intellij.uiDesigner.core.GridLayoutManager;
import com.intellij.uiDesigner.core.Spacer;
import tree.LexicographicTree;

import javax.swing.*;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.DefaultTreeModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.JFileChooser;

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
    private JScrollBar treeScrollbar;
    private JScrollBar listScrollBar;
    private JTextPane statusText;

    private JMenuBar menuBar = new JMenuBar();
    private JMenu fileMenu = new JMenu("File");
    private JMenuItem loadMenuItem = new JMenuItem("Load");
    private JMenuItem saveMenuItem = new JMenuItem("Save");
    private JMenu helpMenu = new JMenu("Help");

    private static DefaultListModel<String> listModel = new DefaultListModel<>();

    private LexicographicTree lexicographicTree = new LexicographicTree();

    public MainWindow(String title) {
        super(title);
        setContentPane(view);
        pack();
        init();
    }

    private void init() {
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
                String toAdd = inputText.getText();
                if (lexicographicTree.add(toAdd)) {
                    // TODO add to tree
                    listModel.add(0, toAdd);
                    statusText.setText("\"" + toAdd + "\" added");
                } else
                    statusText.setText("\"" + toAdd + "\" not added");
            }
        });
        deleteButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                String toRemove = inputText.getText();
                if (lexicographicTree.remove(toRemove)) {
                    // TODO remove from tree
                    listModel.removeElement(toRemove);
                    statusText.setText("\"" + toRemove + "\" removed");
                } else
                    statusText.setText("\"" + toRemove + "\" not removed");
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
        
        loadMenuItem.addActionListener(new OpenFileListener());
        saveMenuItem.addActionListener(new SaveFileListener());
    }
    

    /**
     * "Open" dialog (based on: https://stackoverflow.com/questions/3548140/how-to-open-and-save-using-java)
     */
    class OpenFileListener implements ActionListener {
        public void actionPerformed(ActionEvent e) {
          JFileChooser c = new JFileChooser();
          int rVal = c.showOpenDialog(MainWindow.this);
          if (rVal == JFileChooser.APPROVE_OPTION) {
            lexicographicTree.load(c.getCurrentDirectory().toString()+"/"+c.getSelectedFile().getName());
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
            lexicographicTree.save(c.getCurrentDirectory().toString()+"/"+c.getSelectedFile().getName());
          }
        }
      }

      public static DefaultListModel<String> getListModel()
      {
    	  return listModel;
      }
      

    {
// GUI initializer generated by IntelliJ IDEA GUI Designer
// >>> IMPORTANT!! <<<
// DO NOT EDIT OR ADD ANY CODE HERE!
        $$$setupUI$$$();
    }

    /**
     * Method generated by IntelliJ IDEA GUI Designer
     * >>> IMPORTANT!! <<<
     * DO NOT edit this method OR call it in your code!
     *
     * @noinspection ALL
     */
    private void $$$setupUI$$$() {
        view = new JPanel();
        view.setLayout(new GridLayoutManager(4, 1, new Insets(0, 0, 0, 0), -1, -1));
        tabPanel = new JTabbedPane();
        view.add(tabPanel, new GridConstraints(2, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, null, new Dimension(200, 200), null, 0, false));
        treeTab = new JPanel();
        treeTab.setLayout(new GridLayoutManager(1, 2, new Insets(0, 0, 0, 0), -1, -1));
        tabPanel.addTab("Tree", treeTab);
        tree = new JTree();
        treeTab.add(tree, new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH, GridConstraints.SIZEPOLICY_WANT_GROW, GridConstraints.SIZEPOLICY_WANT_GROW, null, new Dimension(150, 50), null, 0, false));
        treeScrollbar = new JScrollBar();
        treeTab.add(treeScrollbar, new GridConstraints(0, 1, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_VERTICAL, GridConstraints.SIZEPOLICY_FIXED, GridConstraints.SIZEPOLICY_WANT_GROW, null, null, null, 0, false));
        listTab = new JPanel();
        listTab.setLayout(new GridLayoutManager(1, 2, new Insets(0, 0, 0, 0), -1, -1));
        tabPanel.addTab("List", listTab);
        list = new JList();
        listTab.add(list, new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH, GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_WANT_GROW, null, new Dimension(150, 50), null, 0, false));
        listScrollBar = new JScrollBar();
        listTab.add(listScrollBar, new GridConstraints(0, 1, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_VERTICAL, GridConstraints.SIZEPOLICY_FIXED, GridConstraints.SIZEPOLICY_WANT_GROW, null, null, null, 0, false));
        actionBar = new JPanel();
        actionBar.setLayout(new GridLayoutManager(1, 5, new Insets(0, 10, 0, 10), -1, -1));
        view.add(actionBar, new GridConstraints(1, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_FIXED, null, null, null, 0, false));
        inputText = new JTextField();
        actionBar.add(inputText, new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_WEST, GridConstraints.FILL_HORIZONTAL, GridConstraints.SIZEPOLICY_WANT_GROW, GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(150, 26), null, 0, false));
        addButton = new JButton();
        addButton.setText("Add");
        actionBar.add(addButton, new GridConstraints(0, 1, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
        deleteButton = new JButton();
        deleteButton.setText("Delete");
        actionBar.add(deleteButton, new GridConstraints(0, 2, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
        searchButton = new JButton();
        searchButton.setText("Search");
        actionBar.add(searchButton, new GridConstraints(0, 3, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
        prefixButton = new JButton();
        prefixButton.setText("Prefix");
        actionBar.add(prefixButton, new GridConstraints(0, 4, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_FIXED, null, new Dimension(70, 26), null, 0, false));
        menuPane = new JPanel();
        menuPane.setLayout(new GridLayoutManager(1, 1, new Insets(0, 10, 0, 10), -1, -1));
        view.add(menuPane, new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH, GridConstraints.SIZEPOLICY_CAN_SHRINK | GridConstraints.SIZEPOLICY_CAN_GROW, GridConstraints.SIZEPOLICY_FIXED, null, null, null, 0, false));
        final Spacer spacer1 = new Spacer();
        menuPane.add(spacer1, new GridConstraints(0, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_HORIZONTAL, GridConstraints.SIZEPOLICY_WANT_GROW, 1, null, null, null, 0, false));
        statusText = new JTextPane();
        statusText.setMargin(new Insets(3, 10, 3, 10));
        view.add(statusText, new GridConstraints(3, 0, 1, 1, GridConstraints.ANCHOR_CENTER, GridConstraints.FILL_BOTH, GridConstraints.SIZEPOLICY_WANT_GROW, GridConstraints.SIZEPOLICY_FIXED, null, null, null, 0, false));
    }

    /**
     * @noinspection ALL
     */
    public JComponent $$$getRootComponent$$$() {
        return view;
    }
    
}
