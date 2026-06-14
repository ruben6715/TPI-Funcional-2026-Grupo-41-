
;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Impura (puede imprimir en pantalla)
;; ESTRATEGIA: Función / Condicional 
;; IMPACTO: No destructiva 
;; ============================================================
(define (timer hora-unix)
  (let ((tiempo (modulo hora-unix 216))) 
    (cond 
      ((= tiempo 0)  (cambio-estado 'verde 'rojo))
      ((= tiempo 90) (cambio-estado 'rojo 'amarillo))
      ((= tiempo 96) (cambio-estado 'amarillo 'verde))
      ((< tiempo 90) 'rojo)
      ((< tiempo 96) 'amarillo)
      (else          'verde))))
;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura (No produce efectos secundarios y mapea entradas a salidas de forma determinista)
;; ESTRATEGIA: Función Predicado Condicional (Utiliza ramificaciones lógicas mediante cond y and)
;; IMPACTO: No destructiva (Crea una nueva lista en memoria sin modificar los argumentos originales)
;; ========================================================
(define (transicion color-actual cambiar-a)
  (cond 
    ((and (eq? color-actual 'en-rojo)     (eq? cambiar-a 'amarillo)) (list 'en-rojo "cambiar-a-amarillo"))
    ((and (eq? color-actual 'en-amarillo) (eq? cambiar-a 'verde))   (list 'en-amarillo "cambiar-a-verde"))
    ((and (eq? color-actual 'en-verde)    (eq? cambiar-a 'rojo))    (list 'en-verde "cambiar-a-rojo"))
    (else (list color-actual 'accion-por-defecto))))
