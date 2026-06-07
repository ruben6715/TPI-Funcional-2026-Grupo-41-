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
