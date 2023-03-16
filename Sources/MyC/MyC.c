#include "include/MyC.h"
#include "stdio.h"

void my_c_func1()
{
    printf("++++++++++++ my_c_func1()\n");
}

void my_c_func2(struct tty *tty)
{
    printf("\n");
    printf("(*tty).num1: %x\n", (*tty).num1);
    (*tty).num1 = 888;
}

void my_c_func3(struct tty tty)
{
    printf("\n");
    printf("tty.num1: %x\n", tty.num1);
    tty.num1 = 888;
    printf("&tty: %p\n", &tty);
}

void createPseudoTerminal(struct tty **tty)
{
    printf("\n");
    printf("createPseudoTerminal()\n");
    printf("(*tty)->num1: %x\n", (*tty)->num1);
    printf("(**tty).num2: %x\n", (**tty).num2);
    // printf("**tty: %x\n", **tty);
    printf("*tty: %p\n", *tty);
    printf("tty: %p\n", tty);
    printf("&tty: %p\n", &tty);
    (*tty)->num1 = 1;
    (**tty).num2 = 2;
    printf("(*tty)->num1: %x\n", (*tty)->num1);
    printf("(**tty).num2: %x\n", (**tty).num2);
    printf("\n");
    // *tty = pty_open_fake(&ios_pty_driver);
    // if (IS_ERR(*tty))
    //     return nil;
    // return (__bridge Terminal *) (*tty)->data;
}

void my_c_func4()
{
    printf("(int *)-0: %p\n", (int *)-0);
    printf("(int *)+0: %p\n", (int *)+0);
    printf("(int *)-1: %p\n", (int *)-1);
    printf("(int *)+1: %p\n", (int *)+1);
    printf("(int *)-2: %p\n", (int *)-2);
    printf("(int *)+2: %p\n", (int *)+2);

    printf("(struct fd *)+2: %p\n", (struct fd *)+2);
    printf("(struct fd *)-0: %p\n", (struct fd *)-0);
    printf("(struct fd *)+0: %p\n", (struct fd *)+0);
    printf("(struct fd *)-1: %p\n", (struct fd *)-1);
    printf("(struct fd *)-2: %p\n", (struct fd *)-2);

    printf("(double *)-2: %p\n", (double *)-2);
    printf("(int *)-2: %p\n", (int *)-2);
    printf("(char *)-2: %p\n", (char *)-2);

    int *p;
    printf("p: %p\n", p);
    printf("p - 2: %p\n", p - 2);

    int *p1 = (int *)-2;
    printf("p1: %p\n", p1);

    int *p3 = (int *)-0;
    printf("p3: %p\n", p3);

    struct fd *p2 = (struct fd *)-2;
    printf("p2: %p\n", p2);
}
