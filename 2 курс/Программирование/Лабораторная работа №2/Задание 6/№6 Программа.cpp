#include <iostream>
#include <cmath>
using namespace std;
float a, m, n, i, j, h = 0, result = 0, res1 = 0, res2 = 0;
double sum1 (double res1){
    for (i = 1; i <= m; i++){
            h = pow((2.0*i*i+i+2.0),2.0);
            res1 = res1 + h;
        }
    return res1;
}
double sum2 (double res2){
    for (j = 2; j <= n; j++){
            h = pow((i*i+3.0),2.0);
            res2 = res2 + h;
        }
    return res2;
}
int main()
{
    cout << "Введите значение A: "; cin >> a;
    cout << "Введите значение M: "; cin >> m;
    cout << "Введите значение N: "; cin >> n;
    res1 = sum1(res1);
    res2 = sum2(res2);
    result = (a + res1) / (4.0 + res2);
    cout << "Result = " << result;
    return 0;
}
