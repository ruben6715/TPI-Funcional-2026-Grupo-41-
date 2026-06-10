;; ============================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura ( solo retorna valores) 
;; ESTRATEGIA: Función  / Condicional 
;; IMPACTO: No destructiva (Retorna una nueva lista sin modificar argumentos) 
;; ============================================================
(defun trasicion (color-actual cambiar-a)
    (cond 
    	((and (eq color-actual 'en-rojo)(eq cambiar-a 'amarillo))(list 'en-rojo "cambiar-a-amarillo"))
    	((and (eq color-actual 'en-amarillo)(eq cambiar-a 'verde))(list 'en-amarillo "cambiar-a-verde"))
    	((and (eq color-actual 'en-verde)(eq cambiar-a 'rojo )(list 'en-verde "cambiar-a-rojo")))
        (t(list color-actual 'accion-por-defecto))))

;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Impura (puede imprimir en pantalla)
;; ESTRATEGIA: Función / Condicional 
;; IMPACTO: No destructiva 
;; ============================================================
(defun timer(hora-unix)
    (let( (tiempo (mod hora-unix 216)) ) 
        (cond 
            ((= tiempo 0) (cambio-estado 'verde 'rojo))
            ((= tiempo 90) (cambio-estado 'rojo 'amarillo))
            ((= tiempo 96) (cambio-estado 'amarillo 'verde))
            ((< tiempo 90) 'rojo)
            ((< tiempo 96) 'amarillo)
            (T 'verde))))

;; ============================================================
;; FUNCIÓN: cambio-estado
;; NATURALEZA: Impura (imprime en pantalla) 
;; ESTRATEGIA: Composición de funciones 
;; IMPACTO: No destructiva 
;; ============================================================
(defun cambio-estado(estado-ant estado-actual)
        (format t "~%Tiempo [~A]: La luz ha pasado de ~A a ~A." (formatear-hora) estado-ant estado-actual)
        (values))

;; ============================================================
;; FUNCIÓN: formatear-hora
;; NATURALEZA: Pura (devuelve la hora actual en formato legible para el usuario)
;; ESTRATEGIA: Composición funcional 
;; IMPACTO: No destructiva 
;; ============================================================
(defun formatear-hora()
    (local-time:format-timestring nil (local-time:now) 
        :format '((:year 4) "-" (:month 2) "-" (:day 2) " " (:hour 2) ":" (:min 2) ":" (:sec 2))))

;; ============================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Condicional
;; IMPACTO: No destructiva
;; ============================================================
(defun recomendacion-ciclo(duracion)
    (cond 
        ((< duracion 35) "Ciclo fuera del rango optimo: muy corto")
        ((> duracion 150) "Ciclo fuera del rango optimo: muy largo")
        (t "Ciclo dentro del rango optimo")))

;; ============================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Composición de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun duracion-ciclo (duracion-rojo duracion-amarillo duracion-verde)
    (let ((total (+ duracion-rojo duracion-amarillo duracion-verde)))
        (list total (recomendacion-ciclo total))))

;; ============================================================
;; FUNCIÓN: ciclo-por-tiempo
;; NATURALEZA: Pura (solo retorna valores)
;; ESTRATEGIA: Función / Composición de funciones
;; IMPACTO: No destructiva
;; ============================================================
(defun ciclo-por-tiempo (minutos)
    (let ((segundos (* minutos 60)) (duracion-ciclo (car (duracion-ciclo 90 6 120))))
        (floor (/ segundos duracion-ciclo))))

;; ============================================================
;; FUNCIÓN: distribucion-temporal
;; NATURALEZA: Pura
;; ESTRATEGIA: Orden superior (mapcar)
;; IMPACTO: No destructiva
;; ============================================================
(defun distribucion-temporal ()
    (let ((hora-segundos 36000) (duracion-ciclo (car (duracion-ciclo 90 6 120))) (ciclos (floor (/ hora-segundos duracion-ciclo))) (segundos-usados (* ciclos duracion-ciclo)) (colores '((rojo 90) (amarillo 6) (verde 120))))
        (mapcar (lambda (color)
                    (list (car color) (* (/ (* ciclos (cadr color)) segundos-usados) 100))) colores)))
