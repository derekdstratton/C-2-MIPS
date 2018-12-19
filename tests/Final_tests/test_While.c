void writeint(int i) { }
void writechar(char c) { }

int main(){
    int j;
    j = 5;
    do{
        writeint(j);
        j--;
    }while(j > 0);
    return 0;
}