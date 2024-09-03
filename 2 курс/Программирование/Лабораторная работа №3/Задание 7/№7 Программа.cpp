#include <iostream>

const int MAX_SIZE = 20;
// Функция для ввода массива
void inputArray(double arr_a[], double arr_b[], double arr_c[], double& a_max, double& b_max, double& c_max, int n) {
    std::cout << "Введите " << n << " элементов последовательности x:\n ";
    for (int i = 0; i < n; i++) {
        std::cout << "Элемент " << i + 1 << ": ";
        std::cin >> arr_a[i];
        if (arr_a[i] > a_max) {
            a_max = arr_a[i];
        }
    }
    std::cout << "Введите " << n << " элементов последовательности y:\n ";
    for (int i = 0; i < n; i++) {
        std::cout << "Элемент " << i + 1 << ": ";
        std::cin >> arr_b[i];
        if (arr_b[i] > b_max) {
            b_max = arr_b[i];
        }
    }
    std::cout << "Введите " << n << " элементов последовательности c:\n ";
    for (int i = 0; i < n; i++) {
        std::cout << "Элемент " << i + 1 << ": ";
        std::cin >> arr_c[i];
        if (arr_c[i] > c_max) {
            c_max = arr_c[i];
        }
    }
}

// Функция для преобразования массива
void transformation(double arr_a[], double arr_b[], double arr_c[], double a_max, double b_max, double c_max, int n) {
    for (int i = 0; i < n; i++) {
        arr_a[i] = ((a_max + b_max) - (arr_a[i] + arr_b[i]) / 2.0);
        arr_b[i] = ((b_max + c_max) - (arr_b[i] + arr_c[i]) / 2.0);
    }
}

// Функция для вывода массива
void printArray(double arr_a[], double arr_b[], double arr_c[], int n) {
    std::cout << "Последовательности после преобразований:\n";
    std::cout << "x: ";
    for (int i = 0; i < n; i++) {
        std::cout << arr_a[i] << " ";
    }

    std::cout << "\ny: ";
    for (int i = 0; i < n; i++) {
        std::cout << arr_b[i] << " ";
    }

    std::cout << "\nc: ";
    for (int i = 0; i < n; i++) {
        std::cout << arr_c[i] << " ";
    }
    std::cout << std::endl;
}

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