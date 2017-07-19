package mx.gox.infonavit.sicj

import grails.converters.JSON
import mx.gox.infonavit.sicj.juicios.Juicio
import mx.gox.infonavit.sicj.catalogos.EstadoDeJuicio
import mx.gox.infonavit.sicj.catalogos.Materia
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class PerfilDeUsuarioController {

    private static final Logger log = LogManager.getLogger(PerfilDeUsuarioController)
    def springSecurityService
    def passwordEncoder
    
    def index() {
        def usuario = springSecurityService.currentUser
        def juiciosPorUsuario = []
        def estados = EstadoDeJuicio.findAll("from EstadoDeJuicio ej Where ej.id not in (6,7)")
        def materias = Materia.findAll("from Materia m Order by m.id")
        estados?.each { estado ->
            def registro = [:]
            registro.estado = estado
            materias?.each { materia ->
                registro[materia.nombreCarpeta] = asuntosPorEstadoMateria(usuario, materia, estado)
            }
            log.info registro
            juiciosPorUsuario << registro
        }
        [usuario: usuario, juiciosPorUsuario: juiciosPorUsuario]
    }
    
    def actualizarClave(){
        log.info params
        def respuesta = [:]
        def usuario = springSecurityService.currentUser
        if (passwordEncoder.isPasswordValid(usuario.password, params.passActual, null)) {
            usuario.password = params.nuevoPass
            if(usuario.save(flush:true)){
                respuesta.exito = true
                respuesta.mensaje = "La solcitud ha sido aprobada correctamente"
            } else {
                respuesta.mensaje = "Ocurrio un problema al aprobar la solicitud. Intente nuevamente en unos minutos"
            }
        } else {
            respuesta.mensaje = "La contraseña introducida es incorrecta"
        }
        render respuesta as JSON
    }
    
    def asuntosPorEstadoMateria(def usuario, def materia, def estado){
        def juicios = 0
        def consulta = Juicio.createCriteria()
        juicios = consulta.get {
            eq("creadorDelCaso", usuario)
            eq("materia", materia)
            eq("estadoDeJuicio", estado)
            projections {
                countDistinct "id"
            }
        }
        return juicios
    }
}
