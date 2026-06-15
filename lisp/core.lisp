(defun main()
    (timer (local-time:timestamp-to-unix(local-time:now))))

;; ============================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura ( solo retorna valores) 
;; ESTRATEGIA: Función  / Condicional 
;; IMPACTO: No destructiva (Retorna una nueva lista sin modificar argumentos) 
;; ============================================================
(defun transicion (color-actual cambiar-a)
    (cond 
        ;Ciclo del semáforo: Verde-> Amarillo -> Rojo -> Verde   
        ((and (eq color-actual 'en-verde)(eq cambiar-a 'amarillo)) (list 'en-verde "cambiar-a-amarillo"))
        ((and (eq color-actual 'en-amarillo)(eq cambiar-a 'rojo)) (list 'en-amarillo "cambiar-a-rojo"))   
        ((and (eq color-actual 'en-rojo)(eq cambiar-a 'verde )) (list 'en-rojo "cambiar-a-verde"))
        (t (list color-actual 'accion-por-defecto)))) ;Cual otra transicion no valerá y devolverá 'acción-por-defecto

;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Impura (puede imprimir en pantalla)
;; ESTRATEGIA: Función / Condicional 
;; IMPACTO: No destructiva 
;; ============================================================
(defun timer(hora-unix) ;Recibe como parametro la hora del sistema en formato unix o Epoch
    (let( (tiempo (mod hora-unix 216)) ) ;Se toma el resto de la division de la hora con la duracion del ciclo semaforico (216 segundos) 
        (cond 
            ((= tiempo 0) (cambio-estado 'rojo 'verde hora-unix))             ; Ciclo completo:
            ((= tiempo 120) (cambio-estado 'verde 'amarillo hora-unix))       ; Verde -------> 0 - 119
            ((= tiempo 126) (cambio-estado 'amarillo 'rojo hora-unix))        ; Amarillo ----> 120 - 125
            ((< tiempo 120) 'verde)                                           ; Rojo --------> 126 - 215
            ((< tiempo 126) 'amarillo)                                   
            (T 'rojo)))) ; Si no se cumplen los anteriores períodos, por lógica se trata del color rojo

;; ============================================================
;; FUNCIÓN: cambio-estado
;; NATURALEZA: Impura (imprime en pantalla) 
;; ESTRATEGIA: Composición de funciones 
;; IMPACTO: No destructiva 
;; ============================================================
(defun cambio-estado (estado-ant estado-actual hora-actual)
    (if (not(eq (cadr(transicion estado-ant estado-actual)) 'accion-por-defecto))
    (progn
        (format t "Tiempo [~A]: La luz ha pasado de ~A a ~A." hora-actual estado-ant estado-actual)
        (values)) nil)) ; Funcion para remover el nil que retorna la funcion format t

;; ============================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Composición de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun duracion-ciclo (duracion-verde duracion-amarillo duracion-rojo) ;Recibe las duraciones en segundos de los colores
    (let ((total (+ duracion-verde duracion-amarillo duracion-rojo))) 
        (list total (recomendacion-ciclo total)))) ; Arma una lista con el total y el análisis de a funcion recomendacion-ciclo

;; ============================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Condicional
;; IMPACTO: No destructiva
;; ============================================================
(defun recomendacion-ciclo(duracion) 
    (cond 
        ; Analiza la duración total del ciclo semafórico calculada en duracion-ciclo
        ((< duracion 35) "Ciclo fuera del rango optimo: muy corto")
        ((> duracion 150) "Ciclo fuera del rango optimo: muy largo")
        (t "Ciclo dentro del rango optimo")))

;; ============================================================
;; FUNCIÓN: ciclo-por-tiempo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Composición de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun ciclos-por-tiempo (minutos)
    (let ((segundos (* minutos 60)) (duracion-total (car (duracion-ciclo 120 6 90)))) ;Con el car de la funcion obtiene el total de la duracion del ciclo
        (floor (/ segundos duracion-total)))) ; floor necesearia porque la division puede devolver un número decimal
        
;; ============================================================
;; FUNCIÓN: distribucion-temporal
;; NATURALEZA: Pura
;; ESTRATEGIA: Orden superior (mapcar)
;; IMPACTO: No destructiva
;; ============================================================
(defun distribucion-temporal ()
    (let* ((hora-segundos 3600) (ciclo-hora (ciclos-por-tiempo(/ hora-segundos 60))) ;Se obtiene la cantidad de ciclos en una hora
          (colores (list (list 'verde (* 120 ciclo-hora)) (list 'amarillo (* 6 ciclo-hora)) (list 'rojo (* 90 ciclo-hora)))))
          ;Lista con los colores y sus respectivos segundos con respecto a los ciclos por hora
        (mapcar (lambda (color)
                    (list (car color) (* (/ (cadr color) hora-segundos) 100))) colores))) 
                    ; Lista final con el color y su porcentaje expresado en numero racional

;Requerimiento 7
;; ============================================================
;; CASOS DE PRUEBA - transicion
;; ============================================================
;; Caso normal:
;; (transicion 'en-verde 'amarillo)
;; => (EN-VERDE "cambiar-a-amarillo")

;; Caso alternativo:
;; (transicion 'en-rojo 'verde)
;; => (EN-ROJO "cambiar-a-verde")

;; Caso de error:
;; (transicion 'en-verde 'azul)
;; => (EN-VERDE ACCION-POR-DEFECTO)

;; ============================================================
;; CASOS DE PRUEBA - timer
;; ============================================================
;; Caso normal:
;; (timer 50)
;; => VERDE

;; Caso alternativo:
;; (timer 123)
;; => AMARILLO

;; Caso de error:
;; (timer "hola")
;; => Error de tipo (MOD requiere un número)

;; ============================================================
;; CASOS DE PRUEBA - cambio-estado
;; ============================================================
;; Caso normal:
;; (cambio-estado 'rojo 'verde 1000)
;; => Imprime:
;; Tiempo [1000]: La luz ha pasado de ROJO a VERDE.

;; Caso alternativo:
;; (cambio-estado 'verde 'amarillo 1200)
;; => NIL

;; Caso de error:
;; (cambio-estado 'rojo)
;; => Error por cantidad incorrecta de argumentos.

;; ============================================================
;; CASOS DE PRUEBA - duracion-ciclo
;; ============================================================
;; Caso normal:
;; (duracion-ciclo 120 6 90)
;; => (216 "Ciclo fuera del rango optimo: muy largo")

;; Caso alternativo:
;; (duracion-ciclo 20 5 10)
;; => (35 "Ciclo dentro del rango optimo")

;; Caso de error:
;; (duracion-ciclo "120" 6 90)
;; => Error de tipo al intentar sumar.

;; ============================================================
;; CASOS DE PRUEBA - recomendacion-ciclo
;; ============================================================
;; Caso normal:
;; (recomendacion-ciclo 100)
;; => "Ciclo dentro del rango optimo"

;; Caso alternativo:
;; (recomendacion-ciclo 20)
;; => "Ciclo fuera del rango optimo: muy corto"

;; Caso de error:
;; (recomendacion-ciclo 'hola)
;; => Error de tipo en la comparación.

;; ============================================================
;; CASOS DE PRUEBA - ciclos-por-tiempo
;; ============================================================
;; Caso normal:
;; (ciclos-por-tiempo 60)
;; => 16 ;2/3

;; Caso alternativo:
;; (ciclos-por-tiempo 30)
;; => 8; 1/3

;; Caso de error:
;; (ciclos-por-tiempo "60")
;; => Error de tipo al multiplicar.

;; ============================================================
;; CASOS DE PRUEBA - distribucion-temporal
;; ============================================================
;; Caso normal:
;; (distribucion-temporal)
;; => ((VERDE 160/3) (AMARILLO 8/3) (ROJO 40))

;; Caso alternativo:
;; Ejecutar varias veces.
;; => Debe devolver siempre los mismos porcentajes
;; mientras las duraciones del ciclo no cambien.

;; Caso de error:
;; Si se modifica el código para que la duración total sea 0:
;; => Error de división por cero.
