class Proyecto {
	const tareas = [ ]
	var property presupuestoInicial = 1000

	method agregarTarea(_tarea) {
		tareas.add(_tarea)
	}

	// Punto 1
	method provinciasConActividad(unaFecha, otraFecha) =
			self.tareasEntre(unaFecha, otraFecha).map({ tarea => tarea.provincia()
		})

	method tareasEntre(unaFecha, otraFecha) = 
		tareas.filter({ tarea => tarea.fechaEntre(unaFecha, otraFecha) })

	// Punto 2
	method superficiePromedio() = 
		self.superficieTotal() / self.cantidadDeTareas()

	method superficieTotal() = 
		tareas.sum { tarea => tarea.superficie() }

	method cantidadDeTareas() = tareas.size()

	// Punto 3
	method saldoA(unaFecha) =
		presupuestoInicial - self.montoDeTareasA(unaFecha)

	method montoDeTareasA(unaFecha) =
		self.tareasHasta(unaFecha).sum { tarea => tarea.monto() }

	method tareasHasta(unaFecha) =
		self.tareasEntre(self.fechaInicio(), unaFecha)

	method fechaInicio() = 
		tareas.sortBy({ t1 , t2 => t1.fecha() <	t2.fecha() }).first()

	method esCoherente() = 
		tareas.all({ tarea => tarea.sePuedeHacerPara(self) })
}

class Tarea {
	var property fecha = new Date()
	var property lugar
	const tareasPrecedentes = [ ]
	var property proyecto

	method fechaEntre(unaFecha, otraFecha) =
		fecha.between(unaFecha, otraFecha)

	// Punto 1
	method provincia() = lugar.provincia()

	// Punto 2
	method superficie() = lugar.superficie()

	// Punto 4
	method sePuedeHacerPara(_unProyecto) = 
		tareasPrecedentes.all({ tarea => tarea.sePuedeCumplirAntesDe(fecha) })

	method sePuedeCumplirAntesDe(unaFecha) = fecha < unaFecha

	// Punto 6
	method margenAnterior() {
		if (!self.tieneTareasPrecedentes()) {
			return 0
		}
		const ultimaTarea = self.tareasPrecedentesPorFecha().first()
		return fecha - ultimaTarea.fecha()
	}

	method tieneTareasPrecedentes() =
		!tareasPrecedentes.isEmpty()	
	
	method tareasPrecedentesPorFecha() =
		tareasPrecedentes.sort({ t1 , t2 => t1.fecha() > t2.fecha() })
}

class TareaProduccion inherits Tarea {
	const servicios = [ ]

	method agregarServicio(_servicio) {
		servicios.add(_servicio)
	}

	method monto() = 
		servicios.fold(0, { total , servicio => total + servicio.costo() })

	// Punto 4
	override method sePuedeHacerPara(_unProyecto) = 
		super(_unProyecto) && (_unProyecto.saldoA(fecha) > 0)
}

class TareaRecaudacion inherits Tarea {
	var property ingreso

	constructor(_ingreso) {
		ingreso = _ingreso
	}

	method monto() = ingreso * ( - 1 )
}

class TareaReunion inherits Tarea {
	method monto() = 0
}

class Oficina {
	method superficie() = 10
}

class Ciudad {
	var property superficie
}

class ZonaRural {
	var ancho = 10
	var largo = 10

	method superficie() = ancho * largo
}

class Servicio {
	const property costo

	constructor(_costo) {
		costo = _costo
	}

}
