class Nave {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method velocidad() = velocidad
	method direccion() = direccion
	method combustible() = combustible
	
	method acelerar(cuanto){
		velocidad = 100000.min(velocidad + cuanto) 
	}
	
	method desacelerar(cuanto){
		velocidad = 0.max(velocidad - cuanto) 
	}
	
	method irHaciaElSol(){
		direccion = 10
	}
	
	method escaparDelSol(){
		direccion = -10
	}
	
	method ponerseParaleloAlSol(){
		direccion = 0
	}
	
	method acercarseUnPocoAlSol(){
		direccion = 10.min(direccion + 1)
	}
	
	method alejarseUnPocoDelSol(){
		direccion = -10.max(direccion - 1)
	}
	
	method cargarCombustible(cantidad){
		combustible += cantidad
	}
	
	method descargarCombustible(cantidad){
		combustible = 0.max(combustible - cantidad)
	}
	
	method prepararViaje(){
		self.prepararViajeAccionAdicional()
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila(){
		return combustible >= 4000 and velocidad < 12000
	}
	
	method prepararViajeAccionAdicional()
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	method escapar()	
	method avisar()
	
	method estaDeRelajo(){
		return self.estaTranquila() and self.tienePocaActividad()
	}
	
	method tienePocaActividad()
}


class Baliza inherits Nave{
	var color
	var cambioColorBaliza = false
	
	method color()=color
	
	method cambiarColorDeBaliza(colorNuevo){
		color = colorNuevo
		cambioColorBaliza = true
	}
	
	override method prepararViajeAccionAdicional(){
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila(){
		return super() and color != "rojo"
	}
	
	override method escapar(){
		self.irHaciaElSol()
	}
	
	override method avisar(){
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method tienePocaActividad(){
		return not cambioColorBaliza
	}
}

class Pasajero inherits Nave{
	var pasajeros
	var comida
	var bebida
	var racionesServidas = 0
	method pasajeros() = pasajeros
	method comida() = comida
	method bebida() = bebida
	method cargarComida(cantidad){
		comida += cantidad
	}
	method cargarBebida(cantidad){
		bebida += cantidad
	}
	method descargarComida(cantidad){
		racionesServidas += cantidad.min(comida) //Las raciones servidas que se suman no pueden superar la comida que hay actualmente disponible 
		comida = 0.max(comida-cantidad)
	}
	method descargarBebida(cantidad){
		bebida = 0.max(bebida-cantidad)
	}
	
	override method prepararViajeAccionAdicional(){
		self.cargarComida(pasajeros * 4)
		self.cargarBebida(pasajeros * 6)
		self.acercarseUnPocoAlSol()
	}
	
	override method escapar(){
		self.acelerar(velocidad)
	}
		
	override method avisar(){
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros * 2)
	}
	
	override method tienePocaActividad(){
		return racionesServidas < 50
	}
}

class Hospital inherits Pasajero{
	var property quirofanosPreparados = false
	
	override method estaTranquila(){
		return super() and not quirofanosPreparados
	}
	
	method prepararQuirofanos(){
		quirofanosPreparados = true
	}
	
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()	
	}
	
}

class Combate inherits Nave{
	var visible = true
	var misilesDesplegados = false
	const mensajes = []
	
	
	method ponerseVisible(){
		visible = true
	}
	
	method ponerseInvisible(){
		visible = false
	}
	
	method estaInvisible() = not visible
	
	method desplegarMisiles(){
		misilesDesplegados = true
	}
	
	method replegarMisiles(){
		misilesDesplegados = false
	}
	
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	
	method mensajesEmitidos() = mensajes.size()
	
	method primerMensajeEmitido(){
		if(mensajes.isEmpty())
			self.error("No se emitió ningún mensaje aún")
		return mensajes.first()
	}
	
	method ultimoMensajeEmitido(){
		if(mensajes.isEmpty())
			self.error("No se emitió ningún mensaje aún")
		return mensajes.last()
	}
	
	method esEscueta(){
		return mensajes.all({m => m.size() <= 30})
	}
	
	method emitioMensaje(mensaje){
		return mensajes.contains(mensaje)
	}
	
	override method prepararViajeAccionAdicional(){
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	
	override method estaTranquila(){
		return super() and not misilesDesplegados
	}
	
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method tienePocaActividad(){
		return self.esEscueta()
	}
}

class Sigilosa inherits Combate{
	override method estaTranquila(){
		return super() and visible
	}
	
	override method recibirAmenaza(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}
