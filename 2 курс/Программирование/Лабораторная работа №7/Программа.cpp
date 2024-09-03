#include <iostream>
#include <thread>
#include <chrono>

class TrafficLight {
public:
    enum class State {
        Normal,
        Emergency,
        Off
    };
};

void simulateLight(int numCycles, double duration) {
    for (int i = 0; i < numCycles; ++i) {
        std::cout << "�������" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(static_cast<int>(duration)));

        std::cout << "������" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(static_cast<int>(duration)));

        std::cout << "�������" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(static_cast<int>(duration)));
    }
}

void simulateLight_yellow(int numCycles, double duration) {
    for (int i = 0; i < numCycles; ++i) {
        std::cout << "������" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(static_cast<int>(duration)));
        std::cout << "��������" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(static_cast<int>(duration)));
    }
}

void displayState(const TrafficLight::State& state) {
    switch (state) {
    case TrafficLight::State::Normal:
        std::cout << "�������� �������� � ������� ������" << std::endl;
        break;
    case TrafficLight::State::Emergency:
        std::cout << "�������� �������� � ��������� ������, �������� ������" << std::endl;
        break;
    case TrafficLight::State::Off:
        std::cout << "�������� ��������" << std::endl;
        break;
    }
}

void setNormalMode(TrafficLight::State& state) {
    state = TrafficLight::State::Normal;
    std::cout << "������������ ��������� � ������� �����" << std::endl;
    simulateLight(3, 1);
    displayState(state);
}

void setEmergencyMode(TrafficLight::State& state) {
    state = TrafficLight::State::Emergency;
    std::cout << "������������ ��������� � ��������� �����" << std::endl;
    simulateLight_yellow(3, 1);
    displayState(state);
}

void turnOff(TrafficLight::State& state) {
    state = TrafficLight::State::Off;
    std::cout << "���������� ���������" << std::endl;
    displayState(state);
}

int main() {
    TrafficLight::State state = TrafficLight::State::Normal;
    int work = 1, command;
    system("chcp 1251");

    while (work) {
        std::cout << "�������� ��������:" << std::endl;
        std::cout << "1. ������� �����" << std::endl;
        std::cout << "2. ��������� �����" << std::endl;
        std::cout << "3. ���������" << std::endl;
        std::cout << "4. ���������� ������� ���������" << std::endl;
        std::cout << "0. �����" << std::endl;

        std::cin >> command;

        switch (command) {
        case 1:
            setNormalMode(state);
            break;

        case 2:
            setEmergencyMode(state);
            break;

        case 3:
            turnOff(state);
            break;

        case 4:
            displayState(state);
            break;

        case 0:
            work = 0;
            break;

        default:
            std::cout << "�������� �����. ����������, ���������� ��� ���." << std::endl;
        }
    }

    return 0;
}
