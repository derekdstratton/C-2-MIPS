void writeint(int i) { }
void writechar(char c) { }

int x(int i, int j) {
    return i + j;
}

int y() {
    int a;
    a = x(3, 4);
    return a + 1;
}

int main() {
    int z;
    z = y();
    writeint(z);
    return 0;
}