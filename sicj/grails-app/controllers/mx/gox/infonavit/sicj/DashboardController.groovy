package mx.gox.infonavit.sicj

import grails.converters.JSON
import mx.gox.infonavit.sicj.admin.Aviso
import mx.gox.infonavit.sicj.catalogos.EstadoDeJuicio
import mx.gox.infonavit.sicj.catalogos.Materia
import mx.gox.infonavit.sicj.catalogos.Provision
import mx.gox.infonavit.sicj.juicios.AudienciaJuicio
import mx.gox.infonavit.sicj.juicios.ActorJuicio
import mx.gox.infonavit.sicj.juicios.TipoAsociadoJuicio
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class DashboardController {

    private static final Logger log = LogManager.getLogger(DashboardController)
    def reportesService
    def springSecurityService
    def audienciaJuicioService
    
    def index() { 
        def meses = ['ENERO','FEBRERO','MARZO','ABRIL','MAYO','JUNIO','JULIO','AGOSTO','SEPTIEMBRE','OCTUBRE','NOVIEMBRE','DICIEMBRE']
        def mesActual = meses.getAt((new Date())[Calendar.MONTH])
        def usuario = springSecurityService.currentUser
        def asuntosDadosDeBaja = asuntosDadosDeBajaEnElMes()
        def asuntosDadosDeAlta = asuntosDadosDeAltaEnElMes()
        def avisos = Aviso.findAllWhere(activo: true)
        avisos = avisos.sort { it.fechaDePublicacion }
        [asuntosDadosDeBaja: asuntosDadosDeBaja, asuntosDadosDeAlta: asuntosDadosDeAlta, mesActual: mesActual, avisos: avisos]
    }
    
    def asuntosDadosDeBajaEnElMes() {
        log.info params
        def x = 0
        def estadistica = []
        def materias = Materia.list(sort:'id') 
        def usuario = springSecurityService.currentUser
        materias.each {
            def categoria = [:]
            categoria.materia = it
            categoria.cantidad = reportesService.asuntosTerminadosEnElMes(usuario, it)
            estadistica << categoria
        }
        log.info estadistica
        return estadistica
    }
    
    def asuntosDadosDeAltaEnElMes() {
        log.info params
        def x= 0
        def estadistica = []
        def materias = Materia.list(sort:'id')
        def usuario = springSecurityService.currentUser
        materias.each {
            def categoria = [:]
            categoria.materia = it
            categoria.cantidad = reportesService.asuntosRegistradosEnElMes(usuario, it)
            estadistica << categoria
        }
        log.info estadistica
        return estadistica
    }
    
    def getAsuntosActuales() {
        log.info params
        def x = 0
        def series = []
        def colores = ["#fa9d4b","#1ab394","#d54545","#bf00ff","#45c6d5","#848484"]
        //def colores = ["#45c6d5","#1ab394","#79d2c0","#fa9d4b","#d54545","#bf00ff","#848484"]
        def materia = Materia.get(params.materia as long)
        def estadosDeJuicio = EstadoDeJuicio.list(sort:'id')
        estadosDeJuicio.each {
            series << reportesService.estadisticasPorStatus(it, materia, colores[x])
            x++
        }
        render series as JSON
    }
    
    def getAsuntosContingencia() {
        log.info params
        def x = 0
        def series = []
        def colores = ["#d54545","#1ab394","#fad11e"]
        def materia = Materia.get(params.materia as long)
        def provision = Provision.list(sort:'id')
        provision.each {
            series << reportesService.estadisticasPorProvision(it, materia, colores[x])
            x++
        }
        render series as JSON
    }
    
    def getAudiencias(){
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
            audiencia.id = it.id
            audiencia.title = it.juicio.expedienteInterno
            audiencia.start = it.fechaDeAudiencia
            audiencia.allDay = false
            if(it.acciones && it.resultado){
                audiencia.color = '#1ab394'
            } else {
                audiencia.color = '#f8ac59'
            }
            datos << audiencia
        }
        render datos as JSON
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
    
    def obtenerJuiciosContingentes(){
        log.info params
        def materia = Materia.get(params.materiaId as long)
        def usuario = springSecurityService.currentUser
        def juiciosContingentes = reportesService.obtenerJuiciosContingentes(materia, usuario)
        render(template: "/templates/juiciosContingentes", model: [juiciosContingentes: juiciosContingentes])
    }
}
