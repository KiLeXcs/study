#pragma once
#include <iostream>
const int MAX_SIZE = 20;
// ������� ��� ����� �������
void inputArray(double arr_a[], double arr_b[], double arr_c[], double& a_max, double& b_max, double& c_max, int n) {
    std::cout << "������� " << n << " ��������� ������������������ x:\n ";
    for (int i = 0; i < n; i++) {
        std::cout << "������� " << i + 1 << ": ";
        std::cin >> arr_a[i];
        if (arr_a[i] > a_max) {
            a_max = arr_a[i];
        }
    }
    std::cout << "������� " << n << " ��������� ������������������ y:\n ";
    for (int i = 0; i < n; i++) {
        std::cout << "������� " << i + 1 << ": ";
        std::cin >> arr_b[i];
        if (arr_b[i] > b_max) {
            b_max = arr_b[i];
        }
    }
    std::cout << "������� " << n << " ��������� ������������������ c:\n ";
    for (int i = 0; i < n; i++) {
        std::cout << "������� " << i + 1 << ": ";
        std::cin >> arr_c[i];
        if (arr_c[i] > c_max) {
            c_max = arr_c[i];
        }
    }
}

// ������� ��� �������������� �������
void transformation(double arr_a[], double arr_b[], double arr_c[], double a_max, double b_max, double c_max, int n) {
    for (int i = 0; i < n; i++) {
        arr_a[i] = ((a_max + b_max) - (arr_a[i] + arr_b[i]) / 2.0);
        arr_b[i] = ((b_max + c_max) - (arr_b[i] + arr_c[i]) / 2.0);
    }
}

// ������� ��� ������ �������
void printArray(double arr_a[], double arr_b[], double arr_c[], int n) {
    std::cout << "������������������ ����� ��������������:\n";
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