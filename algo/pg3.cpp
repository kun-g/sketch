#include<iostream>
#include<fstream>
#include<sstream>
#include<string>
#include<vector>
#include<time.h>
#include<stdlib.h>
#define vert_num 40
using namespace std;
struct vet{int a;vet *b; int id;int vetice;};
vet temp[300];
vector<vet> vertice;
int countvertex=vert_num;//0;
void contract(int a,int b){
  vet* enda; //vet* endb;
  enda=&vertice[a-1];//endb=&vertice[b-1];
  while(enda)  
  {
    if((*enda).a==b)
      (*enda).a=a;
    if((*enda).b)
      enda=(*enda).b;
    else break;
  }
  (*enda).b=vertice[b-1].b;
  enda=(*enda).b;

  do {//link b to a
    vet* tob=&vertice[(*enda).a-1];
    if((*enda).a!=a)
      while(tob)
      {
        if((*tob).a==b) //{edges towards b turned to a
        {
          (*tob).a=a;
        }
        if((*tob).b)
          tob=(*tob).b;
        else break;
      }
      enda=(*enda).b;
      // cout<<"b move forward"<<(*enda).a<<endl;
      }while(enda);
    countvertex--;
    cout<<"删除节点"<<b<<endl;
    // system("pause");
    enda=&vertice[a-1];//delete loop


    while((*enda).b)
    {
      vet* tempre=enda;
      (*tempre).vetice=a;
      enda=(*enda).b;
      while((*enda).a==a)
      {
        (*tempre).b=(*enda).b;
        if((*enda).b)
        {enda=(*enda).b;
          (*enda).vetice=a;}
        else
          break;
      }
    }


    vet *ttt=&vertice[b-1];//?????????为什么必须这样才能改id？？
    (*ttt).id=999;
  }

  int main(){
    srand((unsigned) time(NULL)); 
    ifstream in("kargerAdj.txt");
    int i=0;
    string str;
    int j=0;
    int mm=j;
    int count=0;
    int var=1;
    while(getline(in,str)){
      istringstream strtemp(str);
      while(strtemp>>temp[j].a)
      { if(j>=1&&temp[j-1].vetice==var)
        temp[j-1].b=&temp[j];
        temp[j].id=count++;
        temp[j].vetice=var;
        j++;}
        temp[j-1].b=NULL;
        int ii=mm;
        vertice.push_back(temp[mm]);
        mm=j;
        var++;
    }
    int chose=rand()%countvertex;
    // int aa[]={5,0,6,3};
    while( countvertex>2){
      cout<<"vertex left"<<countvertex<<endl;
      vet *temp3=&vertice[temp[chose].vetice-1];
      vet *temp_b=&vertice[temp[chose].a-1];
      while( (*temp3).id==999||(*temp_b).id==999||temp[chose].a==temp[chose].vetice){//contraction
        chose=rand()%countvertex;
        temp3=&vertice[temp[chose].vetice-1];
        temp_b=&vertice[temp[chose].a-1];

      };
      cout<<"a:"<<temp[chose].a<<"vetice"<<temp[chose].vetice<<endl;
      //cout<<"chose"<<aa[chose]<<endl;
      contract(temp[chose].a, temp[chose].vetice);
      for(i=0;i<vert_num;i++){
        vet *temp=&vertice[i];
        while(1)
        {
          if((*temp).id!=999)
          {
            //cout<<"顶点"<<(*temp).a<<"边代号id"<<(*temp).id<<"该边所属顶点"<<(*temp).vetice<<endl;
            if((*temp).b)
            {// cout<<"顶点"<<(*temp).a<<"边代号id"<<(*temp).id<<"该边所属顶点"<<(*temp).vetice<<endl;
              temp=(*temp).b;}
            else{
              // cout<<"顶点"<<(*temp).a<<"边代号id"<<(*temp).id<<"该边所属顶点"<<(*temp).vetice<<endl;
              break;}
          }
          else 
            break;
        }
      }
    }
    cout<<"contraction over"<<endl;
    int temp1=0;
    while(vertice[temp1].id==999){
      temp1++;}
    int mincut=0;
    vet* temp11=&vertice[temp1];
    while((*temp11).b!=NULL){
      cout<<(*temp11).a<<endl;
      mincut++;
      temp11=(*temp11).b;
    }
    cout<<(*temp11).a<<endl;
    cout<<"mincut:"<<mincut<<endl;

    return 0;
  }
