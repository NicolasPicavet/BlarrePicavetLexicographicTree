package gui;

import tree.LexicographicTree;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class MainWindow {

    private static MainWindow instance = new MainWindow();

    private JTree tree;
    private JTabbedPane tabPanel;
    private JList list;
    private JTextField inputText;
    private JButton addButton;
    private JButton deleteButton;
    private JButton searchButton;
    private JButton prefixButton;
    private JPanel menuBar;
    private JPanel actionBar;
    private JPanel treeTab;
    private JPanel listTab;
    private JButton fileMenuButton;
    private JButton helpMenuButton;
    private JPanel view;
    private JScrollBar treeScrollbar;
    private JScrollBar listScrollBar;

    private DefaultListModel<String> listModel = new DefaultListModel<>();

    private LexicographicTree lexicographicTree = new LexicographicTree();

    private MainWindow() {
        list.setModel(listModel);

        addButton.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                String toAdd = inputText.getText();
                if (lexicographicTree.add(toAdd)) {
                    listModel.add(0, toAdd);
                }
            }
        });
    }

    public static MainWindow getInstance() {
        return instance;
    }

    public JPanel getView() {
        return view;
    }

    private void addItemToList(Component component) {
        list.add(component);
    }
}
