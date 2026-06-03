




;; ============================================================
;; FUNCIÓN: timer
;; NATURALEZA: Pura ( solo retorna valores) 
;; ESTRATEGIA: Función  / Condicional 
;; IMPACTO: No destructiva 
;; ============================================================


(defun timer (tiempoEpoch) 
(cond ((< (mod timestamp 216) 90)'rojo)
	((<(mod timestamp 216)96)'amarillo)
	(t'verde)))




