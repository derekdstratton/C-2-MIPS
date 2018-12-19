void writeint(int i) { }
void writechar(char c) { }

int main(){
    int i;
    int j;
    for(i = 0; i < 5; i++)
    {
        writeint(i);
        for(j = 5; j > 0; j--)
        {
            writeint(j);
        }

    }
    return 0;
}