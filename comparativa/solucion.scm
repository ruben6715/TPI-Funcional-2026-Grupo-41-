
;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Impura (puede imprimir en pantalla)
;; ESTRATEGIA: Función / Condicional 
;; IMPACTO: No destructiva 
;; ============================================================
(define (timer hora-unix) ; Recibe como parámetro la hora del sistema en formato Unix (Epoch)
  (let ((tiempo (modulo hora-unix 216))) ; Obtiene la posición actual dentro del ciclo semafórico de 216 segundos
    (cond 
      ((< tiempo 120) 'verde)                ; Verde -----------------> 0 - 119
      ((< tiempo 126) 'amarillo)             ; Amarillo -------------> 120- 125
      (else 'rojo))))                        ; Rojo ----------------> 126 - 215
;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura (No produce efectos secundarios y mapea entradas a salidas de forma determinista)
;; ESTRATEGIA: Función Predicado Condicional (Utiliza ramificaciones lógicas mediante cond y and)
;; IMPACTO: No destructiva (Crea una nueva lista en memoria sin modificar los argumentos originales)
;; ========================================================
(define (transicion color-actual cambiar-a)
  ; Verifica si el cambio de luces solicitado es válido según el orden del semáforo
  (cond   ;Ciclo del semáforo: Verde-> Amarillo -> Rojo  -> Verde   
    ((and (eq? color-actual 'en-rojo)     (eq? cambiar-a 'verde))
     (list 'en-rojo "cambiar-a-verde")); Si está en rojo y la orden es pasar a verde (Transición válida: Rojo -> Verde)
    ((and (eq? color-actual 'en-amarillo) (eq? cambiar-a 'rojo))  
     (list 'en-amarillo "cambiar-a-rojo")); Si está en amarillo y la orden es pasar a rojo (Transición válida: Amarillo -> Rojo)
    ((and (eq? color-actual 'en-verde)    (eq? cambiar-a 'amarillo)) 
     (list 'en-verde "cambiar-a-amarillo")); Si está en verde y la orden es pasar a amarillo (Transición válida: Verde -> Amarillo)
    (else (list color-actual 'accion-por-defecto)))) ;Cualquier otra transicion no valerá y devolverá 'acción-por-defecto
