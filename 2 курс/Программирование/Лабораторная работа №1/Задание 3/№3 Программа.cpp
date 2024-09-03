#include <iostream>
#include <cmath>
using namespace std;
int main()
{
    float n,a = 1,x,i = 0,x_stop = 0,step = 0,result = 0;
    cout<<"Введите значение X начальное: "; cin>>x;
    cout<<"Введите значение X конечное: "; cin>>x_stop;
    cout<<"Введите количество интервалов: "; cin>>n;
    step = (x_stop-x)/(n-1.0);
    while (i < n) {
        i++;
        result = (exp(-x)+exp(sqrt(a)))/exp(x-a);
        cout<< i <<") x = "<<x <<"; result = " <<result <<endl;
        x = x + step;
    }
}


