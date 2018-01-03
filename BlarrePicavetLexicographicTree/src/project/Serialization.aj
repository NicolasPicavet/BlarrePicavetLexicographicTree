package project;

import tree.LexicographicTree;

import java.io.*;

public aspect Serialization {

	declare parents : tree.LexicographicTree implements Serializable;

	/**
	 * Saving Tree to text file as a word list
	 * 
	 * @param filePath
	 *            : absolute text file path ( example :
	 *            System.getProperty("user.dir")+"/"+"filename.txt" )
	 */
	public boolean LexicographicTree.save(String filePath) {

		System.out.println("Saving tree to file : " + filePath);

		try {

			Writer writer = new BufferedWriter(new FileWriter(filePath));
			writer.write(toString()); // Tree toString method already returns a word list
			writer.flush();
			writer.close();

			return true;
		} catch (IOException e) {
			System.out.println(e);
		}
		return false;
	}

	/**
	 * Generating Tree from a word list of text file
	 * 
	 * @param filePath
	 *            : absolute text file path (example :
	 *            System.getProperty("user.dir")+"/"+"filename.txt" )
	 */
	public boolean LexicographicTree.load(String filePath) {

		System.out.println("Loading tree from file : " + filePath);

		try {

			// read file and make a string with all the characters
			Reader reader = new BufferedReader(new FileReader(filePath));
			int keepReading;
			StringBuffer sb = new StringBuffer();
			for (keepReading = reader.read(); keepReading != -1; keepReading = reader.read())
				sb.append((char) keepReading);
			reader.close();

			// split into words
			String[] words = sb.toString().split("\n");

			// go through words
			for (String s : words)
				add(s); // add to tree

			return true;
		} catch (IOException e) {
			System.out.println(e);
		}
		return false;
	}

}
