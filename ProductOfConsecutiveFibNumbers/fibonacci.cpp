#include <iostream>
#include <vector>
#include <cmath>
#include <iomanip>

#define PHI 1.61803399
typedef unsigned long long ull;

class ProdFib {
public:
    static std::vector<ull> productFib(ull prod) {
        std::vector<ull> result(3);

        ull first = 0, second = 1;
        bool found = false;
        while (1) {
            if (first * second == prod) {
                found = true;
                break;
            } else if (first * second > prod) {
                break;
            }

            second = first + second;
            first  = second - first;
        }

        result.at(0) = first;
        result.at(1) = second;
        result.at(2) = found;
        return result;
    }
};

int main() {

    int number = 5895;
    std::cout << number << std::endl << std::endl;
    std::vector<ull> result = ProdFib::productFib(number);

    for (auto fibo_number : result) {
        std::cout << fibo_number << " ";
    }
    std::cout << std::endl << result.at(0) * result.at(1) << std::endl;

    return 0;
}
