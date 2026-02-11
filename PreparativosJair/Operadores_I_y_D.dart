void main(){
    int valor=6, vaalor2=7, valor3=9;
    print("Valores de incremento");
    print('Valor original ${valor}');
    print('Valor pre-incremento: ++variable ${++valor}');
    print('Valor post-incremento: variable++ ${vaalor2++}');
    print(vaalor2);
    valor+=3;//Esto puede funcionar para cualquier operador matematico
    print('Valor pre-incremento +3: ${++valor}');
    print("Valores decremento");
    print("Valor decremento original ${valor3}");
    print('Valor pre-decremento: --variable ${--valor3}');
    print('Valor post-decremento: variable-- ${valor3--}');
    print(valor3);
    valor3-=3;
    print('Valor pre-decremento -3: ${valor3}');
}