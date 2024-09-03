#include <iostream>
using namespace std;
const int MAX_N = 10;
const int MAX_M = 10;
void inputArray(int arr[][MAX_M], int n, int m) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            cout << "Введите " << j + 1 << " значение " << i + 1 << " столбца " ; cin >> arr[i][j];
        }
    }
}
void calculateRowSum(const int arr[][MAX_M], int rowSum[], int n, int m) {
    for (int i = 0; i < n; i++) {
        rowSum[i] = 0;
        for (int j = 0; j < m; j++) {
            rowSum[i] += arr[i][j];
        }
    }
}
void printRowSum(const int rowSum[], int n) {
    cout << "Сумма чисел в каждой строке:\n";
    for (int i = 0; i < n; i++) {
        cout << "Строка " << i + 1 << ": " << rowSum[i] << endl;
    }
}
int main() {
    int arr[MAX_N][MAX_M];
    int n, m;
    s1:
    cout << "Введите количество строк: "; cin >> n;
    cout << "Введите количество столбцов: "; cin >> m;
    if (n <= 0 || n > MAX_N || m <= 0 || m > MAX_M) {
        cout << "Недопустимые значения количества строк или столбцов\n" << endl;
        goto s1;
    }
    inputArray(arr, n, m);
    int rowSum[MAX_N];
    calculateRowSum(arr, rowSum, n, m);
    printRowSum(rowSum, n);
    return 0;
}
