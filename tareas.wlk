class Proyecto {
	const tareas = [ ]
	var property presupuestoInicial = 1000

	method agregarTarea(tarea) {
		tareas.add(tarea)
	}

	// Punto 1
	method provinciasConActividad(unaFecha, otraFecha) =
			self.tareasEntre(unaFecha, otraFecha).map{ tarea => tarea.provincia()}.asSet()

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
		tareas.min{ t=> t.fecha()}.fecha() 

	method esCoherente() = 
		tareas.all({ tarea => tarea.sePuedeHacerPara(self) })
}

class Tarea {
	var property fecha = new Date()
	var property lugar
	const tareasPrecedentes = [ ]

	method fechaEntre(unaFecha, otraFecha) =
		fecha.between(unaFecha, otraFecha)

	// Punto 1
	method provincia() = lugar.provincia()

	// Punto 2
	method superficie() = lugar.superficie()

	// Punto 4
	method sePuedeHacerPara(unProyecto) = 
		tareasPrecedentes.all({ tarea => tarea.sePuedeCumplirAntesDe(fecha) })

	method sePuedeCumplirAntesDe(unaFecha) = fecha < unaFecha

	// Punto 6
	method margenAnterior() {
		if (!self.tieneTareasPrecedentes()) {
			return 0
		}
		const ultimaTarea = tareasPrecedentes.max{t=> t.fecha()}
		return fecha - ultimaTarea.fecha()
	}

	method tieneTareasPrecedentes() =
		!tareasPrecedentes.isEmpty()

}

class TareaProduccion inherits Tarea {
	const servicios = [ ]

	method agregarServicio(servicio) {
		servicios.add(servicio)
	}

	method monto() = 
		servicios.sum{servicio => servicio.costo() }

	// Punto 4
	override method sePuedeHacerPara(unProyecto) = 
		super(unProyecto) && (unProyecto.saldoA(fecha) > 0)
}

class TareaRecaudacion inherits Tarea {
	var property ingreso

	method monto() = ingreso * ( - 1 )
}

class TareaReunion inherits Tarea {
	method monto() = 0
}

class Oficina {
	var property ciudad
	method superficie() = 10
	method provincia() = ciudad.provincia()
}

class Ciudad {
	var property provincia
	var property superficie
}

class ZonaRural {
	var ancho = 10
	var largo = 10
	var property provincia

	method superficie() = ancho * largo
}

class Servicio {
	const property costo
}
