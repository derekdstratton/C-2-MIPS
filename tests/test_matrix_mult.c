void writechar(char c) { }
void writeint(int i) { }

int main()
{
    int mat_one[2][2];
    int mat_two[2][2];
    int res[2][2];
    int i;
    int j;
    int k;
    int t;
    int u;
    int a;

    a = 1;

    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            mat_one[i][j] = a;
            mat_two[i][j] = a;
            a++;
        }
    }

    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            res[i][j] = 0;
            for (k = 0; k < 2; k++)
            {
                t = mat_one[i][k];
                u = mat_two[k][j];
                res[i][j] += t * u;
            }
        }
    }

    return 0;
}