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
   (t(list color-actual 'accion-por-defecto))


	))