;; Iteracion 2 
;; EXTENSION 2

;; ============================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura ( solo retorna valores) 
;; ESTRATEGIA: Función  / Condicional 
;; IMPACTO: No destructiva (Retorna una nueva lista sin modificar argumentos) 
;; ============================================================
(defun transicion (color-actual cambiar-a)
    (cond 
        ; Ciclo del semáforo: Rojo -> Rojo intermitente -> Verde -> Verde intermitente -> Amarillo -> Amarillo intermitente -> Rojo   
        ((and (eq color-actual 'en-rojo)(eq cambiar-a 'rojo-intermitente)) (list 'en-rojo "cambiar-a-rojo-intermitente"))
        ((and (eq color-actual 'en-rojo-intermitente)(eq cambiar-a 'verde )) (list 'en-rojo-intermitente "cambiar-a-verde"))
        ((and (eq color-actual 'en-verde)(eq cambiar-a 'verde-intermitente)) (list 'en-verde "cambiar-a-verde-intermitente"))
        ((and (eq color-actual 'en-verde-intermitente)(eq cambiar-a 'amarillo)) (list 'en-verde-intermitente "cambiar-a-amarillo"))
        ((and (eq color-actual 'en-amarillo)(eq cambiar-a 'amarillo-intermitente)) (list 'en-amarillo "cambiar-a-amarillo-intermitente"))
        ((and (eq color-actual 'en-amarillo-intermitente)(eq cambiar-a 'rojo)) (list 'en-amarillo-intermitente "cambiar-a-rojo"))
        (t (list color-actual 'accion-por-defecto))))

;; EXTENSION 2 

;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Impura (puede haber persistencia de datos)
;; ESTRATEGIA: Función / Condicional
;; IMPACTO: No destructiva
;; ============================================================
(defun timer (hora-unix) ; Recibe como parámetro la hora del sistema en formato Unix (Epoch)
    (let ((tiempo (mod hora-unix 225))) ; Obtiene la posición actual dentro del ciclo semafórico de 225 segundos
        (cond
            ((= tiempo 0)   (informe 'amarillo-intermitente 'rojo hora-unix))
            ((= tiempo 90) (informe 'rojo 'rojo-intermitente hora-unix))
            ((= tiempo 93) (informe 'rojo-intermitente 'verde hora-unix))
            ((= tiempo 213) (informe 'verde 'verde-intermitente hora-unix))
            ((= tiempo 216) (informe 'verde-intermitente 'amarillo hora-unix))
            ((= tiempo 222) (informe 'amarillo 'amarillo-intermitente hora-unix))

            ((< tiempo 90) 'rojo)                       ; Rojo ----------------> 0 - 89
            ((< tiempo 93) 'rojo-intermitente)          ; Rojo interm. --------> 90 - 92
            ((< tiempo 213) 'verde)                     ; Verde ---------------> 93 - 212
            ((< tiempo 216) 'verde-intermitente)        ; Verde interm. -------> 213 - 215
            ((< tiempo 222) 'amarillo)                  ; Amarillo ------------> 216 - 221
            (t 'amarillo-intermitente))))               ; Amarillo interm. ----> 222 - 224

;; ============================================================
;; FUNCIÓN: informe (logging)
;; NATURALEZA: Impura (escribe en archivo)
;; ESTRATEGIA: Composicion de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun informe (estado-ant estado-actual hora-actual)
    (if (not (eq (cadr (transicion estado-ant estado-actual)) 'accion-por-defecto))
        (progn
            (with-open-file (stream "informe-ejecucion-semaforo.txt"
                     :direction :output
                     :if-exists :append
                     :if-does-not-exist :create)
                (when (= (file-length stream) 0)
                    (format stream "Informe de Ejecución del Sistema Semafórico~%")
                    (format stream "=========================================~%"))

                (format stream "~%[~A]: La luz ha pasado de ~A a ~A." (formatear-hora hora-actual) estado-ant estado-actual)
                (format stream "~% --- Fin del Informe ---"))
            (format t "~%Se ha escrito correctamente en el archivo")
            (values))
            nil)) ; Si la transición no es válida, no escribe nada
       
;; ============================================================
;; FUNCIÓN: formatear-hora (fase 2 - utiliza libreria local-time)
;; NATURALEZA: Pura (devuelve la hora actual en formato legible para el usuario)
;; ESTRATEGIA: Composición funcional 
;; IMPACTO: No destructiva 
;; ============================================================
(defun formatear-hora(hora-actual) ; Función que convierteel formato de hora a uno más amigable para el usuario: [2026-01-30 00:01:30]
    (local-time:format-timestring nil (local-time:unix-to-timestamp hora-actual) ; Utiliza la función format-timestring de la libreria local-time
        :format '((:year 4) "-" (:month 2) "-" (:day 2) " " (:hour 2) ":" (:min 2) ":" (:sec 2))))
        ; Establece 4 digitos para el año, 2 para el mes, 2 para el dia, etc. Ademas de agregar caracteres en medio como "-" y ":"

;; ============================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Composición de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun duracion-ciclo (duracion-rojo duracion-verde duracion-amarillo)
    ; Recibe las duraciones de los estados principales del semáforo.
    ; Los tiempos de intermitencia se agregan internamente al cálculo
    ; de la duración total del ciclo.
    (let ((total (+ duracion-verde duracion-amarillo duracion-rojo 9))) ; La constante 9 = 3 segundos por cada fase intermitente
        (list total (recomendacion-ciclo total))))
        ; Devuelve una lista con:
        ; 1) Duración total del ciclo
        ; 2) Recomendación obtenida mediante recomendacion-ciclo

;; ============================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Condicional
;; IMPACTO: No destructiva
;; ============================================================
(defun recomendacion-ciclo (duracion) 
    (cond 
        ; Analiza la duración total del ciclo semafórico calculada en duracion-ciclo
        ((< duracion 35) "Ciclo fuera del rango optimo: muy corto")
        ((> duracion 150) "Ciclo fuera del rango optimo: muy largo")
        (t "Ciclo dentro del rango optimo")))

;; ============================================================
;; FUNCIÓN: ciclos-por-tiempo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Composición de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun ciclos-por-tiempo (minutos)
    (let ((segundos (* minutos 60))
          (duracion-total (car (duracion-ciclo 90 120 6)))) ;Obtiene la duración total del ciclo semafórico (incluyendo los estados intermitentes)
        (floor (/ segundos duracion-total))))
        ;Calcula cuántos ciclos completos pueden ejecutarse en el intervalo de tiempo indicado
    
;; ============================================================
;; FUNCIÓN: distribucion-temporal
;; NATURALEZA: Pura
;; ESTRATEGIA: Orden superior (mapcar)
;; IMPACTO: No destructiva
;; ============================================================
(defun distribucion-temporal ()
    (let* ((hora-segundos 3600)
            (ciclo-hora (ciclos-por-tiempo (/ hora-segundos 60))) ;Se obtiene la cantidad de ciclos en una hora
            (colores (list
                        (list 'rojo (* 90 ciclo-hora))
                        (list 'rojo-intermitente (* 3 ciclo-hora))
                        (list 'verde (* 120 ciclo-hora))
                        (list 'verde-intermitente (* 3 ciclo-hora))
                        (list 'amarillo (* 6 ciclo-hora))
                        (list 'amarillo-intermitente (* 3 ciclo-hora)))))
            ;Lista con los estados del semáforo y sus respectivos segundos acumulados con respecto a los ciclos por hora
        (mapcar (lambda (color)
                    (list (car color)
                          (* (/ (cadr color) hora-segundos) 100)))colores)))
                ;Lista final con el estado y su porcentaje de ocupación dentro de una hora expresado en número racional



;; Iteracion 2 
;; EXTENSION 1
; ESTAS DOS FUNCIONES (TIMER Y CAMBIO-ESTADO) SON LAS ÚNICAS QUE SUFREN CAMBIOS EN LA ITERACION 2 EXTENSION 2
;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Impura (puede imprimir en pantalla)
;; ESTRATEGIA: Función / Condicional
;; IMPACTO: No destructiva
;; ============================================================
;; (defun timer (hora-unix) ; Recibe como parámetro la hora del sistema en formato Unix (Epoch)
;;     (let ((tiempo (mod hora-unix 225))) ; Obtiene la posición actual dentro del ciclo semafórico de 225 segundos
;;         (cond
;;             ((= tiempo 0) (cambio-estado 'amarillo-intermitente 'rojo hora-unix))
;;             ((= tiempo 90) (cambio-estado 'rojo 'rojo-intermitente hora-unix))
;;             ((= tiempo 93) (cambio-estado 'rojo-intermitente 'verde hora-unix))
;;             ((= tiempo 213) (cambio-estado 'verde 'verde-intermitente hora-unix))
;;             ((= tiempo 216) (cambio-estado 'verde-intermitente 'amarillo hora-unix))
;;             ((= tiempo 222) (cambio-estado 'amarillo 'amarillo-intermitente hora-unix))

;;             ((< tiempo 90) 'rojo)                       ; Rojo ----------------> 0 - 89
;;             ((< tiempo 93) 'rojo-intermitente)          ; Rojo interm. --------> 90 - 92
;;             ((< tiempo 213) 'verde)                     ; Verde ---------------> 93 - 212
;;             ((< tiempo 216) 'verde-intermitente)        ; Verde interm. -------> 213 - 215
;;             ((< tiempo 222) 'amarillo)                  ; Amarillo ------------> 216 - 221
;;             (t 'amarillo-intermitente))))               ; Amarillo interm. ----> 222 - 224

;; ;; ============================================================
;; ;; FUNCIÓN: cambio-estado
;; ;; NATURALEZA: Impura (imprime en pantalla) 
;; ;; ESTRATEGIA: Composición de funciones 
;; ;; IMPACTO: No destructiva 
;; ;; ============================================================
;; (defun cambio-estado (estado-ant estado-actual hora-actual)
;;     (format t "Tiempo [~A]: La luz ha pasado de ~A a ~A." hora-actual estado-ant estado-actual)
;;     (values)) ; Funcion para remover el nil que retorna la funcion format t






;; ITERACION 1: 
;;                 REQUERIMIENTOS DEL 1 AL 7

;; ;; ============================================================
;; ;; FUNCIÓN: transicion
;; ;; NATURALEZA: Pura ( solo retorna valores) 
;; ;; ESTRATEGIA: Función  / Condicional 
;; ;; IMPACTO: No destructiva (Retorna una nueva lista sin modificar argumentos) 
;; ;; ============================================================
;; (defun transicion (color-actual cambiar-a)
;;     (cond 
;;         ;Ciclo del semáforo:  Rojo -> Verde-> Amarillo -> Rojo 
;;         ((and (eq color-actual 'en-rojo)(eq cambiar-a 'verde )) (list 'en-rojo "cambiar-a-verde"))
;;         ((and (eq color-actual 'en-verde)(eq cambiar-a 'amarillo)) (list 'en-verde "cambiar-a-amarillo"))
;;         ((and (eq color-actual 'en-amarillo)(eq cambiar-a 'rojo)) (list 'en-amarillo "cambiar-a-rojo"))
;;         (t (list color-actual 'accion-por-defecto)))) ;Cual otra transicion no valerá y devolverá 'acción-por-defecto

;; ;; ============================================================
;; ;; FUNCIÓN: timer
;; ;; NATURALEZA: Impura (puede imprimir en pantalla)
;; ;; ESTRATEGIA: Función / Condicional 
;; ;; IMPACTO: No destructiva 
;; ;; ============================================================
;; (defun timer (hora-unix) ;Recibe como parametro la hora del sistema en formato unix o Epoch
;;     (let( (tiempo (mod hora-unix 216)) ) ;Se toma el resto de la division de la hora con la duracion del ciclo semaforico (216 segundos) 
;;         (cond 
;;             ((= tiempo 0) (cambio-estado 'en-amarillo 'rojo hora-unix))             ; Ciclo completo:
;;             ((= tiempo 90) (cambio-estado 'en-rojo 'verde hora-unix))              ; Rojo     -------> 0 - 89
;;             ((= tiempo 210) (cambio-estado 'en-verde 'amarillo hora-unix))         ; Verde    -------> 90 - 209
;;             ((< tiempo 90) 'rojo)                                                  ; Amarillo -------> 210 - 215
;;             ((< tiempo 210) 'verde)                                      
;;             (T 'amarillo)))) ; Si no se cumplen los anteriores períodos, por lógica se trata del color amarillo

;; ;; ============================================================
;; ;; FUNCIÓN: cambio-estado
;; ;; NATURALEZA: Impura (imprime en pantalla) 
;; ;; ESTRATEGIA: Composición de funciones 
;; ;; IMPACTO: No destructiva 
;; ;; ============================================================
;; (defun cambio-estado (estado-ant estado-actual hora-actual)
;;     (if (not(eq (cadr(transicion estado-ant estado-actual)) 'accion-por-defecto))
;;     (progn
;;         (format t "Tiempo [~A]: La luz ha pasado de ~A a ~A." hora-actual estado-ant estado-actual)
;;         (values)) nil)) ; Funcion para remover el nil que retorna la funcion format t

;; ;; ============================================================
;; ;; FUNCIÓN: duracion-ciclo
;; ;; NATURALEZA: Pura (solo retorna valores)
;; ;; ESTRATEGIA: Función / Composición de funciones
;; ;; IMPACTO: No destructiva
;; ;; ============================================================
;; (defun duracion-ciclo (duracion-rojo duracion-verde duracion-amarillo) ;Recibe las duraciones en segundos de los colores
;;     (let ((total (+ duracion-rojo duracion-verde duracion-amarillo))) 
;;         (list total (recomendacion-ciclo total)))) ; Arma una lista con el total y el análisis de a funcion recomendacion-ciclo

;; ;; ============================================================
;; ;; FUNCIÓN: recomendacion-ciclo
;; ;; NATURALEZA: Pura (solo retorna valores)
;; ;; ESTRATEGIA: Función / Condicional
;; ;; IMPACTO: No destructiva
;; ;; ============================================================
;; (defun recomendacion-ciclo (duracion) 
;;     (cond 
;;         ; Analiza la duración total del ciclo semafórico calculada en duracion-ciclo
;;         ((< duracion 35) "Ciclo fuera del rango optimo: muy corto")
;;         ((> duracion 150) "Ciclo fuera del rango optimo: muy largo")
;;         (t "Ciclo dentro del rango optimo")))

;; ;; ============================================================
;; ;; FUNCIÓN: ciclo-por-tiempo
;; ;; NATURALEZA: Pura (solo retorna valores)
;; ;; ESTRATEGIA: Función / Composición de funciones
;; ;; IMPACTO: No destructiva
;; ;; ============================================================
;; (defun ciclos-por-tiempo (minutos)
;;     (let ((segundos (* minutos 60)) (duracion-total (car (duracion-ciclo 90 120 6)))) ;Con el car de la funcion obtiene el total de la duracion del ciclo
;;         (floor (/ segundos duracion-total)))) ; floor necesearia porque la division puede devolver un número decimal
        
;; ;; ============================================================
;; ;; FUNCIÓN: distribucion-temporal
;; ;; NATURALEZA: Pura
;; ;; ESTRATEGIA: Orden superior (mapcar)
;; ;; IMPACTO: No destructiva
;; ;; ============================================================
;; (defun distribucion-temporal ()
;;     (let* ((hora-segundos 3600) (ciclo-hora (ciclos-por-tiempo(/ hora-segundos 60))) ;Se obtiene la cantidad de ciclos en una hora
;;           (colores (list (list 'rojo (* 90 ciclo-hora)) (list 'verde (* 120 ciclo-hora)) (list 'amarillo (* 6 ciclo-hora)))))
;;           ;Lista con los colores y sus respectivos segundos con respecto a los ciclos por hora
;;         (mapcar (lambda (color)
;;                     (list (car color) (* (/ (cadr color) hora-segundos) 100))) colores))) 
;;                     ; Lista final con el color y su porcentaje expresado en numero racional

;; ;Requerimiento 7
;; ;; ============================================================
;; ;; CASOS DE PRUEBA - transicion
;; ;; ============================================================
;; ;; Caso normal:
;; ;; (transicion 'en-verde 'amarillo)
;; ;; => (EN-VERDE "cambiar-a-amarillo")

;; ;; Caso alternativo:
;; ;; (transicion 'en-rojo 'verde)
;; ;; => (EN-ROJO "cambiar-a-verde")

;; ;; Caso de error:
;; ;; (transicion 'en-verde 'azul)
;; ;; => (EN-VERDE ACCION-POR-DEFECTO)

;; ;; ============================================================
;; ;; CASOS DE PRUEBA - timer
;; ;; ============================================================
;; ;; Caso normal:
;; ;; (timer 50)
;; ;; => ROJO

;; ;; Caso alternativo:
;; ;; (timer 123)
;; ;; => VERDE

;; ;; Caso de error:
;; ;; (timer "hola")
;; ;; => Error de tipo (MOD requiere un número)

;; ;; ============================================================
;; ;; CASOS DE PRUEBA - cambio-estado
;; ;; ============================================================
;; ;; Caso normal:
;; ;; (cambio-estado 'en-rojo 'verde 1000)
;; ;; => Imprime:
;; ;; Tiempo [1000]: La luz ha pasado de EN-ROJO a VERDE.

;; ;; Caso alternativo:
;; ;; (cambio-estado 'verde 'amarillo 1200)
;; ;; => NIL

;; ;; Caso de error:
;; ;; (cambio-estado 'rojo)
;; ;; => Error por cantidad incorrecta de argumentos.

;; ;; ============================================================
;; ;; CASOS DE PRUEBA - duracion-ciclo
;; ;; ============================================================
;; ;; Caso normal:
;; ;; (duracion-ciclo 90 120 6)
;; ;; => (216 "Ciclo fuera del rango optimo: muy largo")

;; ;; Caso alternativo:
;; ;; (duracion-ciclo 10 20 5)
;; ;; => (35 "Ciclo dentro del rango optimo")

;; ;; Caso de error:
;; ;; (duracion-ciclo 90 "120" 6)
;; ;; => Error de tipo al intentar sumar.

;; ;; ============================================================
;; ;; CASOS DE PRUEBA - recomendacion-ciclo
;; ;; ============================================================
;; ;; Caso normal:
;; ;; (recomendacion-ciclo 100)
;; ;; => "Ciclo dentro del rango optimo"

;; ;; Caso alternativo:
;; ;; (recomendacion-ciclo 20)
;; ;; => "Ciclo fuera del rango optimo: muy corto"

;; ;; Caso de error:
;; ;; (recomendacion-ciclo 'hola)
;; ;; => Error de tipo en la comparación.

;; ;; ============================================================
;; ;; CASOS DE PRUEBA - ciclos-por-tiempo
;; ;; ============================================================
;; ;; Caso normal:
;; ;; (ciclos-por-tiempo 60)
;; ;; => 16 ;2/3

;; ;; Caso alternativo:
;; ;; (ciclos-por-tiempo 30)
;; ;; => 8; 1/3

;; ;; Caso de error:
;; ;; (ciclos-por-tiempo "60")
;; ;; => Error de tipo al multiplicar.

;; ;; ============================================================
;; ;; CASOS DE PRUEBA - distribucion-temporal
;; ;; ============================================================
;; ;; Caso normal:
;; ;; (distribucion-temporal)
;; ;; => ((ROJO 40) (VERDE 160/3) (AMARILLO 8/3))

;; ;; Caso alternativo:
;; ;; Ejecutar varias veces.
;; ;; => Debe devolver siempre los mismos porcentajes
;; ;; mientras las duraciones del ciclo no cambien.

;; ;; Caso de error:
;; ;; Si se modifica el código para que la duración total sea 0:
;; ;; => Error de división por cero.
