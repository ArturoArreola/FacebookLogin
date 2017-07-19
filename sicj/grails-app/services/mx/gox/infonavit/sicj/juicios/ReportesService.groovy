package mx.gox.infonavit.sicj.juicios

import grails.transaction.Transactional
import mx.gox.infonavit.sicj.catalogos.Provision
import mx.gox.infonavit.sicj.catalogos.EstadoDeJuicio
import mx.gox.infonavit.sicj.catalogos.Materia
import mx.gox.infonavit.sicj.juicios.ControlJuicio
import grails.plugins.csv.CSVWriter
import mx.gox.infonavit.sicj.admin.Delegacion
import mx.gox.infonavit.sicj.admin.Despacho
import maxmoto1702.excel.ExcelBuilder
//import com.jameskleeh.excel.Font
//import org.apache.poi.xssf.usermodel.XSSFWorkbook
//import org.apache.poi.xssf.streaming.SXSSFWorkbook
import org.apache.poi.ss.usermodel.CellStyle
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext
import groovy.sql.Sql

@Transactional
class ReportesService {
    
    private static final Logger log = LogManager.getLogger(ReportesService)
    
    def springSecurityService
    def dataSource

    def estadisticasPorStatus(def statusDeJuicio, def materia, def color) {
        def juicios = 0
        def datos = [:]
        def usuario = springSecurityService.currentUser
        def consulta = Juicio.createCriteria()
        if(usuario.tipoDeUsuario == "EXTERNO"){
            juicios = consulta.get {
                eq("estadoDeJuicio",statusDeJuicio)
                eq("despacho",usuario.despacho)
                eq("materia",materia)
                projections {
                    countDistinct "id"
                }
            }
        } else if(usuario.tipoDeUsuario == "INTERNO"){
            juicios = consulta.get {
                eq("estadoDeJuicio",statusDeJuicio)
                if(usuario.delegacion.id > 0) {
                    eq("delegacion",usuario.delegacion)
                }
                eq("materia",materia)
                projections {
                    countDistinct "id"
                }
            }
        }
        datos.data = juicios
        datos.label = statusDeJuicio.nombre
        datos.color = color
        return datos
    }
    
    def estadisticasPorProvision(def provision, def materia, def color) {
        def juicios = 0
        def datos = [:]
        def usuario = springSecurityService.currentUser
        def consulta = Juicio.createCriteria()
        if(usuario.tipoDeUsuario == "EXTERNO"){
            juicios = consulta.get {
                'in'("estadoDeJuicio",[EstadoDeJuicio.get(1),EstadoDeJuicio.get(2),EstadoDeJuicio.get(5)])
                eq("provision",provision)
                eq("despacho",usuario.despacho)
                eq("materia",materia)
                projections {
                    countDistinct "id"
                }
            }
        } else if(usuario.tipoDeUsuario == "INTERNO"){
            juicios = consulta.get {
                'in'("estadoDeJuicio",[EstadoDeJuicio.get(1),EstadoDeJuicio.get(2),EstadoDeJuicio.get(5)])
                eq("provision",provision)
                if(usuario.delegacion.id > 0) {
                    eq("delegacion",usuario.delegacion)
                }
                eq("materia",materia)
                projections {
                    countDistinct "id"
                }
            }
        }
        datos.data = juicios
        datos.label = provision.nombre
        datos.color = color
        return datos
    }
    
    def asuntosTerminadosEnElMes(def usuario, def materia){
        def juicios = 0
        def mesActual = getDateRange()
        def consulta = ControlJuicio.createCriteria()
        if(usuario.tipoDeUsuario == "EXTERNO"){
            juicios = consulta.get {
                juicio{
                    eq("estadoDeJuicio",EstadoDeJuicio.get(6))
                    eq("despacho",usuario.despacho)
                    eq("materia",materia)
                }
                between("fechaDeArchivoDefinitivo",mesActual.fechaInicio, mesActual.fechaFinal)
                projections {
                    countDistinct "juicio"
                }
            }
        } else if(usuario.tipoDeUsuario == "INTERNO"){
            juicios = consulta.get {
                juicio{
                    eq("estadoDeJuicio",EstadoDeJuicio.get(6))
                    if(usuario.delegacion.id > 0) {
                        eq("delegacion",usuario.delegacion)
                    }
                    eq("materia",materia)
                }
                between("fechaDeArchivoDefinitivo",mesActual.fechaInicio, mesActual.fechaFinal)
                projections {
                    countDistinct "juicio"
                }
            }
        }
        return juicios
    }
    
    def asuntosRegistradosEnElMes(def usuario, def materia){
        def juicios = 0
        def mesActual = getDateRange()
        def consulta = Juicio.createCriteria()
        if(usuario.tipoDeUsuario == "EXTERNO"){
            juicios = consulta.get {
                eq("despacho",usuario.despacho)
                eq("materia",materia)
                between("fechaDeCreacion",mesActual.fechaInicio, mesActual.fechaFinal)
                projections {
                    countDistinct "id"
                }
            }
        } else if(usuario.tipoDeUsuario == "INTERNO"){
            juicios = consulta.get {
                if(usuario.delegacion.id > 0) {
                    eq("delegacion",usuario.delegacion)
                }
                eq("materia",materia)
                between("fechaDeCreacion",mesActual.fechaInicio, mesActual.fechaFinal)
                projections {
                    countDistinct "id"
                }
            }
        }
        return juicios
    }
    
    def obtenerJuiciosContingentes(def materia, def usuario){
        def contingencia = Provision.get(1)
        def juicios
        if(usuario.tipoDeUsuario == "EXTERNO"){
            juicios = Juicio.findAll("from Juicio j Where j.estadoDeJuicio.id in (1,2,5) And j.provision.id = :provision And j.materia.id = :materia And j.despacho.id = :despacho Order by j.fechaDeCreacion", [provision: contingencia.id, materia: materia.id, despacho: usuario.despacho?.id])
        } else if(usuario.tipoDeUsuario == "INTERNO"){
            if(usuario.delegacion.id > 0) {
                juicios = Juicio.findAll("from Juicio j Where j.estadoDeJuicio.id in (1,2,5) And j.provision.id = :provision And j.materia.id = :materia And j.delegacion.id = :delegacion Order by j.fechaDeCreacion", [provision: contingencia.id, materia: materia.id, delegacion: usuario.delegacion?.id])
            } else {
                juicios = Juicio.findAll("from Juicio j Where j.estadoDeJuicio.id in (1,2,5) And j.provision.id = :provision And j.materia.id = :materia Order by j.fechaDeCreacion", [provision: contingencia.id, materia: materia.id])
            }
        }
        return juicios
    }
    
    def getDateRange() {
        def rango = [:];
        Calendar calendar = getCalendarForNow();
        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
        setTimeToBeginningOfDay(calendar);
        rango.fechaInicio = calendar.getTime();
        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
        setTimeToEndofDay(calendar);
        rango.fechaFinal = calendar.getTime();
        log.info rango
        return rango;
    }

    private static Calendar getCalendarForNow() {
        Calendar calendar = GregorianCalendar.getInstance();
        calendar.setTime(new Date());
        return calendar;
    }

    private static void setTimeToBeginningOfDay(Calendar calendar) {
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
    }

    private static void setTimeToEndofDay(Calendar calendar) {
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
    }
    
    def generarReporte(def params){
        def reporteSolicitado = params.reporteSolicitado as int
        def nssSeparado = ((params.nssSeparado == "true") ? true : false)
        def materia = params.materia.id as long
        def delegacion = params.delegacion.id as long
        def despacho = (params.despacho?.id ? params.despacho.id as long : null)
        def reporte = []
        def archivoDelReporte
        def juicios
        final Sql sql = new Sql(dataSource)
        def query
        if(nssSeparado){
            query = "SELECT * from reporte_juicios_nss_separado r WHERE r.id_juicio > 0 "
        } else {
            query = "SELECT * from reporte_juicios r WHERE r.id_juicio > 0 "
        }
        if(materia && materia > 0){
            query += "AND r.materia_id = " + materia + " "
        } else if (materia && materia == 0){
            query += "AND r.materia_id not in (4) "
        }
        if(delegacion && delegacion > 0){
            query += "AND r.delegacion_id = " + delegacion + " "
        }
        if(despacho && despacho > 0){
            query += "AND r.despacho_id = " + despacho + " "
        }
        switch (reporteSolicitado) {
        case 0: //Reporte Personalizado
            //query += "AND j.fechaDeCreacion between to_timestamp('" + params.fechaInicial + " 00:00','dd/mm/yyyy hh24:mi') and to_timestamp('" + params.fechaFinal + " 23:59','dd/mm/yyyy hh24:mi') "
            query += "AND r.fecha_de_creacion between convert(datetime, '" + params.fechaInicial + " 00:00',103) and convert(datetime, '" + params.fechaFinal + " 23:59',103) "
            if(params.ambito?.id){
                query += "AND r.ambito_id = " + params.ambito.id + " "
            }
            if(params.etapaProcesal?.id){
                query += "AND r.etapa_procesal_id = " + params.etapaProcesal.id + " "
            }
            if(params.tipoDeProcedimiento?.id){
                query += "AND r.tipo_de_procedimiento_id = " + params.tipoDeProcedimiento.id + " "
            }
            if(params.estadoDeJuicio?.id){
                query += "AND r.estado_de_juicio_id = " + params.estadoDeJuicio.id
            }
            reporte = sql.rows(query)
            break
        case 1://Reporte General
            query += "AND r.estado_de_juicio_id in (1, 2, 5) Order by r.fecha_de_creacion"
            reporte = sql.rows(query)
            break
        case 2://Reporte Juicios en Archivo Definitivo
            query += "AND r.estado_de_juicio_id = 6 Order by r.fecha_de_creacion"
            reporte = sql.rows(query)
            break
        case 3://Reporte Juicios Cancelados
            query += "AND r.estado_de_juicio_id = 4 Order by r.fecha_de_creacion"
            reporte = sql.rows(query)
            break
        case 4://Transferencia Delegación/Despacho
            query += "AND r.estado_de_juicio_id in (1, 2, 4, 5) Order by r.fecha_de_creacion"
            reporte = sql.rows(query)
            break
        case 5://Transferencia Despacho/Despacho
            query += "AND r.estado_de_juicio_id in (1, 2, 4, 5) Order by r.fecha_de_creacion"
            reporte = sql.rows(query)
            break
        default://Ningun reporte indicado
            break
        }
        /*if(reporteSolicitado == 0 || reporteSolicitado == 1 || reporteSolicitado == 2 || reporteSolicitado == 3) {
        juicios?.each { juicio ->
        def fila = [:]
        fila.juicio = juicio
        if(nssSeparado) {
        fila.actores = []
        } else{
        fila.actores = ""
        }
        fila.demandados = ""
        fila.terceros = ""
        fila.denunciantes = ""
        fila.probablesResponsables = ""
        fila.controlJuicio = ControlJuicio.findWhere(juicio:juicio)
        def actores = ActorJuicio.findAllWhere(juicio: juicio)
        actores?.each { actor ->
        if(actor.tipoDeParte.id == 5) { //Actores
        if(nssSeparado) {
        fila.actores << actor
        } else {
        fila.actores += "" + actor.persona.toString() + " (NSS: " + actor.persona.numeroSeguroSocial + " , RFC: " + actor.persona.rfc + "), " 
        }
        } else if(actor.tipoDeParte.id == 2) { //Demandados
        fila.demandados += "" + actor.persona.toString() + ", "
        } else if(actor.tipoDeParte.id == 3) { //Terceros
        fila.terceros += "" + actor.persona.toString() + ", "
        } else if(actor.tipoDeParte.id == 6) { //Denunciantes
        fila.denunciantes += "" + actor.persona.toString() + ", "
        } else if(actor.tipoDeParte.id == 7) { //Probables Responsables
        fila.probablesResponsables += "" + actor.persona.toString() + ", "
        }
        }
        fila.nota = NotaJuicio.find("from NotaJuicio n Where n.juicio.id=:idJuicio order by n.fechaDeNota desc", [idJuicio: juicio.id])
        def tiposAsociados = TipoAsociadoJuicio.findAllWhere(juicio: juicio)
        fila.prestacionReclamada = (tiposAsociados ? ((tiposAsociados*.tipoAsociado)*.prestacionReclamada as Set)[0] : null)
        fila.tiposAsociados = ""
        tiposAsociados?.each { tipoAsociado ->
        fila.tiposAsociados += "" + tipoAsociado.tipoAsociado.nombre + ", "
        }
        fila.numeroDeCredito = CreditoJuicio.findWhere(juicio: juicio)
        def inmueble = UbicacionDelInmuebleJuicio.findWhere(juicio: juicio)
        fila.inmueble =  (inmueble ? (inmueble.direccionCompleta ?: (inmueble.calle + " Núm. Ext. " + inmueble.numeroExterior + " Núm. Int. " + inmueble.numeroInterior + ", " + inmueble.colonia + ", " + inmueble.municipio + ", " + inmueble.estado + ", C.P. " + inmueble.codigoPostal)) : null)
        fila.procesoAlterno = ProcesoAlternoJuicio.findWhere(juicio: juicio)
        fila.archivos = ArchivoJuicio.countByJuicio(juicio)
        fila.pagos = [:]
        def pagos = PagoJuicioRezago.findAllWhere(juicio: juicio)
        pagos = pagos?.sort{ it.numeroDePago }
        pagos?.each {
        fila.pagos."fechaPago$it.numeroDePago" = it.fechaDelPago
        fila.pagos."montoPago$it.numeroDePago" = it.montoDelPago
        }
        reporte << fila
        }
        }*/
        log.info "NSS Separado? " + nssSeparado
        println "Cantidad de Filas obtenidas - Reporte SICJ: " + reporte?.size()
        archivoDelReporte = getReporteXLSX(reporte, materia, nssSeparado)
        reporte = null
        sql?.close()
        archivoDelReporte
    }
    
