#include <iostream>
#include <vector>
using namespace std;

class Goblin{
	int id, height, taller;
	Goblin(int id, int height, int taller):id(id), height(height), taller(taller);
	Goblin(Goblin & rhs){
		id = rhs.id;
		height = rhs.height;
		taller = rhs.taller;
	}
	//Need to override the == and < operator
}


int main(){
	vector<Goblin> line;
	int id, height, taller;
	while(cin>>id>>height>>taller){
		Goblin aGoblin(id, height, taller);
		line.push_back(aGoblin);
	}
	line.sort();
	//Sort in ascending order
	
	vector<Goblin>::iterator it;
	(Goblin*) array[line.size()];
	//put nil in empty array
	
	while(it!=line.end()){
		int order = (*it).taller;
		int i = 0;
		while(order > 0){
			if(array[i] == NULL)｛
				order -= 1;
			}
			i += 1;
		}
		array[i] = it;
		it++;
	}
	
	//Print out everything
	for(int i = 0;i< line.size(); i+=1){
		cout<<array[i]->id<<" ";
	}
	cout<<endl;
	
}