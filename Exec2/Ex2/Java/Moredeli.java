import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner

public class Moredeli {
	public static void main (String[] args) {
		File file = new File(args[0]);
		int N=0,M=0,Si=0,Sj=0,Ei=0,Ej=0,i=0,j=0;
		String[][] tab = new String[1000][1000];
		char cont;
		try (FileInputStream fis = new FileInputStream(file)) {
			int content;
			while ((content = fis.read()) != -1) {
				cont = ((char) content);
				//System.out.print(cont);
				if(cont == '\n'){
					i++;
					j=0;
				}
				else{
					tab[i][j] = "" + cont;
					if(cont == 'S'){
						Si = i;
						Sj = j;
					}
					if(cont == 'E'){
						Ei = i;
						Ej = j;
					}
					if (j>M) M = j;
					j++;
				}
			}
			N = i;
			M++;
		
			myQueue q = new myQueue(Si, Sj, tab, N, M);
			while(!q.checkiffound()) {
				q.fixnodes();
				q.MoveToNextElement();
			}
			q.lastnode();
			Printer pr = new Printer(Ei, Ej, q.getprev());	//mallon lathos
			String s = "";	//the path I will follow
			while (!(pr.IsLast())) {
				s = pr.getvalue() + s;
				pr.MoveToPrev();
			}
			System.out.println(q.getcost() + " " + s);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
}
