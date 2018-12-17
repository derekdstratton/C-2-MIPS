void writechar(char c);
void writein(int i);

int main()
{
    int mat1[2][2];
    int mat2[2][2];
    int res[2][2];
    int i, j, k;

    /* initialize */

    /* print */

    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            res[i][j] = 0;
            for (k = 0; k < 2; k++)
            {
                res[i][j] += mat1[i][k] * mat2[k][j];
            }
        }
    }

    /* print */
}