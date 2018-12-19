void writeint(int i) { }
void writechar(char c) { }

int main(){
    int j;
    int x[1][2][3];
    x[0][1][2] = 4;
    j = x[0][1][2];
    writeint(j);
    return 0;
}