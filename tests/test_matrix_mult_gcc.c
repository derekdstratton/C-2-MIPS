#include <stdio.h>

void writechar(char c);
void writeint(int i);

int main()
{
    int mat1[2][2];
    int mat2[2][2];
    int res[2][2];
    int i, j, k;

    /* initialize */
    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            mat1[i][j] = i;
            mat2[i][j] = j;
        }
    }

    /* print */
    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            printf("%d ", mat1[i][j]);
        }
        printf("\n");
    }

    /* print */
    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            printf("%d ", mat2[i][j]);
        }
        printf("\n");
    }

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
    for (i = 0; i < 2; i++)
    {
        for (j = 0; j < 2; j++)
        {
            printf("%d ", res[i][j]);
        }
        printf("\n");
    }
}