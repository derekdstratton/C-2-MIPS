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
    int num;
    int result;
    num = 5;
    if (num < 0)
    {
        writechar('X');
        return 0;
    }
    result = fact(num);
    writeint(result);
    return 0;
}