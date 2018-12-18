#include <stdio.h>

void writeint(int i) { }
void writechar(char c) { }

int fact(int num)
{
    if (num == 0)
    {
        return 1;
    }
    return num * fact(num - 1);
}

int main()
{
    int num = 5;
    if (num < 0)
    {
        writechar('X');
        printf("X");
        return 0;
    }
    int result = fact(num);
    writeint(result);
    printf("%d", result);

    return 0;
}