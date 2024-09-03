#include <iostream>
#include <string>
#include <fstream>
#include <sstream>


    using namespace std;

string str[3];

struct Program {

    string name;
    string programmer;
    string version;
    int year;

};

int main() {
    setlocale(LC_ALL, "ru");

    Program Prog[3];
    string word;
    string words[15];
    int max_year = 0;
    int max_array = 0;
    int n = 0;

    ifstream file;
    file.open("C:\\input.txt");                 // Открываем текстовый файл.
    if (!file.is_open()) {                      // Проверяем, удалось ли открыть файл.
        cout << "Файл не открыт!";
        exit;
    }
    for (int i = 0; i < 4; i++) {                   // Читаем данные из файла.
        getline(file, str[i]);
    }
    for (int i = 0; i < 4; i++) {
        std::istringstream ss(str[i]);
        std::string word;
        while (ss >> word) {
            words[n] = word;
            n++;
        }
    }
    for (int i = 0; i < 3; i++) {
        Prog[i].name = words[i * 4];
        Prog[i].programmer = words[i * 4 + 1];
        Prog[i].version = words[i * 4 + 2];
        Prog[i].year = stoi(words[i * 4 + 3]);
    }
    for (int i = 0; i < 3; i++) {
        if (Prog[i].year > max_year) {
            max_year = Prog[i].year;
            max_array = i;
        }
    }

    cout << "Самая новая программа : " << Prog[max_array].name << " " << Prog[max_array].programmer << " " << Prog[max_array].version << " " << Prog[max_array].year << " " << endl;

    return 0;
}