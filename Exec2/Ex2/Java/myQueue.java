import java.util.Stack;

class myQueue {
	private Stack<node> current, plus1, plus2, plus3;
	private int cost;
	private String[][] tab;
	private int N,M;	//dimensions
	private String[][] prev;
	
	public myQueue(int Si, int Sj, String[][] tab, int N, int M) {
		cost = 0;
		this.N = N;		//rows
		this.M = M;		//columns
		prev = new String[N][M];	//default value of prev[i][j] == null
		this.tab = tab;
		current = new Stack<node>();
		plus1 = new Stack<node>();
		plus2 = new Stack<node>();
		plus3 = new Stack<node>();
		current.push(new node(Si, Sj, "n"));		//S position
	}
	
	public String[][] getprev() {
		return prev;
	}
	
	public int getcost() {
		return cost;
	}
	
	public boolean checkiffound() {
		return tab[current.peek().geti()][current.peek().getj()].equals("E");
	}
	
	public void MoveToNextElement() {
		current.pop();
		if (current.empty()) {
			current = plus1;	//isos lathos kai na prepei na metafero kathe stoixeio 3exorista, mallon sosto
			plus1 = plus2;
			plus2 = plus3;
			//plus3 = null;
			plus3 = new Stack<node>();
			cost++;
			if (current.empty()) {
				current = plus1;
				plus1 = plus2;
				plus2 = new Stack<node>();
				cost++;
				if (current.empty()) {
					current = plus1;
					plus1 = new Stack<node>();
					cost++;						//de xreiazetai na do k allh periptvsh gti tha vro sigoura apotelesma
				}
			}
		}
		return;	
	}
	
	//ftiaxnei prev kai epomenes kinhseis
	public void fixnodes() {
		if (prev[current.peek().geti()][current.peek().getj()] == null) {
			prev[current.peek().geti()][current.peek().getj()] = current.peek().getstring();	//gia ton prev
			if ((current.peek().geti() - 1 >= 0) && (!tab[current.peek().geti()-1][current.peek().getj()].equals("X"))) plus3.push(new node(current.peek().geti()-1, current.peek().getj(), "U"));
			if ((current.peek().geti() + 1 < N)  && (!tab[current.peek().geti()+1][current.peek().getj()].equals("X"))) plus1.push(new node(current.peek().geti()+1, current.peek().getj(), "D"));
			if ((current.peek().getj() - 1 >= 0) && (!tab[current.peek().geti()][current.peek().getj()-1].equals("X"))) plus2.push(new node(current.peek().geti(), current.peek().getj()-1, "L"));
			if ((current.peek().getj() + 1 < M)  && (!tab[current.peek().geti()][current.peek().getj()+1].equals("X"))) plus1.push(new node(current.peek().geti(), current.peek().getj()+1, "R"));
		}
		return;
	}
	
	//ftiaxnei prev gia ton teleutaio kombo
	public void lastnode() {
		prev[current.peek().geti()][current.peek().getj()] = current.peek().getstring();
		return;
	}
}
