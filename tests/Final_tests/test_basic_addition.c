void writeint(int i) { }
void writechar(char c) { }

int main() {
    int a;
    int b;
    int c;
    a = 2;
    b = a;
    c = a + b;

    writeint(a);
    writechar(' ');
    writeint(b);
    writechar(' ');
    writeint(c);
    return 0;
}