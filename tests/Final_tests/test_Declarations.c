void writeint(int i) { }
void writechar(char c) { }


int main()
{
    int k;
    char j;
    int x[3];
    int y[1][2];
    int z[2][3][4];

    j = 'j';
    k = 5;

    x[0] = 0;
    y[0][1] = 1;
    z[1][2][2] = 3;

    writeint(k);
    writechar(j);
    writeint(x[0]);
    writeint(y[0][1]);
    writeint(z[1][2][2]);
    return 0;
}