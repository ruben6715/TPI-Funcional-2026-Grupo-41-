# TrPI-Funcional-2026-Grupo-41
> **Trabajo Práctico Integrador 2026** > **Asignatura:** Paradigmas de Programación (Paradigma Funcional)  
> **Institución:** Universidad Nacional del Nordeste (UNNE)  
> **Facultad:** Facultad de Ciencias Exactas y Naturales y Agrimensura (FaCENA)  
> **Carrera:** Licenciatura en Sistemas de Información  
> **Fecha de Entrega:** Martes 16 de Junio de 2026

---

## 👥 Integrantes del Grupo

| Apellido y nombre | Usuario de GitHub |
| :--- | :--- |
| Sandoval, Diego Ulises | [@sandovalDiegoUlises](https://github.com/sandovalDiegoUlises) |
| Romero Férnandez, Ruben Tiburcio | [@ruben6715](https://github.com/ruben6715) |
| Sarli Ochat, Melina | [@meliochat](https://github.com/meliochat) |

📺 **Enlace a la Defensa Técnica (YouTube):** [Video explicativo del flujo de datos (5-10 min)](https://youtube.com/tu-enlace-aqui)

---

## 📋 Descripción del Proyecto
Este proyecto consiste en el diseño e implementación del núcleo lógico para un **Sistema de Semáforos Inteligentes** embebido, orientado a optimizar el flujo vehicular urbano.

La solución ha sido estructurada bajo los lineamientos del **Paradigma Funcional** en Common Lisp, aplicando restricciones rigurosas de diseño: **inmutabilidad absoluta** (evitando el uso de variables globales mutables como `defparameter` o `defvar` y operadores destructivos como `setq` o `setf`), **funciones puras**, **composición funcional** y **funciones de orden superior** (`mapcar`, `lambda`) para omitir cualquier mecanismo iterativo imperativo clásico.

El software evoluciona a través de las siguientes etapas obligatorias:
1. **Fase 1 (El problema de los 3 focos):** Modelado de la máquina de estados secuencial básica (Verde → Amarillo → Rojo) y métricas matemáticas de optimización de ciclos.
2. **Fase 2 (Autonomía y Ecosistema - Iteración 2):** * **Extensión 1 (Intermitencia de Seguridad):** Inclusión de estados intermedios de 3 segundos (`verde-intermitente`, `amarillo-intermitente`, `rojo-intermitente`) elevando el ciclo total a 225 segundos para garantizar la seguridad vial.
   * **Extensión 2 (Persistencia de Datos):** Implementación de un sistema de logging asincrónico que escribe los registros históricos en un archivo forense de texto plano (`informe-ejecucion-semaforo.txt`) formateando el tiempo de manera legible mediante la librería externa `local-time`.
3. **Fase 3 (Estudio Comparativo de Paradigmas):** Reimplementación de la lógica nuclear (`transicion` y `timer`) en un segundo lenguaje de programación asignado por la cátedra para evaluar analíticamente las diferencias operativas en el manejo del flujo de datos.

---

## 🗂️ Arquitectura del Repositorio
Cumpliendo con la estructura organizativa obligatoria exigida por la cátedra:

```plaintext
TPI-Funcional-2026-Grupo/
├── lisp/
│   ├── core.lisp          <-- Código completo unificado en Common Lisp (Req. 1 al 7)
│   └── informe-ejecucion-semaforo.txt <-- Archivo físico generado por el sistema de logs
├── comparativa/
│   └── solucion.[ext]     <-- Código fuente en el segundo lenguaje asignado
├── docs/
│   ├── INFORME.pdf        <-- Respuestas analíticas, bitácora de bugs y diseño conceptual
│   └── HONOR.md           <-- Declaración jurada obligatoria del Código de Honor firmada
└── README.md              <-- Portada principal del repositorio (Este archivo)

```
---
## 🛠️ Taxonomía del Núcleo de Funciones (Common Lisp)
Cada uno de los componentes algorítmicos embebidos en `lisp/core.lisp` cuenta con una clasificación explícita basada en su Naturaleza, Estrategia e Impacto en Memoria:

### ⏱️ Control de Tiempos y Transiciones (Máquina de Estados)
* **`transicion (color-actual cambiar-a)`**
  * **Naturaleza:** Pura (sin efectos secundarios).
  * **Estrategia:** Condicional analítico (`cond`).
  * **Impacto:** No destructiva (construye una nueva estructura de datos de retorno sin mutar argumentos).
  * **Descripción:** Gobierna las transiciones lógicas válidas del semáforo incorporando los estados intermitentes de seguridad. Ante transiciones inválidas, devuelve `'accion-por-defecto`.
* **`timer (hora-unix)`**
  * **Naturaleza:** Impura (dispara la escritura y actualización de logs externos).
  * **Estrategia:** Condicional.
  * **Impacto:** No destructiva.
  * **Descripción:** Recibe la estampa temporal del sistema en formato Unix (Epoch). Aplica una operación `(mod hora-unix 225)` para determinar la posición exacta del flujo en el tiempo físico y decidir los estados y cambios de estado correspondientes.
* **`informe (estado-ant estado-actual hora-actual)`**
  * **Naturaleza:** Impura (Efecto secundario de Entrada/Salida).
  * **Estrategia:** Composición funcional con persistencia física.
  * **Descripción:** Actúa como el subsistema de auditoría forense del semáforo. Captura las transiciones e impacta un registro histórico cronológico append-only en el archivo `informe-ejecucion-semaforo.txt`.
* **`formatear-hora (hora-actual)`**
  * **Naturaleza:** Pura.
  * **Estrategia:** Composición a través del ecosistema de bibliotecas externas `quicklisp`.
  * **Descripción:** Intercepta marcas de tiempo en segundos abstractos y las traduce a cadenas estructuradas con formato humano (`YYYY-MM-DD HH:MM:SS`) interactuando con la librería `local-time`.

### 📊 Análisis Logístico e Ingeniería de Tráfico
* **`duracion-ciclo (verde amarillo rojo)`**
  * **Naturaleza:** Pura.
  * **Estrategia:** Composición y empaquetamiento de listas.
  * **Descripción:** Evalúa las duraciones nominales de las luces, calcula dinámicamente el tiempo total del ciclo y adjunta el reporte cualitativo provisto por la función de recomendación.
* **`recomendacion-ciclo (duracion)`**
  * **Naturaleza:** Pura.
  * **Estrategia:** Condicional.
  * **Descripción:** Provee un análisis de optimización basado en la psicología del conductor y flujos de saturación de ingeniería vial (Rango óptimo estandarizado: 35 a 150 segundos).
* **`ciclos-por-tiempo (minutos)`**
  * **Naturaleza:** Pura.
  * **Estrategia:** Composición funcional y truncamiento exacto (`floor`).
  * **Descripción:** Convierte minutos a segundos para planificar cuántas ciclos semafóricos ocurrirán en un período de tiempo definido que es recibido por parámetro.
* **`distribucion-temporal ()`**
  * **Naturaleza:** Pura.
  * **Estrategia:** Funciones de Orden Superior (`mapcar` y expresiones `lambda`).
  * **Descripción:** Calcula el porcentaje de uso/ocupación de la calzada pública para cada una de las fases del semáforo (estados puros e intermitentes) a lo largo de una hora completa de servicio ininterrumpido (3600 segundos), devolviendo resultados en formato racional.

---

## ⚙ Instrucciones de Configuración y Ejecución
Para desplegar y validar el entorno integral del simulador en tu intérprete local de Common Lisp, sigue estos pasos:

### Prerrequisitos
Tener instalado el gestor de dependencias **Quicklisp**. Si no está instalado, inicialízalo en tu terminal Lisp.

### Carga del Sistema
Ejecuta los siguientes comandos secuenciales en el REPL:

```text
;; 1. Descargar e instalar la biblioteca para formatear timestamps
(ql:quickload :local-time)

;; 2. Cargar el script de lógica central del semáforo
(load "lisp/core.lisp")

;; 3. Probar cada una de las funciones 
En este paso puede ayudarse del requerimiento 7 incluido en uno 
de los commits
```
---
## 🧪 Aseguramiento de la Calidad (Requerimiento 7)
Para dar estricto cumplimiento al Requerimiento 7 solicitado por el equipo de Control de Calidad (QA), el archivo `lisp/core.lisp` incluye bloques dedicados de casos de prueba en el *(**commit cc4bea5**)* listos para ser copiados y pegados directamente sobre la consola de ejecución.

#### Cada bloque metodológico evalúa:
* **Flujo Normal (Camino Feliz):** Verificación de respuestas correctas bajo entradas ideales (ej. transiciones válidas, cálculo de ciclos estandarizados).
* **Caminos Alternativos:** Comportamiento ante otros parámetros aceptados o estados fuera de rango (ej. caídas en la rama `T` de `transicion` devolviendo `'accion-por-defecto`, o evaluaciones de ciclos muy cortos/largos).
* **Casos de Generación de Errores:** Demostración de robustez del sistema y excepciones lógicas provocadas intencionalmente al inyectar tipos de datos inválidos (cadenas de texto en funciones matemáticas o ausencia de argumentos requeridos).
