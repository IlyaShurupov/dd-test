#include <stdio.h>

unsigned char mem[] = { 0x6A, 0xCB, 0x39, 0x97, 0x78, 0xC5, 0x71, 0x8F };

unsigned char read(int idx, bool right) {
  return right ? mem[idx] & 0x0F : (mem[idx] & 0xF0) >> 4;
}

void write(unsigned char val, int idx, bool right) {
  val &= 0x0F;
  val = right ? val : val << 4;
  mem[idx] |= val;
}

int main() {
  unsigned char reg;

  reg = read(0x01, 1);
  write(reg, 0x02, 1);

  reg = read(0x02, 1);
  write(reg, 0x07, 0);

  reg = read(0x07, 0);

  printf("Final val ");
  for (auto i = 0; i < 4; i++) {
  	printf("%i", int((reg >> (3 - i)) & 1));
  }
}