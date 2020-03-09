#include <vector>
#include <iostream>
#include <algorithm>
#include <utility>

long queueTime(std::vector<int> customers, int n) {
    if (!customers.size()) {
        return 0;
    }

    if (customers.size() < n) {
        return (long)*max_element(customers.begin(), customers.end());
    }

    std::vector<std::pair<int, int>> tills(n);
    std::vector<std::pair<int, int>>::iterator till;

    while (customers.size()) {
        // check if there are free tills
        int free_tills = 0;
        for (auto till : tills) {
            if (!till.first) {
                free_tills++;
            }
        }


        // assign the customer to a till
        for (int i = 0; i < free_tills; i++) {
            // if there are no more customers left
            if (!customers.size()) {
                break;
            }

            int customer = customers.front();
            customers.erase(customers.begin());

            for (till = tills.begin(); till != tills.end(); till++) {
                if (!till->first) {
                    till->first = customer;
                    break;
                }
            }
        }

        // let the customers do their job
        for (till = tills.begin(); till != tills.end(); till++) {
            if (till->first) {
                till->first--;
                till->second++;
            }
        }

    }

    // let the customers do their job at the end
    for (till = tills.begin(); till != tills.end(); till++) {
        if (till->first) {
            till->second += till->first;
        }
    }

    auto by_second = [&](const std::pair<int, int>& a, const std::pair<int, int>& b) {
        return a.second < b.second;
    };

    return (long) max_element(tills.begin(), tills.end(), by_second)->second;
}

int main() {
    std::vector<int> v = {2, 3, 10};
    std::cout << queueTime(v, 2) << std::endl;

    return 0;
}
