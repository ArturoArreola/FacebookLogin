package mx.gox.infonavit.sicj.juicios

import grails.converters.JSON
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class AudienciaJuicioController {
    
    private static final Logger log = LogManager.getLogger(AudienciaJuicioController)
    
    def springSecurityService
    def audienciaJuicioService

    def index() {}
    
    def save() {
        log.info params
        def respuesta = [:]
        if(params.juicioAudienciaId){
            def usuario = springSecurityService.currentUser    
            respuesta = audienciaJuicioService.registrarAudiencia(params, usuario)
        } else{
            respuesta.error = "No se ha especificado el juicio al que se agregará la audiencia."
        }
        render respuesta as JSON
    }
    
    def obtenerDetallesAudiencia(){
        def respuesta
        if(params.audienciaId){
            log.info params
            respuesta = AudienciaJuicio.get(params.audienciaId as long)
            if(params.vista.equals('porJuicio')){
                def juicio = respuesta.juicio
                def actores = ActorJuicio.findAllWhere(juicio: juicio)
                render(template: "/templates/detalleAudienciaJuicio", model: [audiencia: respuesta, juicio: juicio, partes: actores])
            } else {
                def reprogramada = audienciaJuicioService.consultarAudienciasDiferidas(respuesta)
                render(template: "/templates/detalleAudiencia", model: [audiencia: respuesta, reprogramada: reprogramada])
            }
        } else{
            respuesta = [:]
            respuesta.error = "No se recibió el identificador de la audiencia."
            render(template: "/templates/detalleAudiencia", model: [error: respuesta])
        }
    }
    
    def update(){
        log.info params
        def respuesta = [:]
        if(params.audienciaId) {
            def audiencia = AudienciaJuicio.get(params.audienciaId as long)
            audiencia.acciones = params.accionesAudiencia
            audiencia.resultado = params.resultadoAudiencia
            if(params.diferirAudiencia.equals('on')){
                audiencia.cancelada = true
                audiencia.reprogramada = true
                audiencia.motivoDeReprogramacion = params.motivo
            }
            if(audienciaJuicioService.actualizarAudiencia(audiencia)){
                if(params.diferirAudiencia.equals('on')){
                    def usuario = springSecurityService.currentUser 
                    respuesta = audienciaJuicioService.diferirAudiencia(audiencia,usuario,params)
                } else {
                    respuesta.id = audiencia.id
                    respuesta.noDiferida = true
                    respuesta.color = "#1ab394"
                    respuesta.mensaje = "La audiencia ha sido actualizada con exitosamente."
                }
            } else {
                respuesta.error = "Ocurrio un error al actualizar la audiencia."
            }
        } else {
            respuesta.error = "No se recibió el identificador de la audiencia."
        }
        render respuesta as JSON
    }
    
    def cancelar(){
        log.info params
        def respuesta = [:]
        if(params.audienciaId) {
            def audiencia = AudienciaJuicio.get(params.audienciaId as long)
            audiencia.cancelada = true
            if(audienciaJuicioService.actualizarAudiencia(audiencia)){
                respuesta.id = audiencia.id
            } else {
                respuesta.error = "Ocurrio un error al actualizar la audiencia."
            }
        }
        render respuesta as JSON
    }
    
    def getReporteDeAudiencias(){
        log.info params
        def datos = []
        def roles = springSecurityService?.authentication?.authorities*.authority
        def usuario = springSecurityService.currentUser
        def fechaInicio = new Date().parse('yyyy-MM-dd',params.start)
        def fechaFin = new Date().parse('yyyy-MM-dd',params.end)
        def audiencias = audienciaJuicioService.consultarAudiencias(usuario, roles, fechaInicio, fechaFin, params.tipo, null)
        audiencias = audiencias.sort { it.fechaDeAudiencia }
        audiencias.each {
            def audiencia = [:]
            audiencia.audiencia = it
            audiencia.partes = ActorJuicio.executeQuery("Select aj.persona from ActorJuicio aj Where aj.juicio.id = :juicio And aj.tipoDeParte.id in (5,6)",[juicio: it.juicio.id])
            audiencia.prestacionReclamada = (((TipoAsociadoJuicio.findAllWhere(juicio: it.juicio))*.tipoAsociado)*.prestacionReclamada as Set)
            datos << audiencia
        }
        render(template: "/templates/reporteDeAudiencias", model: [datos: datos])
    }
}
