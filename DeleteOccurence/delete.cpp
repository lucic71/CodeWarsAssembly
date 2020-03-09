#include <vector>
#include <algorithm>
#include <iostream>

class VectorWrapper {
public:
    static std::vector<int> deleteNth(std::vector<int> arr, int n) {
        for (int elem : arr) {
            int occurences = std::count(arr.begin(), arr.end(), elem);

            for (int i = 0; i < occurences - n; i++) {
                auto iter = std::find(arr.rbegin(), arr.rend(), elem);
                if (iter != arr.rend()) {
                    auto toRemove = --(iter.base());
                    arr.erase(toRemove);
                }
            }

        }


        std::vector<int> result(arr.begin(), arr.end());
        return result;
    }

    static void print_vector(std::vector<int> arr) {
        for (auto element : arr) {
            std::cout << element << " ";
        }
        std::cout << std::endl;
    }

};

int main() {
    int n(1);
    std::vector<int> my_vector = {1,1,3,3,7,2,2,2,2};

    VectorWrapper::print_vector(my_vector);
    VectorWrapper::print_vector(VectorWrapper::deleteNth(my_vector, n));

    return 0;
}
