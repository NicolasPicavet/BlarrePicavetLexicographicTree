package gui;

import tree.LexicographicTree;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

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

    private DefaultListModel<String> listModel = new DefaultListModel<>();

    private LexicographicTree lexicographicTree = new LexicographicTree();

    public MainWindow(String title) {
        super(title);
        setContentPane(view);
        pack();
        init();
    }

    private void init() {
        // Models
        // TODO Tree model
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
    }

    public JPanel getView() {
        return view;
    }
}
