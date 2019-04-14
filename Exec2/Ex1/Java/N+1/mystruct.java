class mystruct {
	private int teams;
	private int[] parent;
	private int[] rank;
	
	public mystruct(int N) {
		this.teams = N;
		this.parent = new int[N+1];	//exei arxikopoihthei sto 0, dhl parent[i]=0 kai N+1 gia na exo prosbash sto N stoixeio xoris afaireseis
		this.rank = new int[N+1];	//omoia me apo pano
	}
	
	public int getteams() {
		return this.teams;
	}
	
	public int find(int i) {
		if (parent[i] == 0) return i;
		int result = this.find(parent[i]);
		parent[i] = result;
		return result;
	}
	
	public void union(int i, int j) {
		int irep = this.find(i);
		int jrep = this.find(j);
		if (irep == jrep) return;
		teams--;
		if (rank[irep] < rank[jrep]) parent[irep] = jrep;
		else if (rank[irep] > rank[jrep]) parent[jrep] = irep;
		else {
			parent[irep] = jrep;
			rank[jrep]++;
		}
	}
}
