package project;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.io.Serializable;
import java.io.Writer;

import tree.LexicographicTree;

public aspect Serialization {
	
    declare parents : tree.LexicographicTree implements Serializable;

	/**
	 * Saving Tree to text file as a word list
	 * @param filePath : absolute text file path ( example : System.getProperty("user.dir")+"/"+"test.txt" )
	 */
	public void LexicographicTree.save(String filePath) {
		
		System.out.println("Saving tree to file : " + filePath);
		
		try {
			
			Writer writer = new BufferedWriter(new FileWriter(filePath));
			writer.write(toString()); //Tree toString method already returns a word list
			writer.flush();
			writer.close();
			
		}
		catch(IOException e) {
			System.out.println(e);
		}
    }

	/**
	 * Generating Tree from a word list of text file
	 * @param filePath : absolute text file path (example : System.getProperty("user.dir")+"/"+"filename.txt" )
	 */
    public void LexicographicTree.load(String filePath) {
    	
		System.out.println("Loading tree from file : " + filePath);
	
		try {

			Reader reader = new BufferedReader(new FileReader(filePath));
			int keepReading;
			StringBuffer sb = new StringBuffer();
			for(keepReading = reader.read(); keepReading != -1; keepReading = reader.read()) sb.append((char) keepReading);
			reader.close();
			
			String[] words = sb.toString().split("\n");
			
			for(String s:words) add(s);
			
		}
		catch(IOException e) {
			System.out.println(e);
		}
		
    }


}
