#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>

bool scramble(const std::string& s1, const std::string& s2){
  auto s1_begin = s1.begin();
  auto s1_end = s1.end();

  auto s2_begin = s2.begin();
  auto s2_end = s2.end();

  for (auto character : s2) {
    if (std::count(s1_begin, s1_end, character) <
      std::count(s2_begin, s2_end, character)) {
        return false;
    }
  }

    return true;
}

int main() {
    int size = 1000000000;

    std::string buffer1(size, '\x00');
    std::string buffer2(size, '\x00');

    std::ifstream urandom("/dev/urandom", std::ios::in|std::ios::binary);
    if (urandom) {
        urandom.read(&buffer1[0], size - 1);
        urandom.read(&buffer2[0], size - 1);
    } else {
        std::cerr << "Failed to open /dev/urandom" << std::endl;
    }
    urandom.close();

    std::replace(buffer1.begin(), buffer1.end(), '\x00', '\x01');
    std::replace(buffer2.begin(), buffer2.end(), '\x00', '\x01');
    buffer1.at(size - 1) = '\x00';
    buffer2.at(size - 1) = '\x00';

    std::cout << scramble(buffer1, buffer2) << std::endl;
    return 0;
}
