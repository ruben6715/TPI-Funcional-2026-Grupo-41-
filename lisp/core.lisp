;; Iteracion 2 
;; EXTENSION 1

;; ============================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura ( solo retorna valores) 
;; ESTRATEGIA: Función  / Condicional 
;; IMPACTO: No destructiva (Retorna una nueva lista sin modificar argumentos) 
;; ============================================================
(defun transicion (color-actual cambiar-a)
    (cond 
        ;Ciclo del semáforo: Verde-> Verde intermitente->Amarillo -> Amarillo intermitente -> Rojo -> Rojo intermitente -> Verde   
        ((and (eq color-actual 'en-verde)(eq cambiar-a 'verde-intermitente)) (list 'en-verde "cambiar-a-verde-intermitente"))
        ((and (eq color-actual 'en-verde-intermitente)(eq cambiar-a 'amarillo)) (list 'en-verde-intermitente "cambiar-a-amarillo"))
        ((and (eq color-actual 'en-amarillo)(eq cambiar-a 'amarillo-intermitente)) (list 'en-amarillo "cambiar-a-amarillo-intermitente"))
        ((and (eq color-actual 'en-amarillo-intermitente)(eq cambiar-a 'rojo)) (list 'en-amarillo-intermitente "cambiar-a-rojo"))
        ((and (eq color-actual 'en-rojo)(eq cambiar-a 'rojo-intermitente)) (list 'en-rojo "cambiar-a-rojo-intermitente"))
        ((and (eq color-actual 'en-rojo-intermitente)(eq cambiar-a 'verde )) (list 'en-rojo-intermitente "cambiar-a-verde"))
        (t (list color-actual 'accion-por-defecto)))) ;Cualquier otra transicion no valerá y devolverá 'acción-por-defecto

;; EXTENSION 2 

;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Impura (puede imprimir en pantalla)
;; ESTRATEGIA: Función / Condicional
;; IMPACTO: No destructiva
;; ============================================================
(defun timer (hora-unix) ; Recibe como parámetro la hora del sistema en formato Unix (Epoch)
    (let ((tiempo (mod hora-unix 225))) ; Obtiene la posición actual dentro del ciclo semafórico de 225 segundos
        (cond
            ((= tiempo 0)   (informe 'rojo-intermitente 'verde hora-unix))
            ((= tiempo 120) (informe 'verde 'verde-intermitente hora-unix))
            ((= tiempo 123) (informe 'verde-intermitente 'amarillo hora-unix))
            ((= tiempo 129) (informe 'amarillo 'amarillo-intermitente hora-unix))
            ((= tiempo 132) (informe 'amarillo-intermitente 'rojo hora-unix))
            ((= tiempo 222) (informe 'rojo 'rojo-intermitente hora-unix))

            ((< tiempo 120) 'verde)                 ; Verde ----------------> 0 - 119
            ((< tiempo 123) 'verde-intermitente)    ; Verde intermitente ---> 120 - 122
            ((< tiempo 129) 'amarillo)              ; Amarillo -------------> 123 - 128
            ((< tiempo 132) 'amarillo-intermitente) ; Amarillo interm. -----> 129 - 131
            ((< tiempo 222) 'rojo)                  ; Rojo -----------------> 132 - 221
            (t 'rojo-intermitente))))               ; Rojo intermitente ----> 222 - 224

;; ============================================================
;; FUNCIÓN: informe (logging)
;; NATURALEZA: Impura (escribe en archivo)
;; ESTRATEGIA: Composicion de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun informe (estado-ant estado-actual hora-actual)
    (with-open-file (stream "informe-ejecucion-semaforo.txt"
                 :direction :output
                 :if-exists :append ;Si existe el archivo agrega no sobreescribe
                 :if-does-not-exist :create) ;Si no existe el archivo, lo crea
        (when (= (file-length stream) 0)
            (format stream "Informe de Ejecución del Sistema Semafórico~%")
            (format stream "=========================================~%"))

        (format stream "~%[~A]: La luz ha pasado de ~A a ~A." (formatear-hora hora-actual) estado-ant estado-actual)
        (format stream "~% --- Fin del Informe ---")))

;; ============================================================
;; FUNCIÓN: formatear-hora
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
(defun duracion-ciclo (duracion-verde duracion-amarillo duracion-rojo)
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
(defun recomendacion-ciclo(duracion) 
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
          (duracion-total (car (duracion-ciclo 120 6 90)))) ;Obtiene la duración total del ciclo semafórico (incluyendo los estados intermitentes)
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
           (ciclo-hora (ciclos-por-tiempo (/ hora-segundos 60)))
           ; Se obtiene la cantidad de ciclos completos que ocurren en una hora

           (colores (list (list 'verde (* 120 ciclo-hora))
                          (list 'amarillo (* 6 ciclo-hora))
                          (list 'rojo (* 90 ciclo-hora)))))
           ; Lista con cada color y la cantidad total de segundos
           ; acumulados durante una hora considerando todos los ciclos

        (mapcar (lambda (color)
                    (list (car color)
                          (* (/ (cadr color) hora-segundos) 100)))
                colores)))
                ; Genera una lista con:
                ; (nombre-color porcentaje-del-tiempo-en-una-hora)
                ; El porcentaje se calcula respecto de los 3600 segundos
                ; totales de una hora

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
                        (list 'verde (* 120 ciclo-hora))
                        (list 'verde-intermitente (* 3 ciclo-hora))
                        (list 'amarillo (* 6 ciclo-hora))
                        (list 'amarillo-intermitente (* 3 ciclo-hora))
                        (list 'rojo (* 90 ciclo-hora))
                        (list 'rojo-intermitente (* 3 ciclo-hora)))))
            ;Lista con los estados del semáforo y sus respectivos segundos acumulados con respecto a los ciclos por hora
        (mapcar (lambda (color)
                    (list (car color)
                          (* (/ (cadr color) hora-segundos) 100)))colores)))
                ;Lista final con el estado y su porcentaje de ocupación dentro de una hora expresado en número racional
