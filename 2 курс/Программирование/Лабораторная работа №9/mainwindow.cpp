#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include "math.h"
double num_first;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(ui->pushButton_2,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_3,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_4,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_5,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_6,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_7,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_8,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_9,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_10,SIGNAL(clicked()), this,SLOT(digits_numbers()));
    connect(ui->pushButton_12,SIGNAL(clicked()), this,SLOT(digits_numbers()));

    connect(ui->Convert,SIGNAL(clicked()), this,SLOT(operation()));
    connect(ui->OnePercent,SIGNAL(clicked()), this,SLOT(operation()));
    connect(ui->fib,SIGNAL(clicked()), this,SLOT(operation()));
    connect(ui->Factorial,SIGNAL(clicked()), this,SLOT(operation()));
    connect(ui->divisionByX,SIGNAL(clicked()), this,SLOT(operation()));

    connect(ui->pow,SIGNAL(clicked()), this,SLOT(math_operation()));
    connect(ui->pushButton_14,SIGNAL(clicked()), this,SLOT(math_operation()));
    connect(ui->pushButton_15,SIGNAL(clicked()), this,SLOT(math_operation()));
    connect(ui->pushButton_16,SIGNAL(clicked()), this,SLOT(math_operation()));
    connect(ui->pushButton_17,SIGNAL(clicked()), this,SLOT(math_operation()));

    ui->pushButton_14->setCheckable(true);
    ui->pushButton_15->setCheckable(true);
    ui->pushButton_16->setCheckable(true);
    ui->pushButton_17->setCheckable(true);
    ui->pow->setCheckable(true);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::digits_numbers(){
    //Получаем свойства нажатой кнопки
    QPushButton *button = (QPushButton *)sender();
    // Строка для конвертирования значения в текст
    QString new_label;

    if(button->text() == "."){  // Проверяем если была нажата кнопка с десятичной точкой
        if(!(ui->label->text().contains('.')))  // Проверяем, содержит ли label уже точку
            new_label = ui->label->text() + ".";
    } else {
        new_label = ui->label->text() + button->text();
    }

    ui->label->setText(new_label);
}

void MainWindow::on_pushButton_13_clicked()
{
    if(!(ui->label->text().contains('.')))
        ui->label->setText(ui->label->text() + ".");
}


void MainWindow::on_pushButton_18_clicked()
{
    ui->pushButton_14->setCheckable(true);
    ui->pushButton_15->setCheckable(true);
    ui->pushButton_16->setCheckable(true);
    ui->pushButton_17->setCheckable(true);
    ui->pow->setCheckable(true);
    ui->label->setText("");
}

//Вычисления факториала рекурсией
double Factorial(double n)
{
    if (n == 1 || n == 0) return 1;

    return n * Factorial(n - 1);
}
//Вычисления ряда фиббоначи
double fib(double n)
{
    return n == 0 || n == 1 ? n : fib(n - 1) + fib(n - 2);
}

void MainWindow::operation(){
    //Получаем свойства нажатой кнопки
    QPushButton *button = (QPushButton *)sender();
    QString new_label;
    double numbers;

    if(button->text() == "+/-"){
        //Конвертируем текст label в число
        numbers = (ui->label->text().toDouble());
        numbers = numbers * -1;
        //Конвертируем число в строку(15знаков после запятой)
        new_label = QString::number(numbers, 'g',15);
        ui->label->setText(new_label);
    }

    else if(button->text() == "%"){
        numbers = (ui->label->text().toDouble());
        numbers = numbers * 0.01;
        new_label = QString::number(numbers, 'g',15);
        ui->label->setText(new_label);
    }

    else if(button->text() == "1/x"){
        numbers = (ui->label->text().toDouble());
        numbers =  1/numbers;
        new_label = QString::number(numbers, 'g',15);
        ui->label->setText(new_label);
    }

    else if(button->text() == "√"){
        numbers = (ui->label->text().toDouble());
        numbers =  std::sqrt(numbers);
        new_label = QString::number(numbers, 'g',15);
        ui->label->setText(new_label);
    }

    else if(button->text() == "n!"){
        numbers = (ui->label->text().toDouble());
        numbers =  Factorial(numbers);
        new_label = QString::number(numbers, 'g',15);
        ui->label->setText(new_label);
    }

    else if(button->text() == "fib"){
        numbers = (ui->label->text().toDouble());
        numbers =  fib(numbers);
        new_label = QString::number(numbers, 'g',15);
        ui->label->setText(new_label);
    }
    else if(button->text() == "lg"){
        numbers = (ui->label->text().toDouble());
        numbers =  log10(numbers);
        new_label = QString::number(numbers, 'g',15);
        ui->label->setText(new_label);
    }
}

void MainWindow::math_operation(){
    QPushButton *button = (QPushButton *)sender();

    num_first = ui->label->text().toDouble();
    ui->label->setText("");
    button->setChecked(true);
}


void MainWindow::on_pushButton_11_clicked()
{

}


void MainWindow::on_pushButton_21_clicked()
{

}


void MainWindow::on_pushButton_23_clicked()
{

}


void MainWindow::on_pushButton_24_clicked()
{

}


void MainWindow::on_pushButton_22_clicked()
{

}


void MainWindow::on_result_clicked()
{
    double secondNum, labelNum;
    QString newLabel;
    secondNum = ui->label->text().toDouble();

    if(ui->pushButton_14->isChecked()){
        labelNum = num_first + secondNum;
        newLabel = QString::number(labelNum, 'g',15);
        ui->pushButton_14->setChecked(false);
        ui->label->setText(newLabel);
    }
    else if(ui->pushButton_15->isChecked()){
        labelNum = num_first * secondNum;
        newLabel = QString::number(labelNum, 'g',15);
        ui->pushButton_15->setChecked(false);
        ui->label->setText(newLabel);
    }

    else if(ui->pushButton_16->isChecked()){
        labelNum = num_first - secondNum;
        newLabel = QString::number(labelNum, 'g',15);
        ui->pushButton_16->setChecked(false);
        ui->label->setText(newLabel);
    }
    else if(ui->pushButton_17->isChecked()){
        if(secondNum != 0){
            labelNum = num_first / secondNum;
            newLabel = QString::number(labelNum, 'g',15);
            ui->pushButton_17->setChecked(false);
            ui->label->setText(newLabel);
        }else{
            ui->label->setText("0");
        }
    }else if(ui->pow->isChecked()){
        //x^y
        labelNum = pow(num_first, secondNum);
        newLabel = QString::number(labelNum, 'g',15);
        ui->pow->setChecked(false);
        ui->label->setText(newLabel);
    }
}

