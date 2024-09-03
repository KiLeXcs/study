#include <iostream>
#include <string>
#include <sstream>

std::string num;
std::string lines[20];
int n;

void textInput(std::string& text) {
s1:
    std::cout << "Введите количество строк (<20): ";
    std::getline(std::cin, num);
    n = std::stoi(num);
    if (n > 20) {
        std::cout << "Введенное вами значение превышает 20!" << std::endl;
        goto s1;
    }

    std::cout << "Введите текст:" << std::endl;
    for (int i = 0; i < n; i++) {
        std::getline(std::cin, lines[i]);
    }
}

void removeEvenWords(std::string& line) {
    std::istringstream iss(line);
    std::ostringstream oss;
    std::string word;
    int wordCount = 0;

    while (iss >> word) {
        wordCount++;

        // Проверяем, является ли номер слова четным
        if (wordCount % 2 != 0) {
            oss << word << ' ';
        }
    }

    line = oss.str();
}

int main() {
    system("chcp 1251");

    textInput(lines[0]);

    for (int i = 0; i < n; i++) {
        removeEvenWords(lines[i]);
    }

    std::cout << "Результат обработки:" << std::endl;
    for (int i = 0; i < n; i++) {
        std::cout << lines[i] << std::endl;
    }

    return 0;
}



