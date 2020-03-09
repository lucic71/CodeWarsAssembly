#include <iostream>
#include <algorithm>
#include <vector>

class Sudoku {
public:
    static bool validSolution(unsigned int board[9][9]) {
        std::vector<int> column_sum(9);
        for (int vblock = 3; vblock <= 9; vblock += 3) {

            std::vector<int> line_sum(3);
            int column_sum_counter;
            for (int hblock = 3; hblock <= 9; hblock += 3) {

                int line_sum_counter = 0;
                int block_sum = 0;

                for (int i = vblock - 3; i < vblock; i++) {
                    column_sum_counter = hblock - 3;

                    for (int j = hblock - 3; j < hblock; j++) {
                        line_sum.at(line_sum_counter) += board[i][j];

                        if (board[i][j] < 1 || board[i][j] > 9) {
                            return false;
                        }

                        block_sum += board[i][j];
                        column_sum.at(column_sum_counter++) += board[i][j];
                    }

                    line_sum_counter++;
                }

                if (block_sum != 45) {
                    return false;
                }
            }

            if (std::count(line_sum.begin(), line_sum.end(), 45) != 3) {
                return false;
            }

        }

        if (std::count(column_sum.begin(), column_sum.end(), 45) != 9) {
            return false;
        }

        return true;

    }
};

int main() {
    unsigned int example1[9][9] = {{5, 3, 4, 6, 7, 8, 9, 1, 2},
                                   {6, 7, 2, 1, 9, 5, 3, 4, 8},
                                   {1, 9, 8, 3, 4, 2, 5, 6, 7},
                                   {8, 5, 9, 7, 6, 1, 4, 2, 3},
                                   {4, 2, 6, 8, 5, 3, 7, 9, 1},
                                   {7, 1, 3, 9, 2, 4, 8, 5, 6},
                                   {9, 6, 1, 5, 3, 7, 2, 8, 4},
                                   {2, 8, 7, 4, 1, 9, 6, 3, 5},
                                   {3, 4, 5, 2, 8, 6, 1, 7, 9}};

    std::cout << std::boolalpha << Sudoku::validSolution(example1) << std::endl;
    return 0;
}
