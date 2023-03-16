#include <stdlib.h>

struct tty {
   int num1;
   int num2;
};

struct fd {
   int num1;
   int num2;
   int num3;
};

void my_c_func1();
void my_c_func2(struct tty *tty);
void my_c_func3(struct tty tty);
void my_c_func4();
void createPseudoTerminal(struct tty **tty);
