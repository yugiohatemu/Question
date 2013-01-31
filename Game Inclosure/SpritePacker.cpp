#include <iostream>
#include <stdlib.h>
#include <vector>
using namespace std;

const int s_height = 1024; 
const int s_width = 1024;

typedef struct sprite{
    int m,n,size;
    sprite(){
        m = 0;
        n= 0;
        size = 0;
    }
    sprite(int s_m,int s_n,int s_size){
        m = s_m;
        n = s_n;
        size = s_size;
    }
    sprite& operator= (sprite &x){
        m = x.m;
        n = x.n;
        size = x.size;
        return *this;
    }
    void print(){
        cout<<m<<"x"<<n<<"->"<<size<<endl;
    }
};

typedef struct pos{
    int x,y;
    pos(){
        x= 0;
        y = 0;
    }
    pos(int p,int q){
        x = p;
        y = q;
    }
    bool is_valid(){ //let p , q < 0 be invalid
        if (x < 0 && y <0){
            return false;
        }else
            return true;
    }
    pos &operator= (pos &a){
        x = a.x;
        y = a.y;
        return *this;
    }
    bool out_of_bound(){
        if(x>s_height ||y>s_width){
            return true;
        }else
            return false;
    }
    void print(){
        cout<<x<<"x"<<y<<endl;
    }
};

typedef struct image{
    sprite s;
    pos p;
    image(sprite i_s,pos i_p){
        s = i_s;
        p = i_p;
    }
    void print(){
        cout<<s.m<<"x"<<s.n<<" "<<p.x<<" "<<p.y<<endl;
    }
};

void sort_size(vector<sprite>& v){
    //use the lazy sort
    int swap = 0;
    vector<sprite>::iterator it;
    while (true) {
        for (it = v.begin();it<v.end()-1;it++) {
           if ((*it).size<(*(it+1)).size) {
                sprite t1 = (*it);
                sprite t2 = *(it+1);
                (*it) = t2;
                *(it+1) = t1;
                swap += 1;
           }
        }
       if (swap == 0) {
            break;
        } else{
            swap = 0;
        }
    }
}


bool is_collide(vector<image>& v, sprite s,pos p){
    pos topleft = p;
    pos topright(p.x+s.m,p.y);
    pos bottomleft(p.x,p.y+s.n);
    pos bottomright(p.x+s.m,p.y+s.n);
    
    if (topright.out_of_bound()||bottomleft.out_of_bound()||bottomright.out_of_bound()) {
        return true;
    }else{
        //check if this 3 is in other ppls boundary
        vector<image>::iterator it;
        for (it = v.begin(); it<v.end(); it ++) {
            sprite old_s = (*it).s;
            pos old_p = (*it).p;
            pos tl = (*it).p;
            pos tr(old_p.x+old_s.m,old_p.y);
            pos bl(old_p.x,old_p.y+old_s.n);
            pos br(old_p.x+old_s.m,old_p.y+old_s.n);
            
            if (bottomright.x<= tl.x || bottomleft.x>= br.x || topright.y>=br.y||bottomright.y<=tr.y ) {
                
            }else {
                return true;
            }
            
        }
    }
    return false;
    
}

/*
 if (is_in_other(topright, old_s,old_p)) {
 return true;
 }else if (is_in_other(bottomleft, old_s,old_p)) {
 return true;
 }else if (is_in_other(bottomright, old_s,old_p)) {
 return true;
 }else{
 pos tl = old_p;
 pos tr(old_p.x+old_s.m,old_p.y);
 pos bl(old_p.x,old_p.y+old_s.n);
 pos br(old_p.x+old_s.m,old_p.y+s.n);               
 //clip check
 if (is_in_other(tl, s,p)) {
 return true;
 }else if (is_in_other(bl, s,p)) {
 return true;
 }else if (is_in_other(tr, s,p)) {
 return true;
 }else if (is_in_other(br, s,p)){
 return true;
 }else if ((topleft.x - tl.x)*(topright.x - tr.x)<0) {
 return true;
 }else if ((bottomleft.x - bl.x)*(bottomright.x - br.x)<0) {
 return true;
 }else if ((topleft.y - tl.y)*(bottomleft.y - bl.y)<0) {
 // cout<<"s";
 return true;
 }else if ((topright.y - tr.y)*(bottomright.y - br.y)<0) {
 return true;
 }
 */

pos get_next_pos(vector<image>& v, sprite s_new){
    if (v.size()==0) {//empty sheet
        pos p(0,0);
        return p;
    }else{
        vector<image>::iterator it;
        for (it = v.begin(); it<v.end(); it ++) {
            //from up to down , left to right
            pos topleft = (*it).p;
            sprite s = (*it).s;
            pos topright(topleft.x+s.m,topleft.y);
            pos bottomleft(topleft.x,topleft.y+s.n); 
            pos bottomright(topleft.x+s.m,topleft.y+s.n);
            if (!is_collide(v,s_new,bottomleft)) {
                return bottomleft;
            }else if(!is_collide(v,s_new,bottomright)){
                return bottomright;
            }else if(!is_collide(v,s_new,topright)){
                return topright;
            }
        }
    }
    pos no_pos(-1,-1);
    return no_pos;
}

void place_sprite(vector<sprite>& s,vector<image>& v){
    vector<sprite> dump;
    while (s.size()>0) {
        pos p= get_next_pos(v,s.front());
        if (p.is_valid()) {
            sprite x = s.front();
            image i(x,p);
            v.push_back(i);  
            s.erase(s.begin());
        }else{
            sprite x = s.front();
            dump.push_back(x);           
            s.erase(s.begin());
        }
    }
    static int count = 0;
    cout<<"sheet"<<count<<endl;
    vector<image>::iterator it;
    for (it = v.begin(); it<v.end(); it ++) {
        (*it).print();
    }
    cout<<endl;
    count +=1;
    v.clear();
    if (dump.size()>0) {
        place_sprite(dump,v);  
    }
}

int main(){
    vector<sprite> list;
    int m ,n;
    char x;
    while (cin >> m>> x>>n) {
        sprite s(m,n,m*n);
        list.push_back(s);
    }
    
    sort_size(list);
    vector<image> sheet;
    int count = 1;
    place_sprite(list,sheet);
    return 0;
}