#include <iostream>
#include "functions.h"

int main() {
    int n;
    double arr_a[MAX_SIZE];
    double arr_b[MAX_SIZE];
    double arr_c[MAX_SIZE];
    double a_max = 0;
    double b_max = 0;
    double c_max = 0;
    system("chcp 1251");

    std::cout << "Введите размер массива (не более 20): ";
    std::cin >> n;

    s1:
    if (n <= 0 || n > MAX_SIZE) {
        std::cout << "Недопустимый размер массива." << std::endl;
        goto s1;
    }

    inputArray(arr_a, arr_b, arr_c, a_max, b_max, c_max, n);
    transformation(arr_a, arr_b, arr_c, a_max, b_max, c_max, n);
    printArray(arr_a, arr_b, arr_c, n);

    return 0;
}