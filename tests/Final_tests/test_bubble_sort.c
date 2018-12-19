void writechar(char c) { return; }
void writeint(int i) { return; }
!!S
int main()
{
    int size;
    int arr [8];
    int changed;
    int i;
    int temp;

    arr[0] = 5;
    arr[1] = 7;
    arr[2] = 1;
    arr[3] = 4;
    arr[4] = 3;
    arr[5] = 2;
    arr[6] = 8;
    arr[7] = 6;

    changed = 1;
    size = 8;

    for (i = 0; i < size; i++)
    {
        writeint(arr[i]);
        writechar(' ');
    }
    writechar('\n');

    while (changed)
    {
        changed = 0;
        for (i = 0; i < size - 1; i++)
        {
            if (arr[i] > arr[i+1])
            {
                temp = arr[i];
                arr[i] = arr[i+1];
                arr[i+1] = temp;
                changed = 1;
            }
        }
    }

    !!S

    for (i = 0; i < size; i++)
    {
        writeint(arr[i]);
        writechar(' ');
    }
    writechar('\n');

    return 0;
}