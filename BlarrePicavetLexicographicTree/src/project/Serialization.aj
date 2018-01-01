package project;

import tree.LexicographicTree;

import java.io.*;

import gui.MainWindow;

public aspect Serialization {
	
    declare parents : tree.LexicographicTree implements Serializable;

	/**
	 * Saving Tree to text file as a word list
	 * @param filePath : absolute text file path ( example : System.getProperty("user.dir")+"/"+"test.txt" )
	 */
	public boolean LexicographicTree.save(String filePath) {
		
		System.out.println("Saving tree to file : " + filePath);
		
		try {
			
			Writer writer = new BufferedWriter(new FileWriter(filePath));
			writer.write(toString()); //Tree toString method already returns a word list
			writer.flush();
			writer.close();

			return true;
		}
		catch(IOException e) {
			System.out.println(e);
		}
		return false;
    }

	/**
	 * Generating Tree from a word list of text file
	 * @param filePath : absolute text file path (example : System.getProperty("user.dir")+"/"+"filename.txt" )
	 */
    public boolean LexicographicTree.load(String filePath) {

		System.out.println("Loading tree from file : " + filePath);

		try {

			//@TODO: fix this bug, I cannot access the root node to re-init the Tree before loading
//			root = new EmptyNode(); //re-init tree
			MainWindow.getListModel().removeAllElements();//re-init JList for view

			Reader reader = new BufferedReader(new FileReader(filePath));
			int keepReading;
			StringBuffer sb = new StringBuffer();
			for(keepReading = reader.read(); keepReading != -1; keepReading = reader.read()) sb.append((char) keepReading);
			reader.close();

			String[] words = sb.toString().split("\n");

			for(String s:words) {
				add(s);
                MainWindow.getListModel().add(0, s);
//				System.out.println("Adding from Serialization.aj "load" pointcut : " + s);
			}

			return true;
		}
		catch(IOException e) {
			System.out.println(e);
		}
		return false;
    }


}
