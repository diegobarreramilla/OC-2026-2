#include <stdio.h>

extern int maximo(int *arr, int len);
extern int minimo(int *arr, int len);
extern int sumatoria(int *arr, int len);

#define MAX_ELEMENTOS 5

int main(void)
{
    int arreglo[MAX_ELEMENTOS];
    int n;
    int i;

    printf("cantidad de numeros(1-%d): ", MAX_ELEMENTOS);
    fflush(stdout);

    if (scanf("%d", &n) != 1) {
        fputs("Entrada invalida.\n", stdout);
        return 1;
    }

    if (n < 1) {
        n = 1;
    }
    if (n > MAX_ELEMENTOS) {
        n = MAX_ELEMENTOS;
    }

    for (i = 0; i < n; i++) {
        printf("Numero %d: ", i + 1);
        fflush(stdout);

        if (scanf("%d", &arreglo[i]) != 1) {
            fputs("Entrada incorrecta\n", stdout);
            return 1;
        }
    }

    fputs("\nValores guardados en el arreglo:\n", stdout);
    for (i = 0; i < n; i++) {
        printf("arreglo[%d] = %d\n", i, arreglo[i]);
    }

    fputs("\nResultado:\n", stdout);
    printf("Maximo : %d\n", maximo(arreglo, n));
    printf("Minimo : %d\n", minimo(arreglo, n));
    printf("Sumatoria : %d\n", sumatoria(arreglo, n));

    return 0;
}
