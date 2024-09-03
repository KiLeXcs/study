#include <iostream>
#include <cmath>
using namespace std;
int main()
{
    float x,m,n,i,j,k,h = 0,s1 = 0,s2 = 0,result = 0;
    cout<<"Введите значение X: ";cin>> x;
    cout<<"Введите значение M: ";cin>>m;
    cout<<"Введите значение N: ";cin>> n;
    for (i = 1; i <= n; i++){
        for (j = 1; j <= m; j++){
            h = pow((i + j),2.0);
            s1 = s1 + h;
            h = j + 1.0;
            s2 = s2 + h;
        }
        h = (2.0*x + s1)/(x+i*s2);
        result = result + h;
    }
    cout<<"Result = "<<result;
}


