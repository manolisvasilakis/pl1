/***************************************************************************
  Course    : Programming Languages 1 - Assignment 2 - Exercise 1
  Author(s) : Vasilakis Emmanouil (manolisvas.gr@gmail.com), Konstantinos Alexakis (kons4al88@gmail.com)
  Date      : June 19, 2017
  Note      : Adjusted from http://www.geeksforgeeks.org/disjoint-set-data-structures-java-implementation/
  -----------
  School of ECE, National Technical University of Athens.
****************************************************************************/

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner;

public class Villages {
	public static void main (String[] args) {
		try (Scanner scanner = new Scanner(new File(args[0]))){
			int N = scanner.nextInt();
			int M = scanner.nextInt();
			int K = scanner.nextInt();
			mystruct s = new mystruct(N);
			for (int i=0; i<M; i++){
				s.union(scanner.nextInt(),scanner.nextInt());
			}
			int result = s.getteams() - K;
			if (result < 2) result = 1;
			System.out.println(result + "");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