    def getReporteCSV(def reporte, def materia, def nssSeparado){
        if(reporte) {
            def sw = new StringWriter()
            def b
            if(materia == 0){
                b = new CSVWriter(sw, {
                        col1: "idAsunto" { it.val1 }
                        col2: "Zona" { it.val2 }
                        col3: "Materia" { it.val3 }
                        col4: "Id Delegacion" { it.val4 }
                        col5: "Delegacion" { it.val5 }
                        col6: "Num. Exp. Interno" { it.val6 }
                        col7: "Exp. Juicio" { it.val7 }
                        col8: "Tipo de Juicio" { it.val8 }
                        col9: "Estatus" { it.val9 }
                        col10: "Etapa Procesal" { it.val10 }
                        col11: "Actor" { it.val11 }
                        col12: "Demandado" { it.val12 }
                        col13: "Tercero Interesado" { it.val13 }
                        col14: "Denunciante" { it.val14 }
                        col15: "Probable Responsable" { it.val15 }
                        col16: "Despacho" { it.val16 }
                        col17: "Notas" { it.val17 }
                        col18: "Fecha Nota" { it.val18 }
                        col19: "No. Credito" { it.val19 }
                        col20: "Prestacion Reclamada" { it.val20 }
                        col21: "Tipos Asociados" { it.val21 }
                        col22: "Ambito" { it.val22 }
                        col23: "Municipio" { it.val23 }
                        col24: "Autoridad" { it.val24 }
                        col25: "Juzgado" { it.val25 }
                        col26: "Tipo de Parte" { it.val26 }
                        col27: "Patrocinador" { it.val27 }
                        col28: "Provision" { it.val28 }
                        col29: "Inmueble" { it.val29 }
                        col30: "Nombre del Finado" { it.val30 }
                        col31: "NSS del Finado" { it.val31 }
                        col32: "Tipo de Proceso Alterno" { it.val32 }
                        col33: "Numero de Exp. Alterno o Toca" { it.val33 }
                        col34: "Resolución" { it.val34 }
                        col35: "Estatus Actual del Proceso Alterno" { it.val35 }
                        col36: "Fecha de Alta" { it.val36 }
                        col37: "Fecha de Envio al Despacho" { it.val37 }
                        col38: "Fecha de Modificacion" { it.val38 }
                        col39: "Fecha de Reactivacion" { it.val39 }
                        col40: "Fecha de Cancelado por Error" { it.val40 }
                        col41: "Fecha de WF Completado" { it.val41 }
                        col42: "Fecha de Termino" { it.val42 }
                        col43: "Fecha de Archivo Definitivo" { it.val43 }
                        col44: "Fecha de Historico" { it.val44 }
                        col45: "Motivo de Termino" { it.val45 }
                        col46: "Cantidad Demandada" { it.val46 }
                        col47: "Cantidad Pagada" { it.val47 }
                        col48: "Juicio Pagado" { it.val48 }
                        col49: "Forma de Pago" { it.val49 }
                        col50: "Elaborado Por" { it.val50 }
                        col51: "Modificado Por" { it.val51 }
                        col52: "Reactivado por" { it.val52 }
                        col53: "Cancelado Por" { it.val53 }
                        col54: "WF Completado Por" { it.val54 }
                        col55: "Terminado Por" { it.val55 }
                        col56: "Archivado Por" { it.val56 }  
                        col57: "Enviado a Historico Por" { it.val57 }  
                        col58: "Gerente Juridico" { it.val58 }
                        col59: "Responsable del Juicio" { it.val59 }
                        col60: "Responsable del Despacho" { it.val60 }
                        col61: "Usuario que modifico la nota" { it.val61 }
                        col62: "Contiene archivos adjuntos" { it.val62 }
                        col63: "Region" { it.val63 }
                        col64: "idDespacho" { it.val64 }
                        col65: "¿En Donde esta Radicado el Juicio?" { it.val65 }
                    
                    })
                reporte.each { fila ->
                    def valores = [:]
                    valores.val1 = fila.juicio.id
                    valores.val2 = fila.juicio.delegacion.division
                    valores.val3 = fila.juicio.materia
                    valores.val4 = fila.juicio.delegacion.id
                    valores.val5 = fila.juicio.delegacion.nombre
                    valores.val6 = fila.juicio.expedienteInterno
                    valores.val7 = fila.juicio.expediente
                    valores.val8 = fila.juicio.tipoDeProcedimiento
                    valores.val9 = fila.juicio.estadoDeJuicio
                    valores.val10 = (fila.juicio.etapaProcesal ? fila.juicio.etapaProcesal : "WF SIN CONTESTAR")
                    valores.val11 = fila.actores
                    valores.val12 = fila.demandados
                    valores.val13 = (fila.terceros ? fila.terceros : "")
                    valores.val14 = fila.denunciantes
                    valores.val15 = fila.probablesResponsables
                    valores.val16 = fila.juicio.despacho
                    valores.val17 = (fila.nota?.nota ? fila.nota?.nota : "")
                    valores.val18 = (fila.nota?.fechaDeNota ? fila.nota?.fechaDeNota.format('dd/MM/yyyy') : "")
                    valores.val19 = (fila.numeroDeCredito?.numeroDeCredito ? fila.numeroDeCredito?.numeroDeCredito : "")
                    valores.val20 = (fila.prestacionReclamada ? fila.prestacionReclamada : "")
                    valores.val21 = fila.tiposAsociados
                    valores.val22 = fila.juicio.ambito
                    valores.val23 = (fila.juicio.municipioAutoridad ? fila.juicio.municipioAutoridad : "")
                    valores.val24 = (fila.juicio.autoridad ? fila.juicio.autoridad : "")
                    valores.val25 = (fila.juicio.autoridad?.tipoDeAutoridad? fila.juicio.autoridad?.tipoDeAutoridad :"")
                    valores.val26 = fila.juicio.tipoDeParte
                    valores.val27 = (fila.juicio.patrocinadoDelJuicio ? fila.juicio.patrocinadoDelJuicio : "")
                    valores.val28 = fila.juicio.provision
                    valores.val29 = (fila.inmueble ? fila.inmueble : "")
                    valores.val30 = (fila.juicio.nombreDelFinado ? fila.juicio.nombreDelFinado : "")
                    valores.val31 = (fila.juicio.numeroSeguroSocialDelFinado ? fila.juicio.numeroSeguroSocialDelFinado : "")
                    valores.val32 = (fila.procesoAlterno?.tipoDeProcesoAlterno ? fila.procesoAlterno?.tipoDeProcesoAlterno : "")
                    valores.val33 = (fila.procesoAlterno?.expediente ? fila.procesoAlterno?.expediente : "")
                    valores.val34 = (fila.procesoAlterno?.notasFinales ? fila.procesoAlterno?.notasFinales : "")
                    valores.val35 = (fila.procesoAlterno?.estadoDeProceso ? fila.procesoAlterno?.estadoDeProceso : "")
                    valores.val36 = fila.juicio.fechaDeCreacion.format('dd/MM/yyyy')
                    valores.val37 = fila.juicio.fechaRD.format('dd/MM/yyyy')
                    valores.val38 = (fila.juicio.ultimaModificacion ? fila.juicio.ultimaModificacion.format('dd/MM/yyyy') : "")
                    valores.val39 = (fila.controlJuicio?.fechaDeReactivacion ? fila.controlJuicio?.fechaDeReactivacion.format('dd/MM/yyyy') : "")
                    valores.val40 = (fila.controlJuicio?.fechaDeCancelacion ? fila.controlJuicio?.fechaDeCancelacion.format('dd/MM/yyyy') : "")
                    valores.val41 = (fila.controlJuicio?.fechaDeWfTerminado ? fila.controlJuicio?.fechaDeWfTerminado.format('dd/MM/yyyy') : "")
                    valores.val42 = (fila.juicio.fechaDeTermino ? fila.juicio.fechaDeTermino.format('dd/MM/yyyy') : "")
                    valores.val43 = (fila.controlJuicio?.fechaDeArchivoDefinitivo ? fila.controlJuicio?.fechaDeArchivoDefinitivo.format('dd/MM/yyyy') : "")
                    valores.val44 = (fila.controlJuicio?.fechaDeArchivoHistorico ? fila.controlJuicio?.fechaDeArchivoHistorico.format('dd/MM/yyyy') : "")
                    valores.val45 = (fila.juicio.motivoDeTermino ? fila.juicio.motivoDeTermino : "")
                    valores.val46 = (fila.juicio.monto ? fila.juicio.monto : "")
                    valores.val47 = (fila.juicio.cantidadPagada ? fila.juicio.cantidadPagada : "")
                    valores.val48 = (fila.juicio.juicioPagado ? "SI" : "NO")
                    valores.val49 = (fila.juicio.formaDePago ? fila.juicio.formaDePago : "")
                    valores.val50 = fila.juicio.creadorDelCaso
                    valores.val51 = (fila.juicio.personaQueModifico ? fila.juicio.personaQueModifico : "")
                    valores.val52 = (fila.controlJuicio?.reactivadoPor ? fila.controlJuicio?.reactivadoPor : "")
                    valores.val53 = (fila.controlJuicio?.canceladoPor ? fila.controlJuicio?.canceladoPor : "")
                    valores.val54 = (fila.controlJuicio?.wfTerminadoPor ? fila.controlJuicio?.wfTerminadoPor : "")
                    valores.val55 = (fila.juicio.terminadoPor ? fila.juicio.terminadoPor : "")
                    valores.val56 = (fila.controlJuicio?.archivadoPor ? fila.controlJuicio?.archivadoPor : "")
                    valores.val57 = (fila.controlJuicio?.enviadoHistoricoPor ? fila.controlJuicio?.enviadoHistoricoPor : "")
                    valores.val58 = (Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) ? Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) : "")
                    valores.val59 = (fila.juicio.responsableDelJuicio ? fila.juicio.responsableDelJuicio : "" )
                    valores.val60 = ((fila.juicio.despacho?.id > 0) ? (Despacho.getResponsable(fila.juicio.despacho.id) ?: "") : "")
                    valores.val61 = (fila.nota?.usuario ? fila.nota?.usuario : "")
                    valores.val62 = (fila.archivos > 0 ? "SI" : "NO")
                    valores.val63 = (fila.juicio.region ? fila.juicio.region.nombre : "")
                    valores.val64 = ((fila.juicio.despacho?.id > 0) ? fila.juicio.despacho?.id : "")
                    valores.val65 = ((fila.juicio.radicacionDelJuicio) ? fila.juicio.radicacionDelJuicio.nombre : "")
                    b << valores
                }
            } else if(materia == 1 || materia == 2){
                if(nssSeparado){
                    b = new CSVWriter(sw, {
                            col1: "idAsunto" { it.val1 }
                            col2: "Zona" { it.val2 }
                            col3: "Materia" { it.val3 }
                            col4: "Id Delegacion" { it.val4 }
                            col5: "Delegacion" { it.val5 }
                            col6: "Num. Exp. Interno" { it.val6 }
                            col7: "Exp. Juicio" { it.val7 }
                            col8: "Tipo de Juicio" { it.val8 }
                            col9: "Estatus" { it.val9 }
                            col10: "Etapa Procesal" { it.val10 }
                            col11: "Actor" { it.val11 }
                            col12: "NSS" { it.val12 }
                            col13: "Demandado" { it.val13 }
                            col14: "Tercero Interesado" { it.val14 }
                            col15: "Despacho" { it.val15 }
                            col16: "Notas" { it.val16 }
                            col17: "Fecha Nota" { it.val17 }
                            col18: "No. Credito" { it.val18 }
                            col19: "Prestacion Reclamada" { it.val19 }
                            col20: "Tipos Asociados" { it.val20 }
                            col21: "Ambito" { it.val21 }
                            col22: "Municipio" { it.val22 }
                            col23: "Autoridad" { it.val23 }
                            col24: "Juzgado" { it.val24 }
                            col25: "Tipo de Parte" { it.val25 }
                            col26: "Patrocinador" { it.val26 }
                            col27: "Provision" { it.val27 }
                            col28: "Inmueble" { it.val28 }
                            col29: "Nombre del Finado" { it.val29 }
                            col30: "NSS del Finado" { it.val30 }
                            col31: "Tipo de Proceso Alterno" { it.val31 }
                            col32: "Numero de Exp. Alterno o Toca" { it.val32 }
                            col33: "Resolución" { it.val33 }
                            col34: "Estatus Actual del Proceso Alterno" { it.val34 }
                            col35: "Fecha de Alta" { it.val35 }
                            col36: "Fecha de Envio al Despacho" { it.val36 }
                            col37: "Fecha de Modificacion" { it.val37 }
                            col38: "Fecha de Reactivacion" { it.val38 }
                            col39: "Fecha de Cancelado por Error" { it.val39 }
                            col40: "Fecha de WF Completado" { it.val340 }
                            col41: "Fecha de Termino" { it.val41 }
                            col42: "Fecha de Archivo Definitivo" { it.val42 }
                            col43: "Fecha de Historico" { it.val43 }
                            col44: "Motivo de Termino" { it.val44 }
                            col45: "Cantidad Demandada" { it.val45 }
                            col46: "Cantidad Pagada" { it.val46 }
                            col47: "Juicio Pagado" { it.val47 }
                            col48: "Forma de Pago" { it.val48 }
                            col49: "Elaborado Por" { it.val49 }
                            col50: "Modificado Por" { it.val50 }
                            col51: "Reactivado por" { it.val51 }
                            col52: "Cancelado Por" { it.val52 }
                            col53: "WF Completado Por" { it.val53 }
                            col54: "Terminado Por" { it.val54 }
                            col55: "Archivado Por" { it.val55 }  
                            col56: "Enviado a Historico Por" { it.val56 }  
                            col57: "Gerente Juridico" { it.val57 }
                            col58: "Responsable del Juicio" { it.val58 }
                            col59: "Responsable del Despacho" { it.val59 }
                            col60: "Usuario que modifico la nota" { it.val60 }
                            col61: "Contiene archivos adjuntos" { it.val61 }
                            col62: "Region" { it.val62 }
                            col63: "idDespacho" { it.val63 }
                            col64: "¿En Donde esta Radicado el Juicio?" { it.val64 }
                        })
                } else {
                    b = new CSVWriter(sw, {
                            col1: "idAsunto" { it.val1 }
                            col2: "Zona" { it.val2 }
                            col3: "Materia" { it.val3 }
                            col4: "Id Delegacion" { it.val4 }
                            col5: "Delegacion" { it.val5 }
                            col6: "Num. Exp. Interno" { it.val6 }
                            col7: "Exp. Juicio" { it.val7 }
                            col8: "Tipo de Juicio" { it.val8 }
                            col9: "Estatus" { it.val9 }
                            col10: "Etapa Procesal" { it.val10 }
                            col11: "Actor" { it.val11 }
                            col12: "Demandado" { it.val12 }
                            col13: "Tercero Interesado" { it.val13 }
                            col14: "Despacho" { it.val14 }
                            col15: "Notas" { it.val15 }
                            col16: "Fecha Nota" { it.val16 }
                            col17: "No. Credito" { it.val17 }
                            col18: "Prestacion Reclamada" { it.val18 }
                            col19: "Tipos Asociados" { it.val19 }
                            col20: "Ambito" { it.val20 }
                            col21: "Municipio" { it.val21 }
                            col22: "Autoridad" { it.val22 }
                            col23: "Juzgado" { it.val23 }
                            col24: "Tipo de Parte" { it.val24 }
                            col25: "Patrocinador" { it.val25 }
                            col26: "Provision" { it.val26 }
                            col27: "Inmueble" { it.val27 }
                            col28: "Nombre del Finado" { it.val28 }
                            col29: "NSS del Finado" { it.val29 }
                            col30: "Tipo de Proceso Alterno" { it.val30 }
                            col31: "Numero de Exp. Alterno o Toca" { it.val31 }
                            col32: "Resolución" { it.val32 }
                            col33: "Estatus Actual del Proceso Alterno" { it.val33 }
                            col34: "Fecha de Alta" { it.val34 }
                            col35: "Fecha de Envio al Despacho" { it.val35 }
                            col36: "Fecha de Modificacion" { it.val36 }
                            col37: "Fecha de Reactivacion" { it.val37 }
                            col38: "Fecha de Cancelado por Error" { it.val38 }
                            col39: "Fecha de WF Completado" { it.val39 }
                            col40: "Fecha de Termino" { it.val40 }
                            col41: "Fecha de Archivo Definitivo" { it.val41 }
                            col42: "Fecha de Historico" { it.val42 }
                            col43: "Motivo de Termino" { it.val43 }
                            col44: "Cantidad Demandada" { it.val44 }
                            col45: "Cantidad Pagada" { it.val45 }
                            col46: "Juicio Pagado" { it.val46 }
                            col47: "Forma de Pago" { it.val47 }
                            col48: "Elaborado Por" { it.val48 }
                            col49: "Modificado Por" { it.val49 }
                            col50: "Reactivado por" { it.val50 }
                            col51: "Cancelado Por" { it.val51 }
                            col52: "WF Completado Por" { it.val52 }
                            col53: "Terminado Por" { it.val53 }
                            col54: "Archivado Por" { it.val54 }  
                            col55: "Enviado a Historico Por" { it.val55 }  
                            col56: "Gerente Juridico" { it.val56 }
                            col57: "Responsable del Juicio" { it.val57 }
                            col58: "Responsable del Despacho" { it.val58 }
                            col59: "Usuario que modifico la nota" { it.val59 }
                            col60: "Contiene archivos adjuntos" { it.val60 }
                            col61: "Region" { it.val61 }
                            col62: "idDespacho" { it.val62 }
                            col63: "¿En Donde esta Radicado el Juicio?" { it.val63 }
                        })
                }
                if(nssSeparado){
                    reporte.each { fila ->
                        if(fila.actores){
                            fila.actores.each{ actor ->
                                def valores = [:]
                                valores.val1 = fila.juicio.id
                                valores.val2 = fila.juicio.delegacion.division
                                valores.val3 = fila.juicio.materia
                                valores.val4 = fila.juicio.delegacion.id
                                valores.val5 = fila.juicio.delegacion.nombre
                                valores.val6 = fila.juicio.expedienteInterno
                                valores.val7 = fila.juicio.expediente
                                valores.val8 = fila.juicio.tipoDeProcedimiento
                                valores.val9 = fila.juicio.estadoDeJuicio
                                valores.val10 = (fila.juicio.etapaProcesal ? fila.juicio.etapaProcesal : "WF SIN CONTESTAR")
                                valores.val11 = actor.persona.toString()
                                valores.val12 = (actor.persona.numeroSeguroSocial ?: "")
                                valores.val13 = fila.demandados
                                valores.val14 = (fila.terceros ? fila.terceros : "")
                                valores.val15 = fila.juicio.despacho
                                valores.val16 = (fila.nota?.nota ? fila.nota?.nota : "")
                                valores.val17 = (fila.nota?.fechaDeNota ? fila.nota?.fechaDeNota.format('dd/MM/yyyy') : "")
                                valores.val18 = (fila.numeroDeCredito?.numeroDeCredito ? fila.numeroDeCredito?.numeroDeCredito : "")
                                valores.val19 = (fila.prestacionReclamada ? fila.prestacionReclamada : "")
                                valores.val20 = fila.tiposAsociados
                                valores.val21 = fila.juicio.ambito
                                valores.val22 = (fila.juicio.municipioAutoridad ? fila.juicio.municipioAutoridad : "")
                                valores.val23 = (fila.juicio.autoridad ? fila.juicio.autoridad : "")
                                valores.val24 = (fila.juicio.autoridad?.tipoDeAutoridad? fila.juicio.autoridad?.tipoDeAutoridad :"")
                                valores.val25 = fila.juicio.tipoDeParte
                                valores.val26 = (fila.juicio.patrocinadoDelJuicio ? fila.juicio.patrocinadoDelJuicio : "")
                                valores.val27 = fila.juicio.provision
                                valores.val28 = (fila.inmueble ? fila.inmueble : "")
                                valores.val29 = (fila.juicio.nombreDelFinado ? fila.juicio.nombreDelFinado : "")
                                valores.val30 = (fila.juicio.numeroSeguroSocialDelFinado ? fila.juicio.numeroSeguroSocialDelFinado : "")
                                valores.val31 = (fila.procesoAlterno?.tipoDeProcesoAlterno ? fila.procesoAlterno?.tipoDeProcesoAlterno : "")
                                valores.val32 = (fila.procesoAlterno?.expediente ? fila.procesoAlterno?.expediente : "")
                                valores.val33 = (fila.procesoAlterno?.notasFinales ? fila.procesoAlterno?.notasFinales : "")
                                valores.val34 = (fila.procesoAlterno?.estadoDeProceso ? fila.procesoAlterno?.estadoDeProceso : "")
                                valores.val35 = fila.juicio.fechaDeCreacion.format('dd/MM/yyyy')
                                valores.val36 = fila.juicio.fechaRD.format('dd/MM/yyyy')
                                valores.val37 = (fila.juicio.ultimaModificacion ? fila.juicio.ultimaModificacion.format('dd/MM/yyyy') : "")
                                valores.val38 = (fila.controlJuicio?.fechaDeReactivacion ? fila.controlJuicio?.fechaDeReactivacion.format('dd/MM/yyyy') : "")
                                valores.val39 = (fila.controlJuicio?.fechaDeCancelacion ? fila.controlJuicio?.fechaDeCancelacion.format('dd/MM/yyyy') : "")
                                valores.val40 = (fila.controlJuicio?.fechaDeWfTerminado ? fila.controlJuicio?.fechaDeWfTerminado.format('dd/MM/yyyy') : "")
                                valores.val41 = (fila.juicio.fechaDeTermino ? fila.juicio.fechaDeTermino.format('dd/MM/yyyy') : "")
                                valores.val42 = (fila.controlJuicio?.fechaDeArchivoDefinitivo ? fila.controlJuicio?.fechaDeArchivoDefinitivo.format('dd/MM/yyyy') : "")
                                valores.val43 = (fila.controlJuicio?.fechaDeArchivoHistorico ? fila.controlJuicio?.fechaDeArchivoHistorico.format('dd/MM/yyyy') : "")
                                valores.val44 = (fila.juicio.motivoDeTermino ? fila.juicio.motivoDeTermino : "")
                                valores.val45 = (fila.juicio.monto ? fila.juicio.monto : "")
                                valores.val46 = (fila.juicio.cantidadPagada ? fila.juicio.cantidadPagada : "")
                                valores.val47 = (fila.juicio.juicioPagado ? "SI" : "NO")
                                valores.val48 = (fila.juicio.formaDePago ? fila.juicio.formaDePago : "")
                                valores.val49 = fila.juicio.creadorDelCaso
                                valores.val50 = (fila.juicio.personaQueModifico ? fila.juicio.personaQueModifico : "")
                                valores.val51 = (fila.controlJuicio?.reactivadoPor ? fila.controlJuicio?.reactivadoPor : "")
                                valores.val52 = (fila.controlJuicio?.canceladoPor ? fila.controlJuicio?.canceladoPor : "")
                                valores.val53 = (fila.controlJuicio?.wfTerminadoPor ? fila.controlJuicio?.wfTerminadoPor : "")
                                valores.val54 = (fila.juicio.terminadoPor ? fila.juicio.terminadoPor : "")
                                valores.val55 = (fila.controlJuicio?.archivadoPor ? fila.controlJuicio?.archivadoPor : "")
                                valores.val56 = (fila.controlJuicio?.enviadoHistoricoPor ? fila.controlJuicio?.enviadoHistoricoPor : "")
                                valores.val57 = (Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) ? Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) : "")
                                valores.val58 = (fila.juicio.responsableDelJuicio ? fila.juicio.responsableDelJuicio : "" )
                                valores.val59 = ((fila.juicio.despacho?.id > 0) ? (Despacho.getResponsable(fila.juicio.despacho.id) ?: "") : "")
                                valores.val60 = (fila.nota?.usuario ? fila.nota?.usuario : "")
                                valores.val61 = (fila.archivos > 0 ? "SI" : "NO")
                                valores.val62 = (fila.juicio.region ? fila.juicio.region.nombre : "")
                                valores.val63 = ((fila.juicio.despacho?.id > 0) ? fila.juicio.despacho?.id : "")
                                valores.val64 = ((fila.juicio.radicacionDelJuicio) ? fila.juicio.radicacionDelJuicio.nombre : "")
                                b << valores
                            }
                        } else {
                            def valores = [:]
                            valores.val1 = fila.juicio.id
                            valores.val2 = fila.juicio.delegacion.division
                            valores.val3 = fila.juicio.materia
                            valores.val4 = fila.juicio.delegacion.id
                            valores.val5 = fila.juicio.delegacion.nombre
                            valores.val6 = fila.juicio.expedienteInterno
                            valores.val7 = fila.juicio.expediente
                            valores.val8 = fila.juicio.tipoDeProcedimiento
                            valores.val9 = fila.juicio.estadoDeJuicio
                            valores.val10 = (fila.juicio.etapaProcesal ? fila.juicio.etapaProcesal : "WF SIN CONTESTAR")
                            valores.val11 = ""
                            valores.val12 = ""
                            valores.val13 = fila.demandados
                            valores.val14 = (fila.terceros ? fila.terceros : "")
                            valores.val15 = fila.juicio.despacho
                            valores.val16 = (fila.nota?.nota ? fila.nota?.nota : "")
                            valores.val17 = (fila.nota?.fechaDeNota ? fila.nota?.fechaDeNota.format('dd/MM/yyyy') : "")
                            valores.val18 = (fila.numeroDeCredito?.numeroDeCredito ? fila.numeroDeCredito?.numeroDeCredito : "")
                            valores.val19 = (fila.prestacionReclamada ? fila.prestacionReclamada : "")
                            valores.val20 = fila.tiposAsociados
                            valores.val21 = fila.juicio.ambito
                            valores.val22 = (fila.juicio.municipioAutoridad ? fila.juicio.municipioAutoridad : "")
                            valores.val23 = (fila.juicio.autoridad ? fila.juicio.autoridad : "")
                            valores.val24 = (fila.juicio.autoridad?.tipoDeAutoridad? fila.juicio.autoridad?.tipoDeAutoridad :"")
                            valores.val25 = fila.juicio.tipoDeParte
                            valores.val26 = (fila.juicio.patrocinadoDelJuicio ? fila.juicio.patrocinadoDelJuicio : "")
                            valores.val27 = fila.juicio.provision
                            valores.val28 = (fila.inmueble ? fila.inmueble : "")
                            valores.val29 = (fila.juicio.nombreDelFinado ? fila.juicio.nombreDelFinado : "")
                            valores.val30 = (fila.juicio.numeroSeguroSocialDelFinado ? fila.juicio.numeroSeguroSocialDelFinado : "")
                            valores.val31 = (fila.procesoAlterno?.tipoDeProcesoAlterno ? fila.procesoAlterno?.tipoDeProcesoAlterno : "")
                            valores.val32 = (fila.procesoAlterno?.expediente ? fila.procesoAlterno?.expediente : "")
                            valores.val33 = (fila.procesoAlterno?.notasFinales ? fila.procesoAlterno?.notasFinales : "")
                            valores.val34 = (fila.procesoAlterno?.estadoDeProceso ? fila.procesoAlterno?.estadoDeProceso : "")
                            valores.val35 = fila.juicio.fechaDeCreacion.format('dd/MM/yyyy')
                            valores.val36 = fila.juicio.fechaRD.format('dd/MM/yyyy')
                            valores.val37 = (fila.juicio.ultimaModificacion ? fila.juicio.ultimaModificacion.format('dd/MM/yyyy') : "")
                            valores.val38 = (fila.controlJuicio?.fechaDeReactivacion ? fila.controlJuicio?.fechaDeReactivacion.format('dd/MM/yyyy') : "")
                            valores.val39 = (fila.controlJuicio?.fechaDeCancelacion ? fila.controlJuicio?.fechaDeCancelacion.format('dd/MM/yyyy') : "")
                            valores.val40 = (fila.controlJuicio?.fechaDeWfTerminado ? fila.controlJuicio?.fechaDeWfTerminado.format('dd/MM/yyyy') : "")
                            valores.val41 = (fila.juicio.fechaDeTermino ? fila.juicio.fechaDeTermino.format('dd/MM/yyyy') : "")
                            valores.val42 = (fila.controlJuicio?.fechaDeArchivoDefinitivo ? fila.controlJuicio?.fechaDeArchivoDefinitivo.format('dd/MM/yyyy') : "")
                            valores.val43 = (fila.controlJuicio?.fechaDeArchivoHistorico ? fila.controlJuicio?.fechaDeArchivoHistorico.format('dd/MM/yyyy') : "")
                            valores.val44 = (fila.juicio.motivoDeTermino ? fila.juicio.motivoDeTermino : "")
                            valores.val45 = (fila.juicio.monto ? fila.juicio.monto : "")
                            valores.val46 = (fila.juicio.cantidadPagada ? fila.juicio.cantidadPagada : "")
                            valores.val47 = (fila.juicio.juicioPagado ? "SI" : "NO")
                            valores.val48 = (fila.juicio.formaDePago ? fila.juicio.formaDePago : "")
                            valores.val49 = fila.juicio.creadorDelCaso
                            valores.val50 = (fila.juicio.personaQueModifico ? fila.juicio.personaQueModifico : "")
                            valores.val51 = (fila.controlJuicio?.reactivadoPor ? fila.controlJuicio?.reactivadoPor : "")
                            valores.val52 = (fila.controlJuicio?.canceladoPor ? fila.controlJuicio?.canceladoPor : "")
                            valores.val53 = (fila.controlJuicio?.wfTerminadoPor ? fila.controlJuicio?.wfTerminadoPor : "")
                            valores.val54 = (fila.juicio.terminadoPor ? fila.juicio.terminadoPor : "")
                            valores.val55 = (fila.controlJuicio?.archivadoPor ? fila.controlJuicio?.archivadoPor : "")
                            valores.val56 = (fila.controlJuicio?.enviadoHistoricoPor ? fila.controlJuicio?.enviadoHistoricoPor : "")
                            valores.val57 = (Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) ? Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) : "")
                            valores.val58 = (fila.juicio.responsableDelJuicio ? fila.juicio.responsableDelJuicio : "" )
                            valores.val59 = ((fila.juicio.despacho?.id > 0) ? (Despacho.getResponsable(fila.juicio.despacho.id) ?: "") : "")
                            valores.val60 = (fila.nota?.usuario ? fila.nota?.usuario : "")
                            valores.val61 = (fila.archivos > 0 ? "SI" : "NO")
                            valores.val62 = (fila.juicio.region ? fila.juicio.region.nombre : "")
                            valores.val63 = ((fila.juicio.despacho?.id > 0) ? fila.juicio.despacho?.id : "")
                            valores.val64 = ((fila.juicio.radicacionDelJuicio) ? fila.juicio.radicacionDelJuicio.nombre : "")
                            b << valores
                        }
                    }
                } else {
                    reporte.each { fila ->
                        def valores = [:]
                        valores.val1 = fila.juicio.id
                        valores.val2 = fila.juicio.delegacion.division
                        valores.val3 = fila.juicio.materia
                        valores.val4 = fila.juicio.delegacion.id
                        valores.val5 = fila.juicio.delegacion.nombre
                        valores.val6 = fila.juicio.expedienteInterno
                        valores.val7 = fila.juicio.expediente
                        valores.val8 = fila.juicio.tipoDeProcedimiento
                        valores.val9 = fila.juicio.estadoDeJuicio
                        valores.val10 = (fila.juicio.etapaProcesal ? fila.juicio.etapaProcesal : "WF SIN CONTESTAR")
                        valores.val11 = fila.actores
                        valores.val12 = fila.demandados
                        valores.val13 = (fila.terceros ? fila.terceros : "")
                        valores.val14 = fila.juicio.despacho
                        valores.val15 = (fila.nota?.nota ? fila.nota?.nota : "")
                        valores.val16 = (fila.nota?.fechaDeNota ? fila.nota?.fechaDeNota.format('dd/MM/yyyy') : "")
                        valores.val17 = (fila.numeroDeCredito?.numeroDeCredito ? fila.numeroDeCredito?.numeroDeCredito : "")
                        valores.val18 = (fila.prestacionReclamada ? fila.prestacionReclamada : "")
                        valores.val19 = fila.tiposAsociados
                        valores.val20 = fila.juicio.ambito
                        valores.val21 = (fila.juicio.municipioAutoridad ? fila.juicio.municipioAutoridad : "")
                        valores.val22 = (fila.juicio.autoridad ? fila.juicio.autoridad : "")
                        valores.val23 = (fila.juicio.autoridad?.tipoDeAutoridad? fila.juicio.autoridad?.tipoDeAutoridad :"")
                        valores.val24 = fila.juicio.tipoDeParte
                        valores.val25 = (fila.juicio.patrocinadoDelJuicio ? fila.juicio.patrocinadoDelJuicio : "")
                        valores.val26 = fila.juicio.provision
                        valores.val27 = (fila.inmueble ? fila.inmueble : "")
                        valores.val28 = (fila.juicio.nombreDelFinado ? fila.juicio.nombreDelFinado : "")
                        valores.val29 = (fila.juicio.numeroSeguroSocialDelFinado ? fila.juicio.numeroSeguroSocialDelFinado : "")
                        valores.val30 = (fila.procesoAlterno?.tipoDeProcesoAlterno ? fila.procesoAlterno?.tipoDeProcesoAlterno : "")
                        valores.val31 = (fila.procesoAlterno?.expediente ? fila.procesoAlterno?.expediente : "")
                        valores.val32 = (fila.procesoAlterno?.notasFinales ? fila.procesoAlterno?.notasFinales : "")
                        valores.val33 = (fila.procesoAlterno?.estadoDeProceso ? fila.procesoAlterno?.estadoDeProceso : "")
                        valores.val34 = fila.juicio.fechaDeCreacion.format('dd/MM/yyyy')
                        valores.val35 = fila.juicio.fechaRD.format('dd/MM/yyyy')
                        valores.val36 = (fila.juicio.ultimaModificacion ? fila.juicio.ultimaModificacion.format('dd/MM/yyyy') : "")
                        valores.val37 = (fila.controlJuicio?.fechaDeReactivacion ? fila.controlJuicio?.fechaDeReactivacion.format('dd/MM/yyyy') : "")
                        valores.val38 = (fila.controlJuicio?.fechaDeCancelacion ? fila.controlJuicio?.fechaDeCancelacion.format('dd/MM/yyyy') : "")
                        valores.val39 = (fila.controlJuicio?.fechaDeWfTerminado ? fila.controlJuicio?.fechaDeWfTerminado.format('dd/MM/yyyy') : "")
                        valores.val40 = (fila.juicio.fechaDeTermino ? fila.juicio.fechaDeTermino.format('dd/MM/yyyy') : "")
                        valores.val41 = (fila.controlJuicio?.fechaDeArchivoDefinitivo ? fila.controlJuicio?.fechaDeArchivoDefinitivo.format('dd/MM/yyyy') : "")
                        valores.val42 = (fila.controlJuicio?.fechaDeArchivoHistorico ? fila.controlJuicio?.fechaDeArchivoHistorico.format('dd/MM/yyyy') : "")
                        valores.val43 = (fila.juicio.motivoDeTermino ? fila.juicio.motivoDeTermino : "")
                        valores.val44 = (fila.juicio.monto ? fila.juicio.monto : "")
                        valores.val45 = (fila.juicio.cantidadPagada ? fila.juicio.cantidadPagada : "")
                        valores.val46 = (fila.juicio.juicioPagado ? "SI" : "NO")
                        valores.val47 = (fila.juicio.formaDePago ? fila.juicio.formaDePago : "")
                        valores.val48 = fila.juicio.creadorDelCaso
                        valores.val49 = (fila.juicio.personaQueModifico ? fila.juicio.personaQueModifico : "")
                        valores.val50 = (fila.controlJuicio?.reactivadoPor ? fila.controlJuicio?.reactivadoPor : "")
                        valores.val51 = (fila.controlJuicio?.canceladoPor ? fila.controlJuicio?.canceladoPor : "")
                        valores.val52 = (fila.controlJuicio?.wfTerminadoPor ? fila.controlJuicio?.wfTerminadoPor : "")
                        valores.val53 = (fila.juicio.terminadoPor ? fila.juicio.terminadoPor : "")
                        valores.val54 = (fila.controlJuicio?.archivadoPor ? fila.controlJuicio?.archivadoPor : "")
                        valores.val55 = (fila.controlJuicio?.enviadoHistoricoPor ? fila.controlJuicio?.enviadoHistoricoPor : "")
                        valores.val56 = (Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) ? Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) : "")
                        valores.val57 = (fila.juicio.responsableDelJuicio ? fila.juicio.responsableDelJuicio : "" )
                        valores.val58 = ((fila.juicio.despacho?.id > 0) ? (Despacho.getResponsable(fila.juicio.despacho.id) ?: "") : "")
                        valores.val59 = (fila.nota?.usuario ? fila.nota?.usuario : "")
                        valores.val60 = (fila.archivos > 0 ? "SI" : "NO")
                        valores.val61 = (fila.juicio.region ? fila.juicio.region.nombre : "")
                        valores.val62 = ((fila.juicio.despacho?.id > 0) ? fila.juicio.despacho?.id : "")
                        valores.val63 = ((fila.juicio.radicacionDelJuicio) ? fila.juicio.radicacionDelJuicio.nombre : "")
                        b << valores
                    }
                }
            } else if(materia == 3){
                b = new CSVWriter(sw, {
                        col1: "idAsunto" { it.val1 }
                        col2: "Zona" { it.val2 }
                        col3: "Materia" { it.val3 }
                        col4: "Id Delegacion" { it.val4 }
                        col5: "Delegacion" { it.val5 }
                        col6: "Num. Exp. Interno" { it.val6 }
                        col7: "Exp. Juicio" { it.val7 }
                        col8: "Tipo de Juicio" { it.val8 }
                        col9: "Estatus" { it.val9 }
                        col10: "Etapa Procesal" { it.val10 }
                        col11: "Denunciante" { it.val11 }
                        col12: "Probable Responsable" { it.val12 }
                        col13: "Despacho" { it.val13 }
                        col14: "Notas" { it.val14 }
                        col15: "Fecha Nota" { it.val15 }
                        col16: "No. Credito" { it.val16 }
                        col17: "Prestacion Reclamada" { it.val17 }
                        col18: "Tipos Asociados" { it.val18 }
                        col19: "Ambito" { it.val19 }
                        col20: "Municipio" { it.val20 }
                        col21: "Autoridad" { it.val21 }
                        col22: "Juzgado" { it.val22 }
                        col23: "Tipo de Parte" { it.val23 }
                        col24: "Patrocinador" { it.val24 }
                        col25: "Provision" { it.val25 }
                        col26: "Inmueble" { it.val26 }
                        col27: "Nombre del Finado" { it.val27 }
                        col28: "NSS del Finado" { it.val28 }
                        col29: "Tipo de Proceso Alterno" { it.val29 }
                        col30: "Numero de Exp. Alterno o Toca" { it.val30 }
                        col31: "Resolución" { it.val31 }
                        col32: "Estatus Actual del Proceso Alterno" { it.val32 }
                        col33: "Fecha de Alta" { it.val33 }
                        col34: "Fecha de Envio al Despacho" { it.val34 }
                        col35: "Fecha de Modificacion" { it.val35 }
                        col36: "Fecha de Reactivacion" { it.val36 }
                        col37: "Fecha de Cancelado por Error" { it.val37 }
                        col38: "Fecha de WF Completado" { it.val38 }
                        col39: "Fecha de Termino" { it.val39 }
                        col40: "Fecha de Archivo Definitivo" { it.val40 }
                        col41: "Fecha de Historico" { it.val41 }
                        col42: "Motivo de Termino" { it.val42 }
                        col43: "Cantidad Demandada" { it.val43 }
                        col44: "Cantidad Pagada" { it.val44 }
                        col45: "Juicio Pagado" { it.val45 }
                        col46: "Forma de Pago" { it.val46 }
                        col47: "Elaborado Por" { it.val47 }
                        col48: "Modificado Por" { it.val48 }
                        col49: "Reactivado por" { it.val49 }
                        col50: "Cancelado Por" { it.val50 }
                        col51: "WF Completado Por" { it.val51 }
                        col52: "Terminado Por" { it.val52 }
                        col53: "Archivado Por" { it.val53 }  
                        col54: "Enviado a Historico Por" { it.val54 }  
                        col55: "Gerente Juridico" { it.val55 }
                        col56: "Responsable del Juicio" { it.val56 }
                        col57: "Responsable del Despacho" { it.val57 }
                        col58: "Usuario que modifico la nota" { it.val58 }
                        col59: "Contiene archivos adjuntos" { it.val59 }
                        col60: "Region" { it.val60 }
                        col61: "idDespacho" { it.val61 }
                    
                    })
                reporte.each { fila ->
                    def valores = [:]
                    valores.val1 = fila.juicio.id
                    valores.val2 = fila.juicio.delegacion.division
                    valores.val3 = fila.juicio.materia
                    valores.val4 = fila.juicio.delegacion.id
                    valores.val5 = fila.juicio.delegacion.nombre
                    valores.val6 = fila.juicio.expedienteInterno
                    valores.val7 = fila.juicio.expediente
                    valores.val8 = fila.juicio.tipoDeProcedimiento
                    valores.val9 = fila.juicio.estadoDeJuicio
                    valores.val10 = (fila.juicio.etapaProcesal ? fila.juicio.etapaProcesal : "WF SIN CONTESTAR")
                    valores.val11 = fila.denunciantes
                    valores.val12 = fila.probablesResponsables
                    valores.val13 = fila.juicio.despacho
                    valores.val14 = (fila.nota?.nota ? fila.nota?.nota : "")
                    valores.val15 = (fila.nota?.fechaDeNota ? fila.nota?.fechaDeNota.format('dd/MM/yyyy') : "")
                    valores.val16 = (fila.numeroDeCredito?.numeroDeCredito ? fila.numeroDeCredito?.numeroDeCredito : "")
                    valores.val17 = (fila.prestacionReclamada ? fila.prestacionReclamada : "")
                    valores.val18 = fila.tiposAsociados
                    valores.val19 = fila.juicio.ambito
                    valores.val20 = (fila.juicio.municipioAutoridad ? fila.juicio.municipioAutoridad : "")
                    valores.val21 = (fila.juicio.autoridad ? fila.juicio.autoridad : "")
                    valores.val22 = (fila.juicio.autoridad?.tipoDeAutoridad? fila.juicio.autoridad?.tipoDeAutoridad :"")
                    valores.val23 = fila.juicio.tipoDeParte
                    valores.val24 = (fila.juicio.patrocinadoDelJuicio ? fila.juicio.patrocinadoDelJuicio : "")
                    valores.val25 = fila.juicio.provision
                    valores.val26 = (fila.inmueble ? fila.inmueble : "")
                    valores.val27 = (fila.juicio.nombreDelFinado ? fila.juicio.nombreDelFinado : "")
                    valores.val28 = (fila.juicio.numeroSeguroSocialDelFinado ? fila.juicio.numeroSeguroSocialDelFinado : "")
                    valores.val29 = (fila.procesoAlterno?.tipoDeProcesoAlterno ? fila.procesoAlterno?.tipoDeProcesoAlterno : "")
                    valores.val30 = (fila.procesoAlterno?.expediente ? fila.procesoAlterno?.expediente : "")
                    valores.val31 = (fila.procesoAlterno?.notasFinales ? fila.procesoAlterno?.notasFinales : "")
                    valores.val32 = (fila.procesoAlterno?.estadoDeProceso ? fila.procesoAlterno?.estadoDeProceso : "")
                    valores.val33 = fila.juicio.fechaDeCreacion.format('dd/MM/yyyy')
                    valores.val34 = fila.juicio.fechaRD.format('dd/MM/yyyy')
                    valores.val35 = (fila.juicio.ultimaModificacion ? fila.juicio.ultimaModificacion.format('dd/MM/yyyy') : "")
                    valores.val36 = (fila.controlJuicio?.fechaDeReactivacion ? fila.controlJuicio?.fechaDeReactivacion.format('dd/MM/yyyy') : "")
                    valores.val37 = (fila.controlJuicio?.fechaDeCancelacion ? fila.controlJuicio?.fechaDeCancelacion.format('dd/MM/yyyy') : "")
                    valores.val38 = (fila.controlJuicio?.fechaDeWfTerminado ? fila.controlJuicio?.fechaDeWfTerminado.format('dd/MM/yyyy') : "")
                    valores.val39 = (fila.juicio.fechaDeTermino ? fila.juicio.fechaDeTermino.format('dd/MM/yyyy') : "")
                    valores.val40 = (fila.controlJuicio?.fechaDeArchivoDefinitivo ? fila.controlJuicio?.fechaDeArchivoDefinitivo.format('dd/MM/yyyy') : "")
                    valores.val41 = (fila.controlJuicio?.fechaDeArchivoHistorico ? fila.controlJuicio?.fechaDeArchivoHistorico.format('dd/MM/yyyy') : "")
                    valores.val42 = (fila.juicio.motivoDeTermino ? fila.juicio.motivoDeTermino : "")
                    valores.val43 = (fila.juicio.monto ? fila.juicio.monto : "")
                    valores.val44 = (fila.juicio.cantidadPagada ? fila.juicio.cantidadPagada : "")
                    valores.val45 = (fila.juicio.juicioPagado ? "SI" : "NO")
                    valores.val46 = (fila.juicio.formaDePago ? fila.juicio.formaDePago : "")
                    valores.val47 = fila.juicio.creadorDelCaso
                    valores.val48 = (fila.juicio.personaQueModifico ? fila.juicio.personaQueModifico : "")
                    valores.val49 = (fila.controlJuicio?.reactivadoPor ? fila.controlJuicio?.reactivadoPor : "")
                    valores.val50 = (fila.controlJuicio?.canceladoPor ? fila.controlJuicio?.canceladoPor : "")
                    valores.val51 = (fila.controlJuicio?.wfTerminadoPor ? fila.controlJuicio?.wfTerminadoPor : "")
                    valores.val52 = (fila.juicio.terminadoPor ? fila.juicio.terminadoPor : "")
                    valores.val53 = (fila.controlJuicio?.archivadoPor ? fila.controlJuicio?.archivadoPor : "")
                    valores.val54 = (fila.controlJuicio?.enviadoHistoricoPor ? fila.controlJuicio?.enviadoHistoricoPor : "")
                    valores.val55 = (Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) ? Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) : "")
                    valores.val56 = (fila.juicio.responsableDelJuicio ? fila.juicio.responsableDelJuicio : "" )
                    valores.val57 = ((fila.juicio.despacho?.id > 0) ? (Despacho.getResponsable(fila.juicio.despacho.id) ?: "") : "")
                    valores.val58 = (fila.nota?.usuario ? fila.nota?.usuario : "")
                    valores.val59 = (fila.archivos > 0 ? "SI" : "NO")
                    valores.val60 = (fila.juicio.region ? fila.juicio.region.nombre : "")
                    valores.val61 = ((fila.juicio.despacho?.id > 0) ? fila.juicio.despacho?.id : "")
                    b << valores
                }
            }  else if(materia == 4){
                b = new CSVWriter(sw, {
                        col1: "idAsunto" { it.val1 }
                        col2: "Zona" { it.val2 }
                        col3: "Materia" { it.val3 }
                        col4: "Id Delegacion" { it.val4 }
                        col5: "Delegacion" { it.val5 }
                        col6: "Num. Exp. Interno" { it.val6 }
                        col7: "Exp. Juicio" { it.val7 }
                        col8: "Tipo de Juicio" { it.val8 }
                        col9: "Estatus" { it.val9 }
                        col10: "Etapa Procesal" { it.val10 }
                        col11: "Actor" { it.val11 }
                        col12: "Demandado" { it.val12 }
                        col13: "Tercero Interesado" { it.val13 }
                        col14: "Fecha del Primer Pago" { it.val14 }
                        col15: "Fecha del Segundo Pago" { it.val15 }
                        col16: "Fecha del Tercer Pago" { it.val16 }
                        col17: "Fecha del Cuarto Pago" { it.val17 }
                        col18: "Monto del Primer Pago" { it.val18 }
                        col19: "Monto del Segundo Pago" { it.val19 }
                        col20: "Monto del Tercer Pago" { it.val20 }
                        col21: "Monto del Cuarto Pago" { it.val21 }
                        col22: "Despacho" { it.val22 }
                        col23: "Notas" { it.val23 }
                        col24: "Fecha Nota" { it.val24 }
                        col25: "No. Credito" { it.val25 }
                        col26: "Prestacion Reclamada" { it.val26 }
                        col27: "Tipos Asociados" { it.val27 }
                        col28: "Ambito" { it.val28 }
                        col29: "Municipio" { it.val29 }
                        col30: "Autoridad" { it.val30 }
                        col31: "Juzgado" { it.val31 }
                        col32: "Tipo de Parte" { it.val32 }
                        col33: "Patrocinador" { it.val33 }
                        col34: "Provision" { it.val34 }
                        col35: "Inmueble" { it.val35 }
                        col36: "Nombre del Finado" { it.val36 }
                        col37: "NSS del Finado" { it.val37 }
                        col38: "Tipo de Proceso Alterno" { it.val38 }
                        col39: "Numero de Exp. Alterno o Toca" { it.val39 }
                        col40: "Resolución" { it.val40 }
                        col41: "Estatus Actual del Proceso Alterno" { it.val41 }
                        col42: "Fecha de Alta" { it.val42 }
                        col43: "Fecha de Envio al Despacho" { it.val43 }
                        col44: "Fecha de Modificacion" { it.val44 }
                        col45: "Fecha de Reactivacion" { it.val45 }
                        col46: "Fecha de Cancelado por Error" { it.val46 }
                        col47: "Fecha de WF Completado" { it.val47 }
                        col48: "Fecha de Termino" { it.val48 }
                        col49: "Fecha de Archivo Definitivo" { it.val49 }
                        col50: "Fecha de Historico" { it.val50 }
                        col51: "Motivo de Termino" { it.val51 }
                        col52: "Cantidad Demandada" { it.val52 }
                        col53: "Cantidad Pagada" { it.val53 }
                        col54: "Juicio Pagado" { it.val54 }
                        col55: "Forma de Pago" { it.val55 }
                        col56: "Elaborado Por" { it.val56 }
                        col57: "Modificado Por" { it.val57 }
                        col58: "Reactivado por" { it.val58 }
                        col59: "Cancelado Por" { it.val59 }
                        col60: "WF Completado Por" { it.val60 }
                        col61: "Terminado Por" { it.val61 }
                        col62: "Archivado Por" { it.val62 }  
                        col63: "Enviado a Historico Por" { it.val63 }  
                        col64: "Gerente Juridico" { it.val64 }
                        col65: "Responsable del Juicio" { it.val65 }
                        col66: "Responsable del Despacho" { it.val66 }
                        col67: "Usuario que modifico la nota" { it.val67 }
                        col68: "Contiene archivos adjuntos" { it.val68 }
                        col69: "Region" { it.val69 }
                        col70: "idDespacho" { it.val70 }                   
                    })
                reporte.each { fila ->
                    def valores = [:]
                    valores.val1 = fila.juicio.id
                    valores.val2 = fila.juicio.delegacion.division
                    valores.val3 = fila.juicio.materia
                    valores.val4 = fila.juicio.delegacion.id
                    valores.val5 = fila.juicio.delegacion.nombre
                    valores.val6 = fila.juicio.expedienteInterno
                    valores.val7 = fila.juicio.expediente
                    valores.val8 = fila.juicio.tipoDeProcedimiento
                    valores.val9 = fila.juicio.estadoDeJuicio
                    valores.val10 = (fila.juicio.etapaProcesal ? fila.juicio.etapaProcesal : "WF SIN CONTESTAR")
                    valores.val11 = fila.actores
                    valores.val12 = fila.demandados
                    valores.val13 = (fila.terceros ? fila.terceros : "")
                    valores.val14 = (fila.pagos."fechaPago1" ? fila.pagos."fechaPago1".format('dd/MM/yyyy') : "")
                    valores.val15 = (fila.pagos."fechaPago2" ? fila.pagos."fechaPago2".format('dd/MM/yyyy') : "")
                    valores.val16 = (fila.pagos."fechaPago3" ? fila.pagos."fechaPago3".format('dd/MM/yyyy') : "")
                    valores.val17 = (fila.pagos."fechaPago4" ? fila.pagos."fechaPago4".format('dd/MM/yyyy') : "")
                    valores.val18 = (fila.pagos."montoPago1" ?: "")
                    valores.val19 = (fila.pagos."montoPago2" ?: "")
                    valores.val20 = (fila.pagos."montoPago3" ?: "")
                    valores.val21 = (fila.pagos."montoPago4" ?: "")
                    valores.val22 = fila.juicio.despacho
                    valores.val23 = (fila.nota?.nota ? fila.nota?.nota : "")
                    valores.val24 = (fila.nota?.fechaDeNota ? fila.nota?.fechaDeNota.format('dd/MM/yyyy') : "")
                    valores.val25 = (fila.numeroDeCredito?.numeroDeCredito ? fila.numeroDeCredito?.numeroDeCredito : "")
                    valores.val26 = (fila.prestacionReclamada ? fila.prestacionReclamada : "")
                    valores.val27 = fila.tiposAsociados
                    valores.val28 = fila.juicio.ambito
                    valores.val29 = (fila.juicio.municipioAutoridad ? fila.juicio.municipioAutoridad : "")
                    valores.val30 = (fila.juicio.autoridad ? fila.juicio.autoridad : "")
                    valores.val31 = (fila.juicio.autoridad?.tipoDeAutoridad? fila.juicio.autoridad?.tipoDeAutoridad :"")
                    valores.val32 = fila.juicio.tipoDeParte
                    valores.val33 = (fila.juicio.patrocinadoDelJuicio ? fila.juicio.patrocinadoDelJuicio : "")
                    valores.val34 = fila.juicio.provision
                    valores.val35 = (fila.inmueble ? fila.inmueble : "")
                    valores.val36 = (fila.juicio.nombreDelFinado ? fila.juicio.nombreDelFinado : "")
                    valores.val37 = (fila.juicio.numeroSeguroSocialDelFinado ? fila.juicio.numeroSeguroSocialDelFinado : "")
                    valores.val38 = (fila.procesoAlterno?.tipoDeProcesoAlterno ? fila.procesoAlterno?.tipoDeProcesoAlterno : "")
                    valores.val39 = (fila.procesoAlterno?.expediente ? fila.procesoAlterno?.expediente : "")
                    valores.val40 = (fila.procesoAlterno?.notasFinales ? fila.procesoAlterno?.notasFinales : "")
                    valores.val41 = (fila.procesoAlterno?.estadoDeProceso ? fila.procesoAlterno?.estadoDeProceso : "")
                    valores.val42 = fila.juicio.fechaDeCreacion.format('dd/MM/yyyy')
                    valores.val43 = fila.juicio.fechaRD.format('dd/MM/yyyy')
                    valores.val44 = (fila.juicio.ultimaModificacion ? fila.juicio.ultimaModificacion.format('dd/MM/yyyy') : "")
                    valores.val45 = (fila.controlJuicio?.fechaDeReactivacion ? fila.controlJuicio?.fechaDeReactivacion.format('dd/MM/yyyy') : "")
                    valores.val46 = (fila.controlJuicio?.fechaDeCancelacion ? fila.controlJuicio?.fechaDeCancelacion.format('dd/MM/yyyy') : "")
                    valores.val47 = (fila.controlJuicio?.fechaDeWfTerminado ? fila.controlJuicio?.fechaDeWfTerminado.format('dd/MM/yyyy') : "")
                    valores.val48 = (fila.juicio.fechaDeTermino ? fila.juicio.fechaDeTermino.format('dd/MM/yyyy') : "")
                    valores.val49 = (fila.controlJuicio?.fechaDeArchivoDefinitivo ? fila.controlJuicio?.fechaDeArchivoDefinitivo.format('dd/MM/yyyy') : "")
                    valores.val50 = (fila.controlJuicio?.fechaDeArchivoHistorico ? fila.controlJuicio?.fechaDeArchivoHistorico.format('dd/MM/yyyy') : "")
                    valores.val51 = (fila.juicio.motivoDeTermino ? fila.juicio.motivoDeTermino : "")
                    valores.val52 = (fila.juicio.monto ? fila.juicio.monto : "")
                    valores.val53 = (fila.juicio.cantidadPagada ? fila.juicio.cantidadPagada : "")
                    valores.val54 = (fila.juicio.juicioPagado ? "SI" : "NO")
                    valores.val55 = (fila.juicio.formaDePago ? fila.juicio.formaDePago : "")
                    valores.val56 = fila.juicio.creadorDelCaso
                    valores.val57 = (fila.juicio.personaQueModifico ? fila.juicio.personaQueModifico : "")
                    valores.val58 = (fila.controlJuicio?.reactivadoPor ? fila.controlJuicio?.reactivadoPor : "")
                    valores.val59 = (fila.controlJuicio?.canceladoPor ? fila.controlJuicio?.canceladoPor : "")
                    valores.val60 = (fila.controlJuicio?.wfTerminadoPor ? fila.controlJuicio?.wfTerminadoPor : "")
                    valores.val61 = (fila.juicio.terminadoPor ? fila.juicio.terminadoPor : "")
                    valores.val62 = (fila.controlJuicio?.archivadoPor ? fila.controlJuicio?.archivadoPor : "")
                    valores.val63 = (fila.controlJuicio?.enviadoHistoricoPor ? fila.controlJuicio?.enviadoHistoricoPor : "")
                    valores.val64 = (Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) ? Delegacion.getGerenteJuridico(fila.juicio.delegacion.id) : "")
                    valores.val65 = (fila.juicio.responsableDelJuicio ? fila.juicio.responsableDelJuicio : "" )
                    valores.val66 = ((fila.juicio.despacho?.id > 0) ? (Despacho.getResponsable(fila.juicio.despacho.id) ?: "") : "")
                    valores.val67 = (fila.nota?.usuario ? fila.nota?.usuario : "")
                    valores.val68 = (fila.archivos > 0 ? "SI" : "NO")
                    valores.val69 = (fila.juicio.region ? fila.juicio.region.nombre : "")
                    valores.val70 = ((fila.juicio.despacho?.id > 0) ? fila.juicio.despacho?.id : "")
                    b << valores
                }
            }
            def archivoReporte = new File("reporteGenerado.csv")
            archivoReporte.withWriter('UTF-8') { writer ->
                writer.write(b?.writer?.toString())
            }
            return archivoReporte
        } else {
            return null
        }
    }
    
    def getReporteXLSX(def reporte, def materia, def nssSeparado){
        if(reporte) {
            def workbook
            def builder = new ExcelBuilder()
            def plataforma = System.properties['os.name'].toLowerCase()
            def contenidoReporte = []
            def usuario = springSecurityService.currentUser
            def archivoDelReporte
            if(plataforma.contains('windows')){
                archivoDelReporte = new File("C:/tmp/reporteGenerado_" + usuario.username + "_" + materia + "_" + nssSeparado + ".xlsx")
            } else {
                archivoDelReporte = new File("/tmp/reporteGenerado_" + usuario.username + "_" + materia + "_" + nssSeparado + ".xlsx")
            }
            archivoDelReporte.createNewFile() 
            builder.config {
                font('negrita') { font ->
                    font.bold = true
                }
                style('titulo') { cellStyle ->
                    cellStyle.font = font('negrita')
                    cellStyle.alignment = CellStyle.ALIGN_LEFT
                    cellStyle.verticalAlignment = CellStyle.VERTICAL_CENTER
                }
                style('contenido') { cellStyle ->
                    cellStyle.alignment = CellStyle.ALIGN_LEFT
                    cellStyle.verticalAlignment = CellStyle.VERTICAL_CENTER
                }
            }
            if(materia == 0){
                workbook = builder.build {
                    sheet(name: "Reporte", widthColumns: [20,20,30,20,20,20,20,30,40,40,40,40,40,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]) {
                        row (style: 'titulo') {
                            cell { "Zona" }
                            cell { "Materia" }
                            cell { "Delegacion" }
                            cell { "Num. Exp. Interno" }
                            cell { "Exp. Juicio" }
                            cell { "Tipo de Juicio" }
                            cell { "Estatus" }
                            cell { "Etapa Procesal" }
                            cell { "Actor" }
                            cell { "Demandado" }
                            cell { "Tercero Interesado" }
                            cell { "Denunciante" }
                            cell { "Probable Responsable" }
                            cell { "Despacho" }
                            cell { "Notas" }
                            cell { "Fecha Nota" }
                            cell { "No. Credito" }
                            cell { "Prestacion Reclamada" }
                            cell { "Tipos Asociados" }
                            cell { "Tipos de Asignación" }
                            cell { "Délitos de Denunciados" }
                            cell { "Ambito" }
                            cell { "Municipio" }
                            cell { "Autoridad" }
                            cell { "Juzgado" }
                            cell { "Tipo de Parte" }
                            cell { "Patrocinador" }
                            cell { "Provision" }
                            cell { "Inmueble" }
                            cell { "Nombre del Finado" }
                            cell { "NSS del Finado" }
                            cell { "Tipo de Proceso Alterno" }
                            cell { "Numero de Exp. Alterno o Toca" }
                            cell { "Resolución" }
                            cell { "Estatus Actual del Proceso Alterno" }
                            cell { "Fecha de Alta" }
                            cell { "Fecha de Envio al Despacho" }
                            cell { "Fecha de Modificacion" }
                            cell { "Fecha de Última Modificacion WF" }
                            cell { "Fecha de Reactivacion" }
                            cell { "Fecha de Cancelado por Error" }
                            cell { "Fecha de WF Completado" }
                            cell { "Fecha de Termino" }
                            cell { "Fecha de Archivo Definitivo" }
                            cell { "Fecha de Historico" }
                            cell { "Motivo de Termino" }
                            cell { "Cantidad Demandada" }
                            cell { "Cantidad Pagada" }
                            cell { "Juicio Pagado" }
                            cell { "Forma de Pago" }
                            cell { "Elaborado Por" }
                            cell { "Modificado Por" }
                            cell { "WF Modificado Por" }
                            cell { "Reactivado por" }
                            cell { "Cancelado Por" }
                            cell { "WF Completado Por" }
                            cell { "Terminado Por" }
                            cell { "Archivado Por" }
                            cell { "Enviado a Historico Por" }
                            cell { "Gerente Juridico" }
                            cell { "Responsable del Juicio" }
                            cell { "Responsable del Despacho" }
                            cell { "Usuario que modifico la nota" }
                            cell { "Contiene archivos adjuntos" }
                            cell { "Region" }
                            cell { "idDespacho" }
                            cell { "¿En Donde esta Radicado el Juicio?" }
                            cell { "idAsunto" }
                            cell { "Id Delegacion" }
                        }
                        reporte.each { fila ->
                            row (style: 'contenido') {
                                cell { fila.division }
                                cell { fila.materia }
                                cell { fila.delegacion }
                                cell { fila.expediente_interno ?: "" }
                                cell { fila.expediente ?: "" }
                                cell { fila.tipo_de_procedimiento }
                                cell { fila.estado_del_juicio }
                                cell { (fila.etapa_procesal ?: "WF SIN CONTESTAR") }
                                cell { fila.actores ?: "" }
                                cell { fila.demandados ?: "" }
                                cell { (fila.terceros ?: "") }
                                cell { fila.denunciantes ?: "" }
                                cell { fila.probables_responsables ?: "" }
                                cell { fila.despacho ?: "" }
                                cell { (fila.nota ?: "") }
                                cell { (fila.fecha_de_nota ? fila.fecha_de_nota.format('dd/MM/yyyy') : "") }
                                cell { (fila.numero_de_credito ?: "") }
                                cell { (fila.prestacion_reclamada ?: "") }
                                cell { fila.tipos_asociados ?: "" }
                                cell { (fila.tipo_de_asignacion ?: "") }
                                cell { fila.delitos?: "" }
                                cell { fila.ambito }
                                cell { (fila.municipio ?: "") }
                                cell { (fila.autoridad ?: (fila.juzgadoAsignado ?: "")) }
                                cell { (fila.tipo_de_autoridad ?: "") }
                                cell { fila.tipo_de_parte }
                                cell { (fila.patrocinador_del_juicio ?: "") }
                                cell { fila.provision }
                                cell { (fila.inmueble ?: "") }
                                cell { (fila.nombre_del_finado ?: "") }
                                cell { (fila.numero_seguro_social_del_finado ?: "") }
                                cell { (fila.tipo_de_proceso_alterno ?: "") }
                                cell { (fila.expediente_proceso_alterno ?: "") }
                                cell { (fila.notas_finales ?: "") }
                                cell { (fila.estado_proceso_alterno ?: "") }
                                cell { fila.fecha_de_creacion.format('dd/MM/yyyy') }
                                cell { fila.fechard.format('dd/MM/yyyy') }
                                cell { (fila.ultima_modificacion ? fila.ultima_modificacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.ultima_actualizacion_workflow ? fila.ultima_actualizacion_workflow.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_reactivacion ? fila.fecha_de_reactivacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_cancelacion ? fila.fecha_de_cancelacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_wf_terminado ? fila.fecha_de_wf_terminado.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_termino ? fila.fecha_de_termino.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_archivo_definitivo ? fila.fecha_de_archivo_definitivo.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_archivo_historico ? fila.fecha_de_archivo_historico.format('dd/MM/yyyy') : "") }
                                cell { (fila.motivo_de_termino ? fila.motivo_de_termino : "") }
                                cell { (fila.monto ?: "") }
                                cell { (fila.cantidad_pagada ?: "") }
//                                cell { (fila.juicio_pagado?.getClass()) }
                                cell { (fila.juicio_pagado == true ? "SI" : "NO") }
                                cell { (fila.forma_de_pago ?: "") }
                                cell { fila.creador_del_caso }
                                cell { (fila.persona_que_modifico ?: "") }
                                cell { (fila.ultima_persona_que_actualizo_workflow ?: "") }
                                cell { (fila.reactivado_por ?: "") }
                                cell { (fila.cancelado_por ?: "") }
                                cell { (fila.wf_terminado_por ?: "") }
                                cell { (fila.terminado_por ?: "") }
                                cell { (fila.archivado_por ?: "") }
                                cell { (fila.enviado_historico_por ?: "") }
                                cell { (fila.gerente_juridico ?: "") }
                                cell { (fila.responsable_del_juicio ?: "" ) }
                                cell { (fila.responsable_del_despacho ?: "") }
                                cell { (fila.usuario ?: "") }
                                cell { (fila.tiene_archivos) }
                                cell { (fila.region ?: "") }
                                cell { ((fila.despacho_id > 0) ? fila.despacho_id : "") }
                                cell { ((fila.radicacion_del_juicio) ?: "") }
                                cell { fila.id_juicio }
                                cell { fila.delegacion_id }
                            }
                        }
                    }
                }
                workbook.write(new FileOutputStream(archivoDelReporte))
            } else if(materia == 1 || materia == 2){
                if(nssSeparado){
                    workbook =  builder.build {
                        sheet(name: "Reporte", widthColumns: [20,20,30,20,20,20,20,30,40,20,40,40,30,40,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]) {
                            row (style: 'titulo') {
                                cell { "Zona" }
                                cell { "Materia" }
                                cell { "Delegacion" }
                                cell { "Num. Exp. Interno" }
                                cell { "Exp. Juicio" }
                                cell { "Tipo de Juicio" }
                                cell { "Estatus" }
                                cell { "Etapa Procesal" }
                                cell { "Actor" }
                                cell { "NSS" }
                                cell { "Demandado" }
                                cell { "Tercero Interesado" }
                                cell { "Despacho" }
                                cell { "Notas" }
                                cell { "Fecha Nota" }
                                cell { "No. Credito" }
                                cell { "Prestacion Reclamada" }
                                cell { "Tipos Asociados" }
                                cell { "Ambito" }
                                cell { "Municipio" }
                                cell { "Autoridad" }
                                cell { "Juzgado" }
                                cell { "Tipo de Parte" }
                                cell { "Patrocinador" }
                                cell { "Provision" }
                                cell { "Inmueble" }
                                cell { "Nombre del Finado" }
                                cell { "NSS del Finado" }
                                cell { "Tipo de Proceso Alterno" }
                                cell { "Numero de Exp. Alterno o Toca" }
                                cell { "Resolución" }
                                cell { "Estatus Actual del Proceso Alterno" }
                                cell { "Fecha de Alta" }
                                cell { "Fecha de Envio al Despacho" }
                                cell { "Fecha de Modificacion" }
                                cell { "Fecha de Última Modificacion WF" }
                                cell { "Fecha de Reactivacion" }
                                cell { "Fecha de Cancelado por Error" }
                                cell { "Fecha de WF Completado" }
                                cell { "Fecha de Termino" }
                                cell { "Fecha de Archivo Definitivo" }
                                cell { "Fecha de Historico" }
                                cell { "Motivo de Termino" }
                                cell { "Cantidad Demandada" }
                                cell { "Cantidad Pagada" }
                                cell { "Juicio Pagado" }
                                cell { "Forma de Pago" }
                                cell { "Elaborado Por" }
                                cell { "Modificado Por" }
                                cell { "WF Modificado Por" }
                                cell { "Reactivado por" }
                                cell { "Cancelado Por" }
                                cell { "WF Completado Por" }
                                cell { "Terminado Por" }
                                cell { "Archivado Por" }
                                cell { "Enviado a Historico Por" }
                                cell { "Gerente Juridico" }
                                cell { "Responsable del Juicio" }
                                cell { "Responsable del Despacho" }
                                cell { "Usuario que modifico la nota" }
                                cell { "Contiene archivos adjuntos" }
                                cell { "Region" }
                                cell { "idDespacho" }
                                cell { "¿En Donde esta Radicado el Juicio?" }
                                cell { "idAsunto" }
                                cell { "Id Delegacion" }
                            }
                            reporte.each { fila ->
                                row (style: 'contenido') {
                                    cell { fila.division }
                                    cell { fila.materia }
                                    cell { fila.delegacion }
                                    cell { fila.expediente_interno ?: "" }
                                    cell { fila.expediente ?: "" }
                                    cell { fila.tipo_de_procedimiento }
                                    cell { fila.estado_del_juicio }
                                    cell { (fila.etapa_procesal ?: "WF SIN CONTESTAR") }
                                    cell { fila.actores ?: "" }
                                    cell { fila.nss ?: "" }
                                    cell { fila.demandados ?: "" }
                                    cell { (fila.terceros ?: "") }
                                    cell { fila.despacho ?: "" }
                                    cell { (fila.nota ?: "") }
                                    cell { (fila.fecha_de_nota ? fila.fecha_de_nota.format('dd/MM/yyyy') : "") }
                                    cell { (fila.numero_de_credito ?: "") }
                                    cell { (fila.prestacion_reclamada ?: "") }
                                    cell { fila.tipos_asociados ?: "" }
                                    cell { fila.ambito }
                                    cell { (fila.municipio ?: "") }
                                    cell { (fila.autoridad ?: (fila.juzgadoAsignado ?: "")) }
                                    cell { (fila.tipo_de_autoridad ?: "") }
                                    cell { fila.tipo_de_parte }
                                    cell { (fila.patrocinador_del_juicio ?: "") }
                                    cell { fila.provision }
                                    cell { (fila.inmueble ?: "") }
                                    cell { (fila.nombre_del_finado ?: "") }
                                    cell { (fila.numero_seguro_social_del_finado ?: "") }
                                    cell { (fila.tipo_de_proceso_alterno ?: "") }
                                    cell { (fila.expediente_proceso_alterno ?: "") }
                                    cell { (fila.notas_finales ?: "") }
                                    cell { (fila.estado_proceso_alterno ?: "") }
                                    cell { fila.fecha_de_creacion.format('dd/MM/yyyy') }
                                    cell { fila.fechard.format('dd/MM/yyyy') }
                                    cell { (fila.ultima_modificacion ? fila.ultima_modificacion.format('dd/MM/yyyy') : "") }
                                    cell { (fila.ultima_actualizacion_workflow ? fila.ultima_actualizacion_workflow.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_reactivacion ? fila.fecha_de_reactivacion.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_cancelacion ? fila.fecha_de_cancelacion.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_wf_terminado ? fila.fecha_de_wf_terminado.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_termino ? fila.fecha_de_termino.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_archivo_definitivo ? fila.fecha_de_archivo_definitivo.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_archivo_historico ? fila.fecha_de_archivo_historico.format('dd/MM/yyyy') : "") }
                                    cell { (fila.motivo_de_termino ? fila.motivo_de_termino : "") }
                                    cell { (fila.monto ?: "") }
                                    cell { (fila.cantidad_pagada ?: "") }
//                                    cell { (fila.juicio_pagado?.getClass()) }
                                    cell { (fila.juicio_pagado == true ? "SI" : "NO") }
                                    cell { (fila.forma_de_pago ?: "") }
                                    cell { fila.creador_del_caso }
                                    cell { (fila.persona_que_modifico ?: "") }
                                    cell { (fila.ultima_persona_que_actualizo_workflow ?: "") }
                                    cell { (fila.reactivado_por ?: "") }
                                    cell { (fila.cancelado_por ?: "") }
                                    cell { (fila.wf_terminado_por ?: "") }
                                    cell { (fila.terminado_por ?: "") }
                                    cell { (fila.archivado_por ?: "") }
                                    cell { (fila.enviado_historico_por ?: "") }
                                    cell { (fila.gerente_juridico ?: "") }
                                    cell { (fila.responsable_del_juicio ?: "" ) }
                                    cell { (fila.responsable_del_despacho ?: "") }
                                    cell { (fila.usuario ?: "") }
                                    cell { (fila.tiene_archivos) }
                                    cell { (fila.region ?: "") }
                                    cell { ((fila.despacho_id > 0) ? fila.despacho_id : "") }
                                    cell { ((fila.radicacion_del_juicio) ?: "") }
                                    cell { fila.id_juicio }
                                    cell { fila.delegacion_id }   
                                }
                            }
                        }
                    }
                } else {
                    workbook = builder.build {
                        sheet(name: "Reporte", widthColumns: [20,20,30,20,20,20,20,30,40,40,40,30,40,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]) {
                            row (style: 'titulo') {
                                cell { "Zona" }
                                cell { "Materia" }
                                cell { "Delegacion" }
                                cell { "Num. Exp. Interno" }
                                cell { "Exp. Juicio" }
                                cell { "Tipo de Juicio" }
                                cell { "Estatus" }
                                cell { "Etapa Procesal" }
                                cell { "Actor" }
                                cell { "Demandado" }
                                cell { "Tercero Interesado" }
                                cell { "Despacho" }
                                cell { "Notas" }
                                cell { "Fecha Nota" }
                                cell { "No. Credito" }
                                cell { "Prestacion Reclamada" }
                                cell { "Tipos Asociados" }
                                cell { "Ambito" }
                                cell { "Municipio" }
                                cell { "Autoridad" }
                                cell { "Juzgado" }
                                cell { "Tipo de Parte" }
                                cell { "Patrocinador" }
                                cell { "Provision" }
                                cell { "Inmueble" }
                                cell { "Nombre del Finado" }
                                cell { "NSS del Finado" }
                                cell { "Tipo de Proceso Alterno" }
                                cell { "Numero de Exp. Alterno o Toca" }
                                cell { "Resolución" }
                                cell { "Estatus Actual del Proceso Alterno" }
                                cell { "Fecha de Alta" }
                                cell { "Fecha de Envio al Despacho" }
                                cell { "Fecha de Modificacion" }
                                cell { "Fecha de Última Modificacion WF" }
                                cell { "Fecha de Reactivacion" }
                                cell { "Fecha de Cancelado por Error" }
                                cell { "Fecha de WF Completado" }
                                cell { "Fecha de Termino" }
                                cell { "Fecha de Archivo Definitivo" }
                                cell { "Fecha de Historico" }
                                cell { "Motivo de Termino" }
                                cell { "Cantidad Demandada" }
                                cell { "Cantidad Pagada" }
                                cell { "Juicio Pagado" }
                                cell { "Forma de Pago" }
                                cell { "Elaborado Por" }
                                cell { "Modificado Por" }
                                cell { "WF Modificado Por" }
                                cell { "Reactivado por" }
                                cell { "Cancelado Por" }
                                cell { "WF Completado Por" }
                                cell { "Terminado Por" }
                                cell { "Archivado Por" }
                                cell { "Enviado a Historico Por" }
                                cell { "Gerente Juridico" }
                                cell { "Responsable del Juicio" }
                                cell { "Responsable del Despacho" }
                                cell { "Usuario que modifico la nota" }
                                cell { "Contiene archivos adjuntos" }
                                cell { "Region" }
                                cell { "idDespacho" }
                                cell { "¿En Donde esta Radicado el Juicio?" }
                                cell { "idAsunto" }
                                cell { "Id Delegacion" }
                            }
                            reporte.each { fila ->
                                row (style: 'contenido') {
                                    cell { fila.division }
                                    cell { fila.materia }
                                    cell { fila.delegacion }
                                    cell { fila.expediente_interno ?: "" }
                                    cell { fila.expediente ?: "" }
                                    cell { fila.tipo_de_procedimiento }
                                    cell { fila.estado_del_juicio }
                                    cell { (fila.etapa_procesal ?: "WF SIN CONTESTAR") }
                                    cell { fila.actores ?: "" }
                                    cell { fila.demandados ?: "" }
                                    cell { (fila.terceros ?: "") }
                                    cell { fila.despacho ?: "" }
                                    cell { (fila.nota ?: "") }
                                    cell { (fila.fecha_de_nota ? fila.fecha_de_nota.format('dd/MM/yyyy') : "") }
                                    cell { (fila.numero_de_credito ?: "") }
                                    cell { (fila.prestacion_reclamada ?: "") }
                                    cell { fila.tipos_asociados ?: "" }
                                    cell { fila.ambito }
                                    cell { (fila.municipio ?: "") }
                                    cell { (fila.autoridad ?: (fila.juzgadoAsignado ?: "")) }
                                    cell { (fila.tipo_de_autoridad ?: "") }
                                    cell { fila.tipo_de_parte }
                                    cell { (fila.patrocinador_del_juicio ?: "") }
                                    cell { fila.provision }
                                    cell { (fila.inmueble ?: "") }
                                    cell { (fila.nombre_del_finado ?: "") }
                                    cell { (fila.numero_seguro_social_del_finado ?: "") }
                                    cell { (fila.tipo_de_proceso_alterno ?: "") }
                                    cell { (fila.expediente_proceso_alterno ?: "") }
                                    cell { (fila.notas_finales ?: "") }
                                    cell { (fila.estado_proceso_alterno ?: "") }
                                    cell { fila.fecha_de_creacion.format('dd/MM/yyyy') }
                                    cell { fila.fechard.format('dd/MM/yyyy') }
                                    cell { (fila.ultima_modificacion ? fila.ultima_modificacion.format('dd/MM/yyyy') : "") }
                                    cell { (fila.ultima_actualizacion_workflow ? fila.ultima_actualizacion_workflow.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_reactivacion ? fila.fecha_de_reactivacion.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_cancelacion ? fila.fecha_de_cancelacion.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_wf_terminado ? fila.fecha_de_wf_terminado.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_termino ? fila.fecha_de_termino.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_archivo_definitivo ? fila.fecha_de_archivo_definitivo.format('dd/MM/yyyy') : "") }
                                    cell { (fila.fecha_de_archivo_historico ? fila.fecha_de_archivo_historico.format('dd/MM/yyyy') : "") }
                                    cell { (fila.motivo_de_termino ? fila.motivo_de_termino : "") }
                                    cell { (fila.monto ?: "") }
                                    cell { (fila.cantidad_pagada ?: "") }
//                                    cell { (fila.juicio_pagado?.getClass()) }
                                    cell { (fila.juicio_pagado == true ? "SI" : "NO") }
                                    cell { (fila.forma_de_pago ?: "") }
                                    cell { fila.creador_del_caso }
                                    cell { (fila.persona_que_modifico ?: "") }
                                    cell { (fila.ultima_persona_que_actualizo_workflow ?: "") }
                                    cell { (fila.reactivado_por ?: "") }
                                    cell { (fila.cancelado_por ?: "") }
                                    cell { (fila.wf_terminado_por ?: "") }
                                    cell { (fila.terminado_por ?: "") }
                                    cell { (fila.archivado_por ?: "") }
                                    cell { (fila.enviado_historico_por ?: "") }
                                    cell { (fila.gerente_juridico ?: "") }
                                    cell { (fila.responsable_del_juicio ?: "" ) }
                                    cell { (fila.responsable_del_despacho ?: "") }
                                    cell { (fila.usuario ?: "") }
                                    cell { (fila.tiene_archivos) }
                                    cell { (fila.region ?: "") }
                                    cell { ((fila.despacho_id > 0) ? fila.despacho_id : "") }
                                    cell { ((fila.radicacion_del_juicio) ?: "") }
                                    cell { fila.id_juicio }
                                    cell { fila.delegacion_id }
                                }
                            }
                        }
                    }
                }
                workbook.write(new FileOutputStream(archivoDelReporte))
            } else if(materia == 3){
                workbook = builder.build {
                    sheet(name: "Reporte", widthColumns: [20,20,30,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]) {
                        row (style: 'titulo') {
                            cell { "Zona" }
                            cell { "Materia" }
                            cell { "Delegacion" }
                            cell { "Num. Exp. Interno" }
                            cell { "Exp. Juicio" }
                            cell { "Tipo de Juicio" }
                            cell { "Estatus" }
                            cell { "Etapa Procesal" }
                            cell { "Denunciante" }
                            cell { "Probable Responsable" }
                            cell { "Despacho" }
                            cell { "Notas" }
                            cell { "Fecha Nota" }
                            cell { "No. Credito" }
                            cell { "Tipos de Asignación" }
                            cell { "Délitos de Denunciados" }
                            cell { "Ambito" }
                            cell { "Municipio" }
                            cell { "Autoridad" }
                            cell { "Juzgado" }
                            cell { "Tipo de Parte" }
                            cell { "Patrocinador" }
                            cell { "Provision" }
                            cell { "Inmueble" }
                            cell { "Tipo de Proceso Alterno" }
                            cell { "Numero de Exp. Alterno o Toca" }
                            cell { "Resolución" }
                            cell { "Estatus Actual del Proceso Alterno" }
                            cell { "Fecha de Alta" }
                            cell { "Fecha de Envio al Despacho" }
                            cell { "Fecha de Modificacion" }
                            cell { "Fecha de Última Modificacion WF" }
                            cell { "Fecha de Reactivacion" }
                            cell { "Fecha de Cancelado por Error" }
                            cell { "Fecha de WF Completado" }
                            cell { "Fecha de Termino" }
                            cell { "Fecha de Archivo Definitivo" }
                            cell { "Fecha de Historico" }
                            cell { "Motivo de Termino" }
                            cell { "Cantidad Demandada" }
                            cell { "Cantidad Pagada" }
                            cell { "Juicio Pagado" }
                            cell { "Forma de Pago" }
                            cell { "Elaborado Por" }
                            cell { "Modificado Por" }
                            cell { "WF Modificado Por" }
                            cell { "Reactivado por" }
                            cell { "Cancelado Por" }
                            cell { "WF Completado Por" }
                            cell { "Terminado Por" }
                            cell { "Archivado Por" } 
                            cell { "Enviado a Historico Por" } 
                            cell { "Gerente Juridico" }
                            cell { "Responsable del Juicio" }
                            cell { "Responsable del Despacho" }
                            cell { "Usuario que modifico la nota" }
                            cell { "Contiene archivos adjuntos" }
                            cell { "Region" }
                            cell { "idDespacho" }
                            cell { "idAsunto" }
                            cell { "Id Delegacion" }
                        }
                        reporte.each { fila ->
                            row (style: 'contenido') {
                                cell { fila.division }
                                cell { fila.materia }
                                cell { fila.delegacion }
                                cell { fila.expediente_interno ?: "" }
                                cell { fila.expediente ?: "" }
                                cell { fila.tipo_de_procedimiento }
                                cell { fila.estado_del_juicio }
                                cell { (fila.etapa_procesal ?: "WF SIN CONTESTAR") }
                                cell { fila.denunciantes ?: "" }
                                cell { fila.probables_responsables ?: "" }
                                cell { fila.despacho ?: "" }
                                cell { (fila.nota ?: "") }
                                cell { (fila.fecha_de_nota ? fila.fecha_de_nota.format('dd/MM/yyyy') : "") }
                                cell { (fila.numero_de_credito ?: "") }
                                cell { (fila.tipo_de_asignacion ?: "") }
                                cell { fila.delitos?: "" }
                                cell { fila.ambito }
                                cell { (fila.municipio ?: "") }
                                cell { (fila.autoridad ?: "") }
                                cell { (fila.tipo_de_autoridad ?: "") }
                                cell { fila.tipo_de_parte }
                                cell { (fila.patrocinador_del_juicio ?: "") }
                                cell { fila.provision }
                                cell { (fila.inmueble ?: "") }
                                cell { (fila.tipo_de_proceso_alterno ?: "") }
                                cell { (fila.expediente_proceso_alterno ?: "") }
                                cell { (fila.notas_finales ?: "") }
                                cell { (fila.estado_proceso_alterno ?: "") }
                                cell { fila.fecha_de_creacion.format('dd/MM/yyyy') }
                                cell { fila.fechard.format('dd/MM/yyyy') }
                                cell { (fila.ultima_modificacion ? fila.ultima_modificacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.ultima_actualizacion_workflow ? fila.ultima_actualizacion_workflow.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_reactivacion ? fila.fecha_de_reactivacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_cancelacion ? fila.fecha_de_cancelacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_wf_terminado ? fila.fecha_de_wf_terminado.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_termino ? fila.fecha_de_termino.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_archivo_definitivo ? fila.fecha_de_archivo_definitivo.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_archivo_historico ? fila.fecha_de_archivo_historico.format('dd/MM/yyyy') : "") }
                                cell { (fila.motivo_de_termino ? fila.motivo_de_termino : "") }
                                cell { (fila.monto ?: "") }
                                cell { (fila.cantidad_pagada ?: "") }
                                cell { (fila.juicio_pagado == true ? "SI" : "NO") }
                                cell { (fila.forma_de_pago ?: "") }
                                cell { fila.creador_del_caso }
                                cell { (fila.persona_que_modifico ?: "") }
                                cell { (fila.ultima_persona_que_actualizo_workflow ?: "") }
                                cell { (fila.reactivado_por ?: "") }
                                cell { (fila.cancelado_por ?: "") }
                                cell { (fila.wf_terminado_por ?: "") }
                                cell { (fila.terminado_por ?: "") }
                                cell { (fila.archivado_por ?: "") }
                                cell { (fila.enviado_historico_por ?: "") }
                                cell { (fila.gerente_juridico ?: "") }
                                cell { (fila.responsable_del_juicio ?: "" ) }
                                cell { (fila.responsable_del_despacho ?: "") }
                                cell { (fila.usuario ?: "") }
                                cell { (fila.tiene_archivos) }
                                cell { (fila.region ?: "") }
                                cell { ((fila.despacho_id > 0) ? fila.despacho_id : "") }
                                cell { fila.id_juicio }
                                cell { fila.delegacion_id }
                            }
                        }
                    }
                }
                workbook.write(new FileOutputStream(archivoDelReporte))
            }  else if(materia == 4){
                workbook = builder.build {
                    sheet(name: "Reporte", widthColumns: [20,20,30,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]) {
                        row (style: 'titulo') {
                            cell { "Zona" }
                            cell { "Materia" }
                            cell { "Delegacion" }
                            cell { "Num. Exp. Interno" }
                            cell { "Exp. Juicio" }
                            cell { "Tipo de Juicio" }
                            cell { "Estatus" }
                            cell { "Etapa Procesal" }
                            cell { "Actor" }
                            cell { "Demandado" }
                            cell { "Tercero Interesado" }
                            cell { "Fecha del Primer Pago" }
                            cell { "Fecha del Segundo Pago" }
                            cell { "Fecha del Tercer Pago" }
                            cell { "Fecha del Cuarto Pago" }
                            cell { "Monto del Primer Pago" }
                            cell { "Monto del Segundo Pago" }
                            cell { "Monto del Tercer Pago" }
                            cell { "Monto del Cuarto Pago" }
                            cell { "Despacho" }
                            cell { "Notas" }
                            cell { "Fecha Nota" }
                            cell { "No. Credito" }
                            cell { "Prestacion Reclamada" }
                            cell { "Tipos Asociados" }
                            cell { "Ambito" }
                            cell { "Municipio" }
                            cell { "Autoridad" }
                            cell { "Juzgado" }
                            cell { "Tipo de Parte" }
                            cell { "Patrocinador" }
                            cell { "Provision" }
                            cell { "Inmueble" }
                            cell { "Nombre del Finado" }
                            cell { "NSS del Finado" }
                            cell { "Tipo de Proceso Alterno" }
                            cell { "Numero de Exp. Alterno o Toca" }
                            cell { "Resolución" }
                            cell { "Estatus Actual del Proceso Alterno" }
                            cell { "Fecha de Alta" }
                            cell { "Fecha de Envio al Despacho" }
                            cell { "Fecha de Modificacion" }
                            cell { "Fecha de Última Modificacion WF" }
                            cell { "Fecha de Reactivacion" }
                            cell { "Fecha de Cancelado por Error" }
                            cell { "Fecha de WF Completado" }
                            cell { "Fecha de Termino" }
                            cell { "Fecha de Archivo Definitivo" }
                            cell { "Fecha de Historico" }
                            cell { "Motivo de Termino" }
                            cell { "Cantidad Demandada" }
                            cell { "Cantidad Pagada" }
                            cell { "Juicio Pagado" }
                            cell { "Forma de Pago" }
                            cell { "Elaborado Por" }
                            cell { "Modificado Por" }
                            cell { "WF Modificado Por" }
                            cell { "Reactivado por" }
                            cell { "Cancelado Por" }
                            cell { "WF Completado Por" }
                            cell { "Terminado Por" }
                            cell { "Archivado Por" }
                            cell { "Enviado a Historico Por" } 
                            cell { "Gerente Juridico" }
                            cell { "Responsable del Juicio" }
                            cell { "Responsable del Despacho" }
                            cell { "Usuario que modifico la nota" }
                            cell { "Contiene archivos adjuntos" }
                            cell { "Region" }
                            cell { "idDespacho" }
                            cell { "idAsunto" }
                            cell { "Id Delegacion" }
                        }
                        reporte.each { fila ->
                            row (style: 'contenido') {
                                cell { fila.division }
                                cell { fila.materia }
                                cell { fila.delegacion }
                                cell { fila.expediente_interno ?: "" }
                                cell { fila.expediente ?: "" }
                                cell { fila.tipo_de_procedimiento }
                                cell { fila.estado_del_juicio }
                                cell { (fila.etapa_procesal ?: "WF SIN CONTESTAR") }
                                cell { fila.actores ?: "" }
                                cell { fila.demandados ?: "" }
                                cell { fila.terceros ?: "" }
                                cell { (fila.fecha_primer_pago ? fila.fecha_primer_pago.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_segundo_pago ? fila.fecha_segundo_pago.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_tercer_pago ? fila.fecha_tercer_pago.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_cuarto_pago ? fila.fecha_cuarto_pago.format('dd/MM/yyyy') : "") }
                                cell { (fila.monto_primer_pago ?: "") }
                                cell { (fila.monto_segundo_pago ?: "") }
                                cell { (fila.monto_tercer_pago ?: "") }
                                cell { (fila.monto_cuarto_pago ?: "") }
                                cell { fila.despacho ?: ""}
                                cell { (fila.nota ?: "") }
                                cell { (fila.fecha_de_nota ? fila.fecha_de_nota.format('dd/MM/yyyy') : "") }
                                cell { (fila.numero_de_credito ?: "") }
                                cell { (fila.prestacion_reclamada ?: "") }
                                cell { fila.tipos_asociados }
                                cell { fila.ambito }
                                cell { (fila.municipio ?: "") }
                                cell { (fila.autoridad ?: "") }
                                cell { (fila.tipo_de_autoridad?: "") }
                                cell { fila.tipo_de_parte }
                                cell { (fila.patrocinador_del_juicio ?: "") }
                                cell { fila.provision }
                                cell { (fila.inmueble ?: "") }
                                cell { (fila.nombre_del_finado ?: "") }
                                cell { (fila.numero_seguro_social_del_finado ?: "") }
                                cell { (fila.tipo_de_proceso_alterno ?: "") }
                                cell { (fila.expediente_proceso_alterno ?: "") }
                                cell { (fila.notas_finales ?: "") }
                                cell { (fila.estado_proceso_alterno ?: "") }
                                cell { fila.fecha_de_creacion.format('dd/MM/yyyy') }
                                cell { fila.fechard.format('dd/MM/yyyy') }
                                cell { (fila.ultima_modificacion ? fila.ultima_modificacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.ultima_actualizacion_workflow ? fila.ultima_actualizacion_workflow.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_reactivacion ? fila.fecha_de_reactivacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_cancelacion ? fila.fecha_de_cancelacion.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_wf_terminado ? fila.fecha_de_wf_terminado.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_termino ? fila.fecha_de_termino.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_archivo_definitivo ? fila.fecha_de_archivo_definitivo.format('dd/MM/yyyy') : "") }
                                cell { (fila.fecha_de_archivo_historico ? fila.fecha_de_archivo_historico.format('dd/MM/yyyy') : "") }
                                cell { (fila.motivo_de_termino ? fila.motivoDeTermino : "") }
                                cell { (fila.monto ?: "") }
                                cell { (fila.cantidad_pagada ?: "") }
                                cell { (fila.juicio_pagado == true ? "SI" : "NO") }
                                cell { (fila.forma_de_pago ?: "") }
                                cell { fila.creador_del_caso }
                                cell { (fila.persona_que_modifico ?: "") }
                                cell { (fila.ultima_persona_que_actualizo_workflow ?: "") }
                                cell { (fila.reactivado_por ?: "") }
                                cell { (fila.cancelado_por ?: "") }
                                cell { (fila.wf_terminado_por ?: "") }
                                cell { (fila.terminado_por ?: "") }
                                cell { (fila.archivado_por ?: "") }
                                cell { (fila.enviado_historico_por ?: "") }
                                cell { (fila.gerente_juridico ?: "") }
                                cell { (fila.responsable_del_juicio ?: "" ) }
                                cell { (fila.responsable_del_despacho ?: "") }
                                cell { (fila.usuario ?: "") }
                                cell { (fila.tiene_archivos) }
                                cell { (fila.region ?: "") }
                                cell { ((fila.despacho_id > 0) ? fila.despacho_id : "") }
                                cell { fila.id_juicio }
                                cell { fila.delegacion_id }
                            }
                        }
                    }
                }
                workbook.write(new FileOutputStream(archivoDelReporte))
            }
            builder = null
            workbook.dispose();
            workbook = null
            return archivoDelReporte
        } else {
            return null
        }
    }
}
