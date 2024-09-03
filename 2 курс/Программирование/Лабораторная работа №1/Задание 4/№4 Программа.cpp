#include <iostream>
#include <cmath>
using namespace std;
int main()
{
    float n,x = 3.5,i,result = 1;
    for (n = 4; n <= 75; n++){
        i = log(1.0+(x/(7.0+x))*sqrt(n));
        result = result * i;
    }
    result = x + (result * (x/(7.0+x)));
    cout<<"result = "<<result;
}



