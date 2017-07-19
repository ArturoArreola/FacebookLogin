package mx.gox.infonavit.sicj.juicios

import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class ReportesController {
    
    private static final Logger log = LogManager.getLogger(ReportesController)
    
    def reportesService
    def springSecurityService

    def index() {
        [usuario: springSecurityService.currentUser]
    }
    
    def generarReporteJuicioConError(){
        log.info "PARAMETROS PARA EL JUICIO CON ERROR -> "+  params
    }

    def generarReporte(){
        log.info params
        def file
        def nombreReporte
        def reporteSolicitado = params.reporteSolicitado as int
        def usuario = springSecurityService.currentUser
        def roles = springSecurityService.principal?.authorities*.authority
        if( (!roles.contains('ROLE_ADMIN')) && (roles.contains('ROLE_CONSULTA_JUICIO_LABORAL') || roles.contains('ROLE_CONSULTA_JUICIO_CIVIL') || roles.contains('ROLE_CONSULTA_JUICIO_PENAL'))){
            params.delegacion = usuario.delegacion
        }
        if(usuario.tipoDeUsuario == 'EXTERNO'){
            params.despacho = usuario.despacho
        }
        file = reportesService.generarReporte(params)
        if(reporteSolicitado == 0){
            nombreReporte = "reporte_" + params.fechaInicial + "-" + params.fechaFinal
        } else if(reporteSolicitado == 1){
            nombreReporte = "reporteGeneral_" + ((new Date()).format('dd-MM-yyyy'))
        } else if(reporteSolicitado == 2){
            nombreReporte = "reporteArchivoDefinitivo_" + ((new Date()).format('dd-MM-yyyy'))
        } else if(reporteSolicitado == 3){
            nombreReporte = "reporteCancelados_" + ((new Date()).format('dd-MM-yyyy'))
        } else if(reporteSolicitado == 4){
            nombreReporte = "reporteTransferenciaDelegacion_" + ((new Date()).format('dd-MM-yyyy'))
        } else if(reporteSolicitado == 5){
            nombreReporte = "reporteTransferenciaDespacho_" + ((new Date()).format('dd-MM-yyyy'))
        } else{
            nombreReporte = "reporte_" + ((new Date()).format('dd-MM-yyyy'))
        }
        if (file){
            response.setContentType("application/octet-stream")
            response.setHeader("Content-disposition", "attachment;filename=\"" + nombreReporte + ".xlsx\"")
            response.outputStream << file.bytes
        } else {
            flash.error = "No se encontraron registros correspondientes al criterio de búsqueda."
            redirect action: "index"
        }
    }
}
