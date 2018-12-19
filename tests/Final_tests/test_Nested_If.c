void writeint(int i) { }
void writechar(char c) { }


int main(){
    int j;
    int k;

    j = 4;
    k = 4;

    if(j == 4)
    {
        if(k > 4)
        {
            writeint(k + 1);
        }
        else
        {
            writeint(k);
        }
    }
    return 0;
}