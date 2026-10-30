# Actividad 4 — Analizador ascendente LALR con GNU Bison

**Materia:** Programación de Sistemas  
**Unidad:** 4. Análisis sintáctico  
**Unidad de Estudios Superiores:** Jiquipilco  
**Universidad:** Universidad Mexiquense del Bicentenario  
**Ingeniería:** Ingeniería en Sistemas Computacionales

| Dato | Información |
|---|---|
| Matrícula | 10240041 |
| Nombre | DIEGO DECIDERIO GARCÍA |
| Grupo | 10SC1051 |
| Fecha de entrega | 29 de octubre de 2026 |
| Repositorio | [actividad4_lalr_10240041](https://github.com/TecDeci2141/actividad4_lalr_10240041) |

---

## 1. Objetivo

Desarrollar un analizador sintáctico ascendente LALR mediante GNU Bison y Flex para reconocer un lenguaje sencillo de asignaciones y expresiones aritméticas.

El analizador reconoce sentencias de asignación, aplica reglas de precedencia y asociatividad de operadores, identifica números e identificadores y permite la recuperación de errores sintácticos mediante el punto y coma (`;`).

El programa también mantiene un catálogo léxico de identificadores, registrando su lexema, primera línea de aparición y número de apariciones.

El alcance del proyecto se limita al análisis léxico y sintáctico. No realiza análisis semántico, evaluación de expresiones, construcción de árboles sintácticos abstractos (AST) ni generación de código intermedio.

---

## 2. Lenguaje reconocido

El lenguaje permite realizar asignaciones mediante la siguiente estructura:

```text
identificador = expresion ;
```

### 2.1 Ejemplos de sentencias válidas

```text
total = precio + impuesto * 2.5;
promedio = (total + precio) / 2;
saldo = -cantidad * 2;
resultado = 2 ^ 3 ^ 2;
```

### 2.2 Gramática conceptual

```text
programa   → programa sentencia | ε

sentencia  → ID = expresion ;
           | error ;

expresion  → NUMERO
           | ID
           | ( expresion )
           | expresion + expresion
           | expresion - expresion
           | expresion * expresion
           | expresion / expresion
           | - expresion
           | expresion ^ expresion
```

### 2.3 Características gramaticales

- **Símbolo inicial:** `programa`.
- **Tipo de análisis:** ascendente LALR.
- **Recursividad:** gramática recursiva por la izquierda.
- **Asignación:** mediante el operador `=`.
- **Terminador de sentencia:** punto y coma (`;`).
- **Recuperación de errores:** mediante la producción `error PUNTO_COMA`.

### 2.4 Precedencia y asociatividad

La precedencia de los operadores, de menor a mayor, es:

| Operador | Función | Asociatividad |
|---|---|---|
| `+` | Suma | Izquierda |
| `-` | Resta | Izquierda |
| `*` | Multiplicación | Izquierda |
| `/` | División | Izquierda |
| `-` unario | Negación | Derecha |
| `^` | Potencia | Derecha |

La potencia tiene asociatividad por la derecha. Por lo tanto:

```text
2 ^ 3 ^ 2
```

Se interpreta como:

```text
2 ^ (3 ^ 2)
```

---

## 3. Conceptos fundamentales

| Concepto | Descripción |
|---|---|
| Desplazar (Shift) | Consumir el siguiente token y colocarlo en la pila del analizador. |
| Reducir (Reduce) | Sustituir una secuencia reconocida por el símbolo no terminal correspondiente. |
| LALR | Método de análisis sintáctico ascendente que combina estados LR compatibles para generar tablas más compactas. |
| Precedencia | Determina qué operador debe evaluarse primero dentro de una expresión. |
| Asociatividad | Determina cómo se agrupan operadores con el mismo nivel de precedencia. |
| Punto de sincronización | Token utilizado para continuar el análisis después de detectar un error. |
| Catálogo de identificadores | Registro léxico que almacena los identificadores encontrados durante el análisis. |

---

## 4. Herramientas y tecnologías

Para el desarrollo del proyecto se utilizaron las siguientes herramientas:

- **GNU Bison:** generación del analizador sintáctico LALR.
- **Flex:** generación del analizador léxico.
- **GCC:** compilación del código fuente en C.
- **Make:** automatización del proceso de compilación y pruebas.
- **Git:** control de versiones.
- **GitHub:** almacenamiento y administración del repositorio.
- **WSL Ubuntu:** entorno de desarrollo y ejecución.

### 4.1 Requisitos

Se requiere contar con:

- WSL 2 con Ubuntu.
- GNU Bison 3.6 o posterior.
- Flex.
- GCC con soporte para C11.
- Make.
- Git.
- zip y unzip.

---

## 5. Compilación y ejecución

### 5.1 Compilación

Para limpiar los archivos generados y compilar el proyecto:

```bash
make clean
make
```

El proceso equivale a ejecutar los siguientes comandos:

```bash
bison -Wall -d -v --report=state,solved parser_lalr.y

flex -o lex.yy.c lexer.l

gcc -D_POSIX_C_SOURCE=200809L -std=c11 \
-Wall -Wextra -Wpedantic -Werror \
parser_lalr.tab.c lex.yy.c -o parser_lalr
```

### 5.2 Ejecución

Para ejecutar el analizador sobre un archivo de entrada:

```bash
./parser_lalr pruebas/valido.ci
```

### 5.3 Pruebas automatizadas

Para ejecutar los casos de prueba:

```bash
make test
echo "make_test_exit=$?"
```

El resultado esperado es:

```text
make_test_exit=0
```

Esto indica que los casos de prueba obtuvieron los códigos de salida esperados.

---

## 6. Códigos de salida

El programa utiliza los siguientes códigos:

| Código | Descripción |
|---|---|
| 0 | Archivo procesado sin errores léxicos, sintácticos ni de catálogo. |
| 1 | Se detectó un error léxico, sintáctico o de capacidad del catálogo. |
| 2 | Uso incorrecto del programa o archivo no disponible. |

---

## 7. Resultados de las pruebas

Se realizaron diferentes pruebas para verificar el reconocimiento de sentencias, la precedencia de operadores, la recuperación de errores y el funcionamiento del catálogo de identificadores.

### 7.1 Casos de prueba

| Archivo | Código de salida | Resultado |
|---|---:|---|
| `valido.ci` | 0 | 2 sentencias válidas, 0 errores y 4 identificadores. |
| `limite.ci` | 1 | Error léxico y capacidad del catálogo excedida. |
| `regresion_unario.ci` | 0 | Reconocimiento correcto del menos unario. |
| `errores.ci` | 1 | 2 sentencias válidas, 2 errores y 2 recuperaciones. |
| `confusion.ci` | 1 | Rechazo del operador `==`. |
| `potencia.ci` | 0 | Reconocimiento de potencia asociativa a la derecha. |
| Sin argumento | 2 | Mensaje de uso del programa. |
| Archivo inexistente | 2 | Error al abrir el archivo. |

### 7.2 Salida de la prueba `valido.ci`

```text
TABLA_IDENTIFICADORES
total primera_linea=1 apariciones=2
precio primera_linea=1 apariciones=2
impuesto primera_linea=1 apariciones=1
promedio primera_linea=2 apariciones=1

RESUMEN sentencias_validas=2 errores_sintacticos=0 recuperaciones=0 identificadores=4
```

### 7.3 Salida de la prueba `errores.ci`

```text
RESUMEN sentencias_validas=2 errores_sintacticos=2 recuperaciones=2 identificadores=4
```

Los resultados muestran que el analizador puede continuar procesando el archivo después de encontrar errores sintácticos, utilizando el punto y coma como mecanismo de sincronización.

---

## 8. Pruebas con sanitizadores

Se utilizaron AddressSanitizer y UndefinedBehaviorSanitizer para detectar posibles errores de memoria y comportamientos indefinidos.

Comando de compilación:

```bash
gcc -D_POSIX_C_SOURCE=200809L -std=c11 \
-Wall -Wextra -Wpedantic -Werror \
-fsanitize=address,undefined -fno-omit-frame-pointer \
parser_lalr.tab.c lex.yy.c -o parser_lalr_san
```

Ejecución de pruebas:

```bash
./parser_lalr_san pruebas/valido.ci

./parser_lalr_san pruebas/errores.ci
```

**Resultado:** no se reportaron errores de AddressSanitizer, LeakSanitizer ni mensajes de comportamiento indefinido (`runtime error:`) durante las pruebas realizadas.

---

## 9. Preguntas de razonamiento

### 9.1 ¿Qué sucede cuando el analizador desplaza y reduce?

Cuando el analizador encuentra el estado correspondiente a:

```text
sentencia: ID ASIGNA expresion • PUNTO_COMA
```

Significa que ya reconoció el identificador, el operador de asignación y la expresión. Por lo tanto, espera el punto y coma.

Al recibir `PUNTO_COMA`, realiza una acción de desplazamiento (Shift).

Posteriormente, cuando reconoce:

```text
sentencia: ID ASIGNA expresion PUNTO_COMA •
```

La producción está completa y puede realizar una reducción (Reduce) al símbolo no terminal `sentencia`.

Esto demuestra que el análisis ascendente construye estructuras sintácticas a partir de los tokens de entrada.

### 9.2 ¿Por qué se utiliza la recursividad por la izquierda?

La recursividad por la izquierda permite representar expresiones binarias de manera natural para los analizadores LR y LALR.

Sin embargo, las producciones de expresiones por sí solas pueden generar ambigüedades. Para resolverlas se utilizan declaraciones de precedencia y asociatividad en Bison.

Por ejemplo:

```text
%left SUMA RESTA
%left MULTIPLICA DIVIDE
```

Estas declaraciones permiten que la multiplicación y la división tengan mayor precedencia que la suma y la resta.

### 9.3 ¿Cuál es la función del punto y coma en la recuperación de errores?

El punto y coma funciona como punto de sincronización.

La producción:

```text
error PUNTO_COMA
```

permite que Bison descarte tokens hasta encontrar el siguiente punto y coma, recuperando el análisis a partir de la siguiente sentencia.

En el archivo `errores.ci` se obtuvieron dos sentencias válidas, dos errores sintácticos y dos recuperaciones.

Esto demuestra que el analizador puede continuar procesando la entrada después de detectar errores.

### 9.4 ¿Cuál es la diferencia entre un catálogo de identificadores y una tabla de símbolos semántica?

El catálogo implementado registra únicamente:

- Lexema del identificador.
- Primera línea de aparición.
- Número de apariciones.

No comprueba declaraciones, tipos de datos, valores ni ámbitos.

Por lo tanto, se trata de un catálogo léxico y no de una tabla de símbolos semántica. Las verificaciones semánticas corresponden a etapas posteriores del proceso de compilación.

### 9.5 ¿Por qué `=` es válido y `==` genera un error?

El lenguaje reconoce el operador `=` como símbolo de asignación.

En cambio, `==` no está definido dentro de la gramática ni cuenta con un token correspondiente en el analizador léxico.

Por esta razón, al encontrar `==`, el analizador detecta una entrada que no pertenece al lenguaje reconocido y genera un error.

### 9.6 ¿Cómo se implementa la asociatividad derecha de la potencia?

La asociatividad derecha se establece mediante la declaración:

```text
%right POTENCIA
```

Esto permite que una expresión como:

```text
2 ^ 3 ^ 2
```

se interprete de la siguiente manera:

```text
2 ^ (3 ^ 2)
```

Además, la precedencia del menos unario se controla mediante:

```text
%prec NEGATIVO
```

La prueba `regresion_unario.ci`, que contiene:

```text
saldo = -cantidad * 2;
```

permite comprobar que el menos unario se reconoce correctamente sin confundirse con la resta binaria.

---

## 10. Conclusión

Se desarrolló un analizador sintáctico ascendente LALR utilizando GNU Bison y Flex. El proyecto permite reconocer sentencias de asignación y expresiones aritméticas, aplicando reglas de precedencia y asociatividad para resolver la agrupación de operadores.

También se implementó un catálogo léxico de identificadores y un mecanismo de recuperación de errores mediante el punto y coma como símbolo de sincronización.

Las pruebas realizadas permitieron comprobar el reconocimiento de expresiones válidas, el rechazo de entradas incorrectas, la recuperación ante errores sintácticos y el funcionamiento de las reglas gramaticales.

Finalmente, se identificó que el analizador se limita a las fases léxica y sintáctica, por lo que no realiza comprobaciones semánticas, evaluación de expresiones ni generación de código intermedio.

---

## 11. Estructura del repositorio

```text
actividad4_lalr/
├── parser_lalr.y
├── lexer.l
├── Makefile
├── .gitignore
├── README.md
├── pruebas/
│   ├── valido.ci
│   ├── limite.ci
│   ├── errores.ci
│   ├── confusion.ci
│   ├── regresion_unario.ci
│   └── potencia.ci
└── 1024004110292026.pdf
```

---

## 12. Repositorio

**GitHub:**  
https://github.com/TecDeci2141/actividad4_lalr_10240041.git