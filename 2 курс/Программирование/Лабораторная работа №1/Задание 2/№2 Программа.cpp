#include <iostream>
#include <cmath>
using namespace std;
int main()
{
    float x,y;
    cout << "Write X value:";
    cin >> x;
        if (x >= 6){
            y = pow(sinf(x),2.0);
        } 
            else if (x >= 4) {
                y = log10(x);
            }
                else if (x >= -3) {
                    y = exp(0.1 * x);
                }
                    else {
                        y = (cos(x))/(x + 10.0);
                    }
    cout << y;
    return 0;
}
