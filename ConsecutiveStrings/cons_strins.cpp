#include <vector>
#include <string>
#include <iostream>

typedef std::vector<std::string> string_vector;
class LongestConsec {
public:
    static std::string longestConsec(string_vector& strarr, int k) {
        std::string result_string = "";
        std::cout << strarr.size() << std::endl;

        for (int i = 0; i < strarr.size() - k + 1; i++) {
            std::string temp_string("");
            for (int it = 0; it < k; it++) {
                temp_string += strarr.at(it + i);
            }
            if (temp_string.size() > result_string.size()) {
                result_string = temp_string;
            }
        }

        return result_string;
    }
};


int main() {
    string_vector arr =
        {"zone", "abigail", "theta", "form", "libe", "zas", "theta", "abigail"};

    std::cout << LongestConsec::longestConsec(arr, 2) << std::endl;

    return 0;
}
