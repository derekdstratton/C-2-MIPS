void writechar(char c) { }
void writeint(int i) { }

int main()
{
    int size = 8;
    int arr [8]; /*todo initialization list */
    int changed = 1;
    int i;

    arr[0] = 5;
    arr[1] = 7;
    arr[2] = 1;
    arr[3] = 4;
    arr[4] = 3;
    arr[5] = 2;
    arr[6] = 8;
    arr[7] = 6;

    for (i = 0; i < size; i++)
    {
        writeint(arr[i]);
        writechar(' ');
    }
    writechar('\n');

    while (changed)
    {
        changed = 0;
        for (i = 0; i < size; i++)
        {
            if (arr[i] > arr[i+1])
            {
                int temp = arr[i];
                arr[i] = arr[i+1];
                arr[i+1] = temp;
                changed = 1;
            }
        }
    }

    for (i = 0; i < size; i++)
    {
        writeint(arr[i]);
        writechar(' ');
    }
    writechar('\n');

    return 0;
}