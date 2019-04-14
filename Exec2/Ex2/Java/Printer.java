class Printer {
	private String[][] prev;//the array I check
	private int i,j;		//the position I currently check
	
	public Printer(int i, int j, String[][] prev){
		this.i = i;
		this.j = j;	//the position of E
		this.prev = prev;
	}
	
	public String getvalue() {
		return prev[i][j];
	}
	
	public void MoveToPrev() {
		if (prev[i][j].equals("U")) i++;
		else if (prev[i][j].equals("D")) i--;
		else if (prev[i][j].equals("L")) j++;
		else if (prev[i][j].equals("R")) j--;
		return;
	}
	
	public boolean IsLast() {
		return prev[i][j].equals("n");
	}
}
