#include <iostream>
using namespace std;

// Объявление класса
class Program
{
public:
    Program();
    Program(std::string n, std::string d, std::string v, int y);
    ~Program();
    std::string getName();
    void setName(std::string val);
    std::string getDeveloper();
    void setDeveloper(std::string val);
    std::string getVersion();
    void setVersion(std::string val);
    int getYear();
    void setYear(int val);

private:
    std::string name;
    std::string developer;
    std::string version;
    int year;
};

// Программа, использующая класс
int main()
{
    system("chcp 1251");
    Program Prog[4];
    std::string name;
    std::string developer;
    std::string version;
    int year;
    int max_year = 0;
    int max_array = 0;
    for (int i = 0; i < 4; i++)
    {
        cout << "Введите название " << i + 1 << " программы: ";
        cin >> name;
        Prog[i].setName(name);
        cout << "Введите разработчика " << i + 1 << " программы: ";
        cin >> developer;
        Prog[i].setDeveloper(developer);
        cout << "Введите версию " << i + 1 << " программы: ";
        cin >> version;
        Prog[i].setVersion(version);
        cout << "Введите год выпуска " << i + 1 << " программы: ";
        cin >> year;
        Prog[i].setYear(year);
        if (max_year < year) {
            max_year = year;
            max_array = i;
        }
    }
    for (int i = 0; i < 4; i++)
        cout << Prog[i].getName() << " " << Prog[i].getDeveloper() << " " << Prog[i].getVersion() << " " << Prog[i].getYear() << endl;
    cout << "Самая новая программа: " << endl;
    cout << Prog[max_array].getName() << " " << Prog[max_array].getDeveloper() << " " << Prog[max_array].getVersion() << " " << Prog[max_array].getYear() << endl;
    return 0;
}

// Реализация функций-членов класса
Program::Program()
{
    // Конструктор по умолчанию
    name = "Noname";
    developer = "NoDeveloper";
    version = "NoVersion";
    year = 0;
}

Program::Program(std::string n, std::string d, std::string v, int y)
{
    // Конструктор с параметрами
    name = n;
    developer = d;
    version = v;
    year = y;
}

Program::~Program()
{
    // Деструктор по умолчанию, можно не включать в класс,
    // явно в программе не вызывается
}

std::string Program::getName()
{
    return name; // Возвращает значение свойства name
}

void Program::setName(std::string val)
{
    name = val; // Перезаписывает значение свойства name
}

std::string Program::getDeveloper()
{
    return developer; // Возвращает значение свойства developer
}

void Program::setDeveloper(std::string val)
{
    developer = val; // Перезаписывает значение свойства developer
}

std::string Program::getVersion()
{
    return version; // Возвращает значение свойства version
}

void Program::setVersion(std::string val)
{
    version = val; // Перезаписывает значение свойства version
}

int Program::getYear()
{
    return year; // Возвращает значение свойства year
}

void Program::setYear(int val)
{
    year = val; // Перезаписывает значение свойства year
}
