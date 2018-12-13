void writechar(char c);
void writein(int i);

int main()
{
    int size = 8;
    int arr [8] = {5, 7, 1, 4, 3, 2, 8, 6};
    int changed = 1;
    int i;

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