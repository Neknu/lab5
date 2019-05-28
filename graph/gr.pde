import java.io.*; 
import java.util.*; 

class Graph 
{ 
    private int count;    
    private LinkedList<Integer> adj[]; 
    vert[] verts = new vert[MAX];

    Graph(int v) 
    { 
        count = v; 
        adj = new LinkedList[v]; 
        for (int i=0; i<v; ++i) 
            adj[i] = new LinkedList(); 
    } 
  
    void addEdge(int v,int w) { adj[v].add(w); } 

    void topologicalSortUtil(int v, boolean visited[], 
                             Stack stack) 
    { 

        visited[v] = true; 
        Integer i; 
  
        Iterator<Integer> it = adj[v].iterator(); 
        while (it.hasNext()) 
        { 
            i = it.next(); 
            if (!visited[i]) 
                topologicalSortUtil(i, visited, stack); 
        } 
  
        stack.push(new Integer(v)); 
    } 
  

    void topologicalSort() 
    { 
        Stack stack = new Stack(); 
  
        boolean visited[] = new boolean[count]; 
        for (int i = 0; i < count; i++) 
            visited[i] = false; 
  
        for (int i = 0; i < count; i++) 
            if (visited[i] == false) 
                topologicalSortUtil(i, visited, stack); 

        while (stack.empty()==false) {
            System.out.print(stack.pop() + " "); 
        }
    } 
}
