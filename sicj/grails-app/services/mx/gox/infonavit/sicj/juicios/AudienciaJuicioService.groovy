package mx.gox.infonavit.sicj.juicios

import grails.transaction.Transactional
import mx.gox.infonavit.sicj.catalogos.TipoDeAudiencia

@Transactional
class AudienciaJuicioService {

    def registrarAudiencia(def params, def usuario) {
        def audiencia = new AudienciaJuicio()
        def audienciaMap = [:]
        def fecha = params.fechaAudiencia + " " + params.horaAudiencia
        audiencia.juicio = Juicio.get(params.juicioAudienciaId as long)
        audiencia.fechaDeAudiencia = new Date().parse('dd/MM/yyyy HH:mm',fecha)
        audiencia.tipoDeAudiencia = TipoDeAudiencia.get(params.tipoDeAudiencia.id as long)
        audiencia.usuarioQueRegistro = usuario
        audiencia.fechaDeRegistro = new Date()
        audiencia.asistente = params.nombreAsistente
        if(audiencia.save(flush:true)) {
            audienciaMap.id = audiencia.id
            audienciaMap.title = audiencia.juicio.expedienteInterno
            audienciaMap.start = audiencia.fechaDeAudiencia
            audienciaMap.allDay = false
            audienciaMap.color = '#f8ac59'
        } else {
            audienciaMap.error = "Ocurrio un error al registrar la fecha de la audiencia."
        }
        return audienciaMap
    }
    
    def consultarAudiencias(def usuario, def roles, def fechaInicio, def fechaFin, def tipoDeConsulta, def juicioId){
        def audiencias 
        audiencias = AudienciaJuicio.withCriteria {
            between('fechaDeAudiencia', fechaInicio, fechaFin)
            if(tipoDeConsulta == 'reales') {
                eq('cancelada', false)
                eq('reprogramada', false)
                if(usuario.tipoDeUsuario == "EXTERNO"){
                    juicio {
                        eq('despacho',usuario.despacho)
                    }
                } else if(usuario.tipoDeUsuario == "INTERNO" && !roles.contains("ROLE_ADMIN")){
                    juicio {
                        eq('delegacion',usuario.delegacion)
                    }
                }
            } else if(tipoDeConsulta == 'juicio' && juicioId) {
                juicio {
                    eq('id', (juicioId as long))
                    if(usuario.tipoDeUsuario == "EXTERNO"){
                        eq('despacho',usuario.despacho)
                    } else if(usuario.tipoDeUsuario == "INTERNO" && !roles.contains("ROLE_ADMIN")){
                        eq('delegacion',usuario.delegacion)
                    }
                }
            }
        }
        return audiencias
    }
    
    def consultarAudienciasDiferidas(def audiencia){
        def audienciaReprogramada = AudienciaReprogramada.findWhere(audienciaOriginal: audiencia)
        return audienciaReprogramada?.nuevaAudiencia
    }
    
    def diferirAudiencia(def audienciaOriginal, def usuario, def params){
        def audienciaMap = [:]
        def nuevaAudiencia = audienciaOriginal.clonarAudiencia()
        def nuevaFecha = params.fechaAud + " " + params.hora
        nuevaAudiencia.id = null
        nuevaAudiencia.fechaDeAudiencia = new Date().parse('dd/MM/yyyy HH:mm',nuevaFecha)
        nuevaAudiencia.usuarioQueRegistro = usuario
        nuevaAudiencia.fechaDeRegistro = new Date()
        nuevaAudiencia.asistente = params.nombreAsistente
        nuevaAudiencia.acciones = null
        nuevaAudiencia.resultado = null
        nuevaAudiencia.motivoDeReprogramacion = null
        nuevaAudiencia.cancelada = false
        nuevaAudiencia.reprogramada = false
        if(nuevaAudiencia.save(flush:true)) {
            def audienciaReprogramada = new AudienciaReprogramada()
            audienciaReprogramada.audienciaOriginal = audienciaOriginal
            audienciaReprogramada.fechaDelCambio = new Date()
            audienciaReprogramada.nuevaAudiencia = nuevaAudiencia
            audienciaReprogramada.usuariosQueCambio = usuario
            if(audienciaReprogramada.save(flush:true)){
                audienciaMap.id = nuevaAudiencia.id
                audienciaMap.anterior = audienciaOriginal.id
                audienciaMap.title = nuevaAudiencia.juicio.expedienteInterno
                audienciaMap.start = nuevaAudiencia.fechaDeAudiencia
                audienciaMap.allDay = false
                audienciaMap.color = '#f8ac59'
            } else {
                audienciaMap.error = "Ocurrio un error al relacionar la nueva audiencia con la original."
            }
        } else {
            audienciaMap.error = "Ocurrio un error al registrar la fecha de la audiencia."
        }
        return audienciaMap
    }
    
    def actualizarAudiencia(def audienciaActualizada){
        return audienciaActualizada.save(flush: true)
    }
}
