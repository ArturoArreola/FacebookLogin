package mx.gox.infonavit.sicj.juicios

import grails.transaction.Transactional
import mx.gox.infonavit.sicj.catalogos.Autoridad
import mx.gox.infonavit.sicj.catalogos.TipoDeProcedimiento
import mx.gox.infonavit.sicj.catalogos.TipoDeParte
import mx.gox.infonavit.sicj.catalogos.PreguntaEtapaProcesal
import mx.gox.infonavit.sicj.catalogos.EtapaProcesal
import mx.gox.infonavit.sicj.catalogos.FlujoEtapaProcesal
import mx.gox.infonavit.sicj.juicios.FlujoJuicio
import mx.gox.infonavit.sicj.catalogos.RespuestaPregunta
import mx.gox.infonavit.sicj.catalogos.TipoDePregunta
import mx.gox.infonavit.sicj.catalogos.TipoDePersona
import mx.gox.infonavit.sicj.catalogos.Persona
import mx.gox.infonavit.sicj.catalogos.Delito
import mx.gox.infonavit.sicj.juicios.ActorJuicio
import mx.gox.infonavit.sicj.juicios.TipoAsociadoJuicio
import mx.gox.infonavit.sicj.juicios.DelitoJuicio
import mx.gox.infonavit.sicj.admin.Delegacion
import mx.gox.infonavit.sicj.admin.Despacho
import mx.gox.infonavit.sicj.admin.Perfil
import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.EstadoDeJuicio
import mx.gox.infonavit.sicj.catalogos.Materia
import mx.gox.infonavit.sicj.juicios.Juicio
import grails.converters.JSON
import grails.plugins.csv.CSVWriter
import groovy.sql.Sql
import java.text.DateFormat
import java.text.SimpleDateFormat
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.hssf.usermodel.HSSFSheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.xssf.usermodel.XSSFRow
import org.apache.poi.xssf.usermodel.XSSFCell
//import org.apache.poi.xssf.usermodel.XSSFFormulaEvaluator
import org.apache.poi.ss.usermodel.DataFormatter
import org.apache.poi.ss.usermodel.*
import com.monitorjbl.xlsx.StreamingReader
import org.apache.poi.ss.usermodel.Workbook
import org.apache.poi.ss.usermodel.Sheet
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Cell

@Transactional
class JuicioService {
    
    private static final Logger log = LogManager.getLogger(JuicioService)
    
    def dataSource
    def springSecurityService

    def obtenerSiguientePregunta(def juicioId, def respuestaId) {
        def juicio = Juicio.get(juicioId as long)
        def tipoDeProcedimiento = juicio.tipoDeProcedimiento
        def etapaProcesal = juicio.etapaProcesal
        def tipoDeParte = juicio.tipoDeParte
        def ultimaPregunta = juicio.ultimaPregunta
        def respuestaPregunta = RespuestaPregunta.get(respuestaId)
        def datosPregunta = [:]
        def flujo
        if(etapaProcesal && ultimaPregunta && respuestaPregunta){
            log.info "entra a 1"
            flujo = FlujoEtapaProcesal.findAllWhere(preguntaActual: ultimaPregunta, respuesta: respuestaPregunta, tipoDeParte: tipoDeParte)
            datosPregunta.pregunta = flujo.siguientePregunta
            log.info datosPregunta.pregunta + " - " + datosPregunta.pregunta.getClass()
            def nuevasRespuestas = FlujoEtapaProcesal.findAllWhere(preguntaActual: datosPregunta.pregunta.getAt(0), tipoDeParte: tipoDeParte)
            datosPregunta.respuestas = nuevasRespuestas*.respuesta
        } else if(etapaProcesal && ultimaPregunta && respuestaPregunta == null){
            log.info "entra a 2"
            flujo = FlujoEtapaProcesal.findAllWhere(preguntaActual: ultimaPregunta, tipoDeParte: tipoDeParte)
            datosPregunta.pregunta = flujo.preguntaActual
            datosPregunta.respuestas = flujo*.respuesta
        } else if(etapaProcesal && ultimaPregunta == null && respuestaPregunta == null){
            log.info "entra a 4"
            flujo = FlujoEtapaProcesal.executeQuery("SELECT f FROM PreguntaEtapaProcesal p, FlujoEtapaProcesal f WHERE f.preguntaActual.id = p.id AND f.primerPregunta = true AND p.etapaProcesal.id = ? AND f.tipoDeParte.id IN (0," + tipoDeParte.id + ")",[etapaProcesal.id])
            datosPregunta.pregunta = flujo.preguntaActual
            datosPregunta.respuestas = flujo*.respuesta
        } else{
            log.info "entra a 3"
            etapaProcesal = EtapaProcesal.obtenerPrimerEtapa(tipoDeProcedimiento.id, tipoDeParte.id)
            flujo = FlujoEtapaProcesal.executeQuery("SELECT f FROM PreguntaEtapaProcesal p, FlujoEtapaProcesal f WHERE f.preguntaActual.id = p.id AND f.primerPregunta = true AND p.etapaProcesal.id = ? AND f.tipoDeParte.id IN (0," + tipoDeParte.id + ")",[etapaProcesal.id])
            datosPregunta.pregunta = flujo.preguntaActual
            datosPregunta.respuestas = flujo*.respuesta
        }
        log.info datosPregunta
        return datosPregunta
    }
    
    def obtenerColorPorEtapa(def juicio) {
        def resultado = []
        def sql = new Sql(dataSource)
        def preguntasDelJuicio = sql.rows("select count(distinct(fj.pregunta_atendida_id)) as preguntas, pep.etapa_procesal_id as etapa from flujo_juicio fj, pregunta_etapa_procesal pep where fj.juicio_id = $juicio.id and fj.pregunta_atendida_id = pep.id_pregunta_etapa_procesal group by pep.etapa_procesal_id having count(distinct(fj.pregunta_atendida_id)) > 0")
        def preguntasDelFlujo = sql.rows("select count(distinct(fep.pregunta_actual_id)) as preguntas, pep.etapa_procesal_id as etapa from flujo_etapa_procesal fep, pregunta_etapa_procesal pep, etapa_procesal ep where pep.etapa_procesal_id = ep.id_etapa_procesal and ep.tipo_de_procedimiento_id = $juicio.tipoDeProcedimiento.id and fep.tipo_de_parte_id in (0, $juicio.tipoDeParte.id) and fep.pregunta_actual_id = pep.id_pregunta_etapa_procesal group by pep.etapa_procesal_id having count(distinct(fep.pregunta_actual_id)) > 0")
        log.info "Preguntas del Juicio: " + preguntasDelJuicio
        log.info "Preguntas del Flujo: " + preguntasDelFlujo
        preguntasDelFlujo?.each { preguntaFlujo ->
            def fila = [:]
            fila.etapaProcesal = preguntaFlujo.etapa
            def busqueda = preguntasDelJuicio.find { it.find { key, value -> (key == 'etapa' && value == preguntaFlujo.etapa) } }
            if(busqueda){
                fila.color = ((preguntaFlujo.preguntas > busqueda.preguntas) ? "badge-warning" : "badge-primary")
            } else {
                fila.color = ""
            }
            resultado << fila
        }
        log.info resultado
        resultado
    }
    
    def preguntaConcluyeProcedimiento(def pregunta, def respuesta, def tipoDeParte){
        log.info "$pregunta?.id - $respuesta?.id - $tipoDeParte"
        log.info("pregunta -> " + pregunta + " | respuesta -> " + respuesta + " | tipoDeParte -> " + tipoDeParte)
        def flujo = FlujoEtapaProcesal.findWhere(preguntaActual: pregunta, respuesta: respuesta, tipoDeParte: tipoDeParte)
        log.info ("FLUJO -> " + flujo + " | TERMINA PROCEDIMIENTO? " + flujo.concluyeProcedimiento)
        return flujo.concluyeProcedimiento
    }
    
    def esPrimerPregunta(def pregunta){
        def flujo = FlujoEtapaProcesal.findWhere(preguntaActual: pregunta)
        return flujo.primerPregunta
    }
    
    def obtenerRespuestasPosibles(def pregunta, def tipoDeParte){
        def nuevasRespuestas = FlujoEtapaProcesal.findAllWhere(preguntaActual: pregunta, tipoDeParte: tipoDeParte)
        return nuevasRespuestas*.respuesta
    }
    
    def verificaTransferenciaJuicio(def listaDeJuicios, params){
        def reporte = []
        
        def idJuicio
        def juicioId
        def materia
        def materiaId
        def delegacion
        def delegacionId
        def estadoDeJuicio
        def estadoDeJuicioId
        def delegacionDestino
        def materiaDestino
        def estadoDeJuicioDestino
        
        def usuarioQueCambia
        def fechaActualizacion
        def fechaNueva
        DateFormat formato = new SimpleDateFormat("yyyy-MM-dd")
        
        boolean bandera
        int x = 2
        
        listaDeJuicios.each { archivoNuevo ->        
            try {
                log.info "ARCHIVO -> " + archivoNuevo
                
                InputStream is = archivoNuevo.archivo
                Workbook workbook = StreamingReader.builder()
                    .rowCacheSize(100)    // Numero de filas que mantiene en memoria (default de 10)
                    .bufferSize(4096)     // Tamaño del buffer para convertir el InputStream a archivo (default de 1024)
                    .open(is);            // InputStream or File for XLSX file (required)
                
                delegacionDestino = Delegacion.get(params.delegacionId)
                log.info "DELEGACION DESTINO -> " + delegacionDestino.id
                materiaDestino = Materia.get(params.materiaId)
                log.info "MATERIA DESTINO -> " + materiaDestino + " - " + materiaDestino.id
                estadoDeJuicioDestino = EstadoDeJuicio.get(params.transferirA)
                log.info "ESTADO DE JUICIO DESTINO -> " + estadoDeJuicioDestino + " - " + estadoDeJuicioDestino.id
                
                //usuarioQueCambia = springSecurityService.currentUser
                usuarioQueCambia = Usuario.find("from Usuario as u where u.delegacion=:delegacion and enabled=:habilitado and gerenteJuridico=:gerenteJuridico",
                                        [delegacion:delegacionDestino, habilitado:true, gerenteJuridico:true])
                log.info "USUARIO -> " + usuarioQueCambia + " | " + usuarioQueCambia.id
                fechaActualizacion = new Date()
                log.info "FECHA -> " + fechaActualizacion
                fechaNueva = formato.format(fechaActualizacion)
                log.info "FECHA FINAL -> " + fechaNueva
                
                for (Sheet hoja : workbook){
                    log.info "NOMBRE DE LA HOJA ->" + hoja.getSheetName()
                    for (Row fila : hoja) {
                        if(fila.getRowNum() != 0 && fila.getRowNum()){
                            def mapa = [:]
                            log.info "FILA  " + x 
                            bandera = false
                            
/* MATERIA */               Cell celdaMateria = fila.getCell(1)
                            materia = celdaMateria.getStringCellValue()
                            materiaId = Materia.findByNombre(materia?.replaceAll("\\s+", " "))
                            log.info "ID MATERIA -> " + materiaId.id

/* DELEGACION */            Cell celdaDelegacion = fila.getCell(2)
                            delegacion = celdaDelegacion.getStringCellValue()
                            delegacionId = Delegacion.findByNombre(delegacion?.replaceAll("\\s+", " "))
                            log.info "ID DELEGACION -> " + delegacionId.id
                        
/* ESTADO JUICIO */         Cell celdaEstadoDeJuicio = fila.getCell(6)
                            estadoDeJuicio = celdaEstadoDeJuicio.getStringCellValue()
                            estadoDeJuicioId = EstadoDeJuicio.findByNombre(estadoDeJuicio?.replaceAll("\\s+"," "))
                            log.info "ID ESTADO DE JUICIO -> " + estadoDeJuicioId.id
                        
/* ID JUICIO */             Cell celdaIdJuicio = fila.getCell(67)
                            idJuicio = celdaIdJuicio.getNumericCellValue()
                            juicioId = Juicio.findById(idJuicio)
                            log.info "ID JUICIO -> " + juicioId
                            x++
                            
                            switch(estadoDeJuicioDestino.id){
                                case 2:         // Transferir juicios a TERMINADO
                                    if(delegacionId.id == delegacionDestino.id){
                                        def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(juicioId.id, delegacionId)
                                        if(queryJuicioDelegacion){
                                            if(materiaId.id == materiaDestino.id){
                                                def queryJuicioMateria = Juicio.findByIdAndMateria(juicioId.id, materiaId)
                                                if(queryJuicioMateria){
                                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(juicioId.id, estadoDeJuicioId)
                                                    if (queryJuicioEstadoDeJuicio){
                                                        if(estadoDeJuicioId.id == 1 || estadoDeJuicioId.id == 5){
                                                            Juicio.executeUpdate("update Juicio j set j.estadoDeJuicio =:estadoDeJuicioDestino, j.terminadoPor =:usuario, j.fechaDeTermino =:fechaDeTermino where j.id =:idJuicio", 
                                                                [estadoDeJuicioDestino:estadoDeJuicioDestino, usuario:usuarioQueCambia, fechaDeTermino:fechaActualizacion, idJuicio:juicioId.id])
                                                            
                                                            log.info "* REGISTRO CON EL ID " + juicioId.id + " HA SIDO ACTUALIZADO *"
                                                            bandera = true
                                                        }
                                                        else{
                                                            log.info "EL JUICIO NO ESTA EN EL ESTADO DE JUICIO DE TERMINADO"
                                                        }
                                                    } else {
                                                        log.info "NO CORRESPONDEN ESTADO DE JUICIO" 
                                                    }
                                                } else {
                                                    log.info "NO ENTRO JUICIO-MATERIA"
                                                }
                                            } else {
                                                log.info "NO CORRESPONDEN MATERIAS"
                                            }
                                        } else {
                                            log.info "NO ENTRO JUICIO-DELEGACION"
                                        }
                                    } else {
                                        log.info "NO CORRESPONDEN DELEGACIONES"
                                    }
                                break;
                                case 6:         // Transferir juicios a ARCHIVO DEFINITIVO
                                    if(delegacionId.id == delegacionDestino.id){
                                        def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(juicioId.id, delegacionId)
                                        if(queryJuicioDelegacion){
                                            if(materiaId.id == materiaDestino.id){
                                                def queryJuicioMateria = Juicio.findByIdAndMateria(juicioId.id, materiaId)
                                                if(queryJuicioMateria){
                                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(juicioId.id, estadoDeJuicioId)
                                                    if (queryJuicioEstadoDeJuicio){
                                                        if(estadoDeJuicioId.id == 2){
                                                            Juicio.executeUpdate("update Juicio j set j.estadoDeJuicio =:estadoDeJuicioDestino where j.id =:idJuicio", 
                                                                [estadoDeJuicioDestino:estadoDeJuicioDestino, idJuicio:juicioId.id])
                                                            ControlJuicio.executeUpdate("update ControlJuicio cj set cj.archivadoPor =:usuario, cj.fechaDeArchivoDefinitivo =:fechaArchivoDefintivo where cj.juicio.id =:idJuicio",
                                                                [usuario:usuarioQueCambia, fechaArchivoDefintivo:fechaActualizacion, idJuicio:juicioId.id])
                                                            log.info "* REGISTRO CON EL ID " + juicioId.id + " HA SIDO ACTUALIZADO *"
                                                            bandera = true
                                                        }
                                                        else{
                                                            log.info "EL JUICIO NO ESTA EN EL ESTADO DE JUICIO DE TERMINADO"
                                                        }
                                                    } else {
                                                        log.info "NO CORRESPONDEN ESTADO DE JUICIO" 
                                                    }
                                                } else {
                                                    log.info "NO ENTRO JUICIO-MATERIA"
                                                }
                                            } else {
                                                log.info "NO CORRESPONDEN MATERIAS"
                                            }
                                        } else {
                                            log.info "NO ENTRO JUICIO-DELEGACION"
                                        }
                                    } else {
                                        log.info "NO CORRESPONDEN DELEGACIONES"
                                    }
                                break;
                                case 7:         // Transferir juicios a ARCHIVO HISTORICO
                                    if(delegacionId.id == delegacionDestino.id){
                                        def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(juicioId.id, delegacionId)
                                        if(queryJuicioDelegacion){
                                            if(materiaId.id == materiaDestino.id){
                                                def queryJuicioMateria = Juicio.findByIdAndMateria(juicioId.id, materiaId)
                                                if(queryJuicioMateria){
                                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(juicioId.id, estadoDeJuicioId)
                                                    if (queryJuicioEstadoDeJuicio){
                                                        if(estadoDeJuicioId.id == 6){
                                                            Juicio.executeUpdate("update Juicio j set j.estadoDeJuicio =:estadoDeJuicioDestino where j.id =:idJuicio", 
                                                                [estadoDeJuicioDestino:estadoDeJuicioDestino, idJuicio:juicioId.id])
                                                            ControlJuicio.executeUpdate("update ControlJuicio cj set cj.enviadoHistoricoPor =:usuario, cj.fechaDeArchivoHistorico =:fechaDeArchivoHistorico where cj.juicio.id =:idJuicio",
                                                                [usuario:usuarioQueCambia, fechaDeArchivoHistorico:fechaActualizacion, idJuicio:juicioId.id])
                                                            log.info "* REGISTRO CON EL ID " + juicioId.id + " HA SIDO ACTUALIZADO *"
                                                            bandera = true
                                                        }
                                                        else{
                                                            log.info "EL JUICIO NO ESTA EN EL ESTADO DE JUICIO DE ARCHIVO DEFINTIVO"
                                                        }
                                                    } else {
                                                        log.info "NO CORRESPONDEN ESTADO DE JUICIO" 
                                                    }
                                                } else {
                                                    log.info "NO ENTRO JUICIO-MATERIA"
                                                }
                                            } else {
                                                log.info "NO CORRESPONDEN MATERIAS"
                                            }
                                        } else {
                                            log.info "NO ENTRO JUICIO-DELEGACION"
                                        }
                                    } else {
                                        log.info "NO CORRESPONDEN DELEGACIONES"
                                    }
                                break;
                                default:
                                    log.info "NO ENTRO EN NINGUNA OPCION ELEGIBLE"
                                break;
                            }
                            if (bandera == false){ 
                                mapa.materiaId = materiaId
                                mapa.delegacionId = delegacionId
                                mapa.estadoDeJuicioId = estadoDeJuicioId
                                mapa.juicioId = juicioId

                                reporte << mapa
                            }
                        }
                    }
                }
            } catch(Exception e){
                    e.printStackTrace()
                    respuesta.errorMessage = ("Excepción: " + e.getMessage())
                    respuesta.statusCode = 500
            }
        }
        log.info "ESTE ES EL REPORTE -> " + reporte
        return reporte
    }

/*    def verificaTransferenciaJuicio(def listaDeJuicios, params){
        def reporte = []
        def x = 0
        boolean bandera
        log.info "Parámetros de la vista -> " + params 
        listaDeJuicios.each{
            if(x > 0){
                bandera = false
                def resultado = [:]
                resultado.tieneJuicio = 'false'
                log.info ""
                log.info "VALORES A ANALIZAR -> " + it
                def idJuicio = it[0]?.trim()
                idJuicio = Juicio.get(idJuicio?.replaceAll("\\s+", " ") as long)
                log.info "ID ASUNTO -> " + idJuicio.id
                def materia = it[2]?.trim()
                materia = Materia.findByNombre(materia?.replaceAll("\\s+", " "))
                log.info "MATERIA -> " + materia + " - " + materia.id
                def delegacion = it[3]?.trim()
                delegacion = Delegacion.get(delegacion?.replaceAll("\\s+", " ")as long) 
                log.info "DELEGACION -> " + delegacion
                def estadoDeJuicio = it[8]?.trim()
                estadoDeJuicio = EstadoDeJuicio.findByNombre(estadoDeJuicio?.replaceAll("\\s+"," "))
                log.info "ESTADO DE JUICIO -> " + estadoDeJuicio + " - " + estadoDeJuicio.id
                def delegacionDestino = Delegacion.get(params.delegacionId)
                log.info "DELEGACION DESTINO -> " + delegacionDestino 
                def materiaDestino = Materia.get(params.materiaId)
                log.info "MATERIA DESTINO -> " + materiaDestino + " - " + materiaDestino.id
                def estadoDeJuicioDestino = EstadoDeJuicio.get(params.transferirA)
                log.info "ESTADO DE JUICIO DESTINO -> " + estadoDeJuicioDestino + " - " + estadoDeJuicioDestino.id
                
                switch(estadoDeJuicioDestino.id){
                case 6:         // Transferir juicios a ARCHIVO DEFINITIVO
                    if(delegacion.id == delegacionDestino.id){
                        def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(idJuicio.id, delegacion)
                        if(queryJuicioDelegacion){
                            if(materia.id == materiaDestino.id){
                                def queryJuicioMateria = Juicio.findByIdAndMateria(idJuicio.id, materia)
                                if(queryJuicioMateria){
                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(idJuicio.id, estadoDeJuicio)
                                    if (queryJuicioEstadoDeJuicio){
                                        if(estadoDeJuicio.id == 5){
                                            Juicio.executeUpdate("update Juicio j set j.estadoDeJuicio =:estadoDeJuicioDestino where j.id =:idJuicio", 
                                                [estadoDeJuicioDestino:estadoDeJuicioDestino, idJuicio:idJuicio.id])
                                            log.info "* REGISTRO CON EL ID " + idJuicio.id + " HA SIDO ACTUALIZADO *"
                                            bandera = true
                                        }
                                        else{
                                            log.info "EL JUICIO NO ESTA EN EL ESTADO DE JUICIO DE WF COMPLETADO"
                                        }
                                    }
                                    else{
                                        log.info "NO ENCONTRO EL ESTADO DE MATERIA EN EL JUICIO"
                                    }
                                }
                                else{
                                    log.info "NO ENCONTRO LA MATERIA EN EL JUICIO"
                                }
                            }
                            else{
                                log.info "NO CORRESPONDEN LAS MATERIAS"
                            }
                        }
                        else{
                            log.info "NO ENCONTRO LA DELEGACION EN EL JUICIO"
                        }
                    }
                    else{
                        log.info "NO CORRESPONDEN LAS DELEGACIONES"
                    }
                    break
                case 7:         // Transferir juicios a ARCHIVO HISTORICO
                    if(delegacion.id == delegacionDestino.id){
                        def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(idJuicio.id, delegacion)
                        if(queryJuicioDelegacion){
                            if(materia.id == materiaDestino.id){
                                def queryJuicioMateria = Juicio.findByIdAndMateria(idJuicio.id, materia)
                                if(queryJuicioMateria){
                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(idJuicio.id, estadoDeJuicio)
                                    if (queryJuicioEstadoDeJuicio){
                                        if(estadoDeJuicio.id == 6){
                                            Juicio.executeUpdate("update Juicio j set j.estadoDeJuicio =:estadoDeJuicioDestino where j.id =:idJuicio", 
                                                [estadoDeJuicioDestino:estadoDeJuicioDestino, idJuicio:idJuicio.id])
                                            log.info "* REGISTRO CON EL ID " + idJuicio.id + " HA SIDO ACTUALIZADO *"
                                            bandera = true
                                        }
                                        else{
                                            log.info "EL JUICIO NO ESTA EN EL ESTADO DE JUICIO DE ARCHIVO DEFINITIVO"
                                        }
                                    }
                                    else{
                                        log.info "NO ENCONTRO EL ESTADO DE MATERIA EN EL JUICIO"
                                    }
                                }
                                else{
                                    log.info "NO ENCONTRO LA MATERIA EN EL JUICIO"
                                }
                            }
                            else{
                                log.info "NO CORRESPONDEN LAS MATERIAS"
                            }
                        }
                        else{
                            log.info "NO ENCONTRO LA DELEGACION EN EL JUICIO"
                        }
                    }
                    else{
                        log.info "NO CORRESPONDEN LAS DELEGACIONES"
                    }
                    break
                default:        // No entro en ninguna opción elegible
                    break
                }
            }
            x++
            if (bandera == false){ 
                reporte << it
                log.info "ESTE ES EL REPORTE -> " + reporte
            }
        }
        return reporte
    }*/    
    
    def verificaReasignacionJuicio(def listaDeJuicios, params){
        def reporte = []
        
        def opcion
        def idJuicio
        def juicioId
        def materia
        def materiaId
        def delegacion
        def delegacionId
        def estadoDeJuicio
        def estadoDeJuicioId
        def despacho
        def despachoId
        def expediente
        def expedienteId
        def expedienteInterno
        def expedienteInternoId
        
        def delegacionOrigen
        def delegacionDestino
        def despachoOrigen
        def despachoDestino
        
        boolean bandera
        int x = 2
        
        listaDeJuicios.each { archivoNuevo ->        
            try {
                log.info "ARCHIVO -> " + archivoNuevo
                
                InputStream is = archivoNuevo.archivo
                Workbook workbook = StreamingReader.builder()
                    .rowCacheSize(100)    // Numero de filas que mantiene en memoria (default de 10)
                    .bufferSize(4096)     // Tamaño del buffer para convertir el InputStream a archivo (default de 1024)
                    .open(is);            // InputStream or File for XLSX file (required)
                
                log.info "PARAMS -> " + params 
                
                delegacionOrigen = Delegacion.get(params.delegacionOrigen)
                log.info "DELEGACION ORIGEN -> " + delegacionOrigen.id
                delegacionDestino = Delegacion.get(params.delegacionDestino)
                log.info "DELEGACION DESTINO -> " + delegacionDestino.id
                despachoOrigen = Despacho.get(params.despachoOrigen)
                log.info "DESPACHO ORIGEN -> " + despachoOrigen.id 
                despachoDestino = Despacho.get(params.despachoDestino)
                log.info "DESPACHO DESTINO -> " + despachoDestino.id
                opcion = params.opcion as int
                log.info "OPCION ELEGIDA -> " + opcion
                
                for (Sheet hoja : workbook){
                    log.info "NOMBRE DE LA HOJA ->" + hoja.getSheetName()
                    for (Row fila : hoja) {
                        if(fila.getRowNum() != 0 && fila.getRowNum()){
                            def mapa = [:]
                            log.info "FILA  " + x 
                            bandera = false
                            
/* MATERIA */               Cell celdaMateria = fila.getCell(1)
                            materia = celdaMateria.getStringCellValue()
                            materiaId = Materia.findByNombre(materia?.replaceAll("\\s+", " "))
                            log.info "ID MATERIA -> " + materiaId.id

/* DELEGACION */            Cell celdaDelegacion = fila.getCell(2)
                            delegacion = celdaDelegacion.getStringCellValue()
                            delegacionId = Delegacion.findByNombre(delegacion?.replaceAll("\\s+", " "))
                            log.info "ID DELEGACION -> " + delegacionId.id

/* EXPEDIENTE INTERNO */    Cell celdaExpedienteInterno = fila.getCell(3)
                            expedienteInterno = celdaExpedienteInterno.getStringCellValue()
                            expedienteInternoId = Juicio.findByExpedienteInterno(expedienteInterno?.replaceAll("\\s+", " "))
                            log.info "EXPEDIENTE INTERNO -> " + expedienteInternoId.expedienteInterno
                            
/* EXPEDIENTE */            Cell celdaExpediente = fila.getCell(4)
                            expediente = celdaExpediente.getStringCellValue()
                            expedienteId = Juicio.findByExpediente(expediente?.replaceAll("\\s+", " "))
                            log.info "EXPEDIENTE -> " + expedienteId.expediente
                            
/* ESTADO JUICIO */         Cell celdaEstadoDeJuicio = fila.getCell(6)
                            estadoDeJuicio = celdaEstadoDeJuicio.getStringCellValue()
                            estadoDeJuicioId = EstadoDeJuicio.findByNombre(estadoDeJuicio?.replaceAll("\\s+"," "))
                            log.info "ID ESTADO DE JUICIO -> " + estadoDeJuicioId.id

/* DESPACHO */              Cell celdaDespacho = fila.getCell(13)
                            despacho = celdaDespacho.getStringCellValue()
                            despachoId = Despacho.findByNombre(despacho)
                            log.info "ID DESPACHO -> " + despachoId.id
                        
/* ID JUICIO */             Cell celdaIdJuicio = fila.getCell(67)
                            idJuicio = celdaIdJuicio.getNumericCellValue()
                            juicioId = Juicio.findById(idJuicio)
                            log.info "ID JUICIO -> " + juicioId.id
                            
                            x++
                            
                            switch(opcion){
                                case 1:         // Despacho a Despacho Bloque (Reasignar los juicios de un despacho a otro)
                                    if (delegacionId.id == delegacionOrigen.id){
                                        def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(juicioId.id, delegacionId)
                                        if(queryJuicioDelegacion){
                                            def queryJuicioDespacho = Juicio.findByIdAndDespacho(juicioId.id, despachoOrigen)
                                            if(queryJuicioDespacho){
                                                if(estadoDeJuicioId.id == 1 || estadoDeJuicioId.id == 2 || estadoDeJuicioId.id == 5){
                                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(juicioId.id, estadoDeJuicioId)
                                                    if(queryJuicioEstadoDeJuicio){
                                                        def queryJuicioMateria = Juicio.findByIdAndMateria(juicioId.id, materiaId)
                                                        if(queryJuicioMateria){
                                                            def queryJuicioExpediente = Juicio.findByIdAndExpediente(juicioId.id, expedienteId.expediente)
                                                            if(queryJuicioExpediente){
                                                                def queryJuicioExpedienteInterno = Juicio.findByIdAndExpedienteInterno(juicioId.id, expedienteInternoId.expedienteInterno)
                                                                if(queryJuicioExpedienteInterno){
                                                                    Juicio.executeUpdate("update Juicio j set j.despacho =:despachoDestino, j.delegacion =:delegacionDestino where j.id =:idJuicio", 
                                                                        [despachoDestino:despachoDestino, delegacionDestino:delegacionDestino, idJuicio:juicioId.id])
                                                                    log.info "* REGISTRO CON EL ID " + juicioId.id + " HA SIDO ACTUALIZADO *"
                                                                    bandera = true
                                                                } else {
                                                                    log.info "NO ENCONTRO JUICIO-EXPEDIENTE INTERNO"
                                                                }
                                                            } else {
                                                                log.info "NO ENTRO JUICIO-EXPEDIENTE"
                                                            }
                                                        } else {
                                                            log.info "NO ENTRO JUICIO-MATERIA"
                                                        }
                                                    } else {
                                                        log.info "NO ENTRO JUICIO-ESTADO DE JUICIO"
                                                    }
                                                } else {
                                                    log.info "NO ES UN ESTADO DE JUICIO VALIDO"
                                                }
                                            } else {
                                                log.info "NO ENTRO JUICIO-DESPACHO"
                                            }
                                        } else {
                                            log.info "NO ENTRO JUICIO-DELEGACION"
                                        }
                                    } else {
                                        log.info "NO CORRESPONDEN LAS DELEGACIONES"
                                    }
                                break;
                                case 3:         // Delegación a Delegación SIN DESPACHO (Reasignar los juicios que no tengan un despacho asignado de una delegación a otra) 
                                    if(delegacionOrigen.id != delegacionDestino.id){
                                        if(despachoId.id <= -2){
                                            def queryJuicioDespacho = Juicio.findByIdAndDespacho(juicioId.id, despachoOrigen)
                                            if(queryJuicioDespacho){
                                                def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(juicioId.id, delegacionId)
                                                if(queryJuicioDelegacion){
                                                    if(estadoDeJuicioId.id == 1 || estadoDeJuicioId.id == 2 || estadoDeJuicioId.id == 5){
                                                        def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(juicioId.id, estadoDeJuicioId)
                                                        if(queryJuicioEstadoDeJuicio){
                                                            def queryJuicioMateria = Juicio.findByIdAndMateria(juicioId.id, materiaId)
                                                            if(queryJuicioMateria){
                                                                def queryJuicioExpediente = Juicio.findByIdAndExpediente(juicioId.id, expedienteId.expediente)
                                                                if(queryJuicioExpediente){
                                                                    def queryJuicioExpedienteInterno = Juicio.findByIdAndExpedienteInterno(juicioId.id, expedienteInternoId.expedienteInterno)
                                                                    if(queryJuicioExpedienteInterno){
                                                                        Juicio.executeUpdate("update Juicio j set j.despacho =:despachoDestino, j.delegacion =:delegacionDestino where j.id =:idJuicio", 
                                                                            [despachoDestino:despachoDestino, delegacionDestino:delegacionDestino, idJuicio:juicioId.id])
                                                                        log.info "* REGISTRO CON EL ID " + juicioId.id + " HA SIDO ACTUALIZADO *"
                                                                        bandera = true
                                                                    } else {
                                                                        log.info "NO ENTRO JUICIO-EXPEDIENTE INTERNO"
                                                                    }
                                                                } else {
                                                                    log.info "NO ENTRO JUICIO-EXPEDIENTE"
                                                                }
                                                            } else {
                                                                log.info "NO ENTRO JUICIO-MATERIA"
                                                            }   
                                                        } else {
                                                            log.info "NO ENTRO JUICIO-ESTADO DE JUICIO"
                                                        }
                                                    } else {
                                                        log.info "NO ES UN ESTADO DE JUICIO VALIDO"
                                                    }
                                                } else {
                                                    log.info "NO ENTRO JUICIO-DELEGACION"
                                                }
                                            } else {
                                                log.info "NO ENTRO JUICO-DESPACHO"
                                            }
                                        } else {
                                            log.info "TIENE ASIGNADO UN DESPACHO"
                                        }
                                    } else {
                                        log.info "SON LAS MISMAS DELEGACIONES."
                                    }
                                break;
                                case 4:         // Delegación SIN DESPACHO a Delegación con despacho seleccionado (Reasignar los juicios que no tienen un despacho asignado, al despacho seleccionado)
                                    if(despachoId.id <= -2){
                                        def queryJuicioDespacho = Juicio.findByIdAndDespacho(juicioId.id, despachoOrigen)
                                        if(queryJuicioDespacho){
                                            def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(juicioId.id, delegacionId)
                                            if(queryJuicioDelegacion){
                                                if(estadoDeJuicioId.id == 1 || estadoDeJuicioId.id == 2 || estadoDeJuicioId.id == 5){
                                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(juicioId.id, estadoDeJuicioId)
                                                    if(queryJuicioEstadoDeJuicio){
                                                        def queryJuicioMateria = Juicio.findByIdAndMateria(juicioId.id, materiaId)
                                                        if(queryJuicioMateria){
                                                            def queryJuicioExpediente = Juicio.findByIdAndExpediente(juicioId.id, expedienteId.expediente)
                                                            if(queryJuicioExpediente){
                                                                def queryJuicioExpedienteInterno = Juicio.findByIdAndExpedienteInterno(juicioId.id, expedienteInternoId.expedienteInterno)
                                                                if(queryJuicioExpedienteInterno){
                                                                    Juicio.executeUpdate("update Juicio j set j.despacho =:despachoDestino, j.delegacion =:delegacionDestino where j.id =:idJuicio", 
                                                                        [despachoDestino:despachoDestino, delegacionDestino:delegacionDestino, idJuicio:juicioId.id])
                                                                    log.info "* REGISTRO CON EL ID " + juicioId.id + " HA SIDO ACTUALIZADO *"
                                                                    bandera = true
                                                                } else {
                                                                    log.info "NO ENTRO JUICIO-EXPEDIENTE INTERNO"
                                                                }
                                                            } else {
                                                                log.info "NO ENTRO JUICIO-EXPEDIENTE"
                                                            }
                                                        } else {
                                                            log.info "NO ENTRO JUICIO-MATERIA"
                                                        }   
                                                    } else {
                                                        log.info "NO ENTRO JUICIO-ESTADO DE JUICIO"
                                                    }
                                                } else {
                                                    log.info "NO ES UN ESTADO DE JUICIO VALIDO"
                                                }
                                            } else {
                                                log.info "NO ENTRO JUICIO-DELEGACION"
                                            }
                                        } else {
                                            log.info "NO ENTRO JUICIO-DESPACHO"
                                        }
                                    } else {
                                        log.info "TIENE DESPACHO ASIGNADO"
                                    }
                                break;
                                default:
                                    log.info "NO ENTRO EN NINGUNA OPCION ELEGIBLE"
                                break;
                            }
                            if (bandera == false){ 
                                mapa.materiaId = materiaId
                                mapa.delegacionId = delegacionId
                                mapa.estadoDeJuicioId = estadoDeJuicioId
                                mapa.juicioId = juicioId

                                reporte << mapa
                            }
                        }
                    }
                }
            } catch(Exception e){
                    e.printStackTrace()
                    respuesta.errorMessage = ("Excepción: " + e.getMessage())
                    respuesta.statusCode = 500
            }
        }
        log.info "ESTE ES EL REPORTE -> " + reporte
        return reporte
    }

/*    def verificaReasignacionJuicio(def listaDeJuicios, params){
        def reporte = []
        def x = 0
        def b
        boolean bandera
        log.info "Parámetros de la vista -> " + params
        listaDeJuicios.each{
            if (x > 0){
                bandera = false
                def resultado = [:]
                resultado.tieneJuicio = 'false'
                log.info ""
                log.info "VALORES A ANALIZAR -> " + it
                def idJuicio = it[0]?.trim()
                idJuicio = Juicio.get(idJuicio?.replaceAll("\\s+", " ") as long)
                log.info "ID ASUNTO -> " + idJuicio.id
                def delegacion = it[3]?.trim()
                delegacion = Delegacion.get(delegacion?.replaceAll("\\s+", " ")as long) 
                log.info "DELEGACION -> " + delegacion.id   
                def estadoDeJuicio = it[8]?.trim()
                estadoDeJuicio = EstadoDeJuicio.findByNombre(estadoDeJuicio?.replaceAll("\\s+"," "))
                log.info "ESTADO DE JUICIO -> " + estadoDeJuicio
                def materia = it[2]?.trim()
                materia = Materia.findByNombre(materia?.replaceAll("\\s+", " "))
                log.info "MATERIA -> " + materia
                def despacho = it[15]?.trim()
                despacho = Despacho.findByNombre(despacho?.replaceAll("\\s+", " "))
                log.info "DESPACHO -> " + despacho.id           
                def expedienteInterno = it[5]?.trim()
                expedienteInterno = Juicio.findByExpedienteInterno(expedienteInterno?.replaceAll("\\s+", " "))
                log.info "EXPEDIENTE INTERNO -> " + expedienteInterno.expedienteInterno
                def expediente = it [6]?.trim()
                expediente = Juicio.findByExpediente(expediente?.replaceAll("\\s+", " "))
                log.info "EXPEDIENTE -> " + expediente.expediente
                def delegacionOrigen = Delegacion.get(params.delegacionOrigen)
                log.info "DELEGACION ORIGEN -> " + delegacionOrigen
                def despachoOrigen = Despacho.get(params.despachoOrigen)
                log.info "DESPACHO ORIGEN -> " + despachoOrigen
                def delegacionDestino = Delegacion.get(params.delegacionDestino)
                log.info "DELEGACION DESTINO -> " + delegacionDestino
                def despachoDestino = Despacho.get(params.despachoDestino)
                log.info "DESPACHO DESTINO -> " + despachoDestino
                def opcion = params.opcion as int
                log.info "OPCION ELEGIDA -> " + opcion
                
                switch(opcion){
                case 1:     // Despacho a Despacho Bloque (Reasignar los juicios de un despacho a otro)
                    if (delegacion.id == delegacionOrigen.id){
                        def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(idJuicio.id, delegacion)
                        if(queryJuicioDelegacion){
                            if(estadoDeJuicio.id >=1 && estadoDeJuicio.id <= 5){
                                def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(idJuicio.id, estadoDeJuicio)
                                if(queryJuicioEstadoDeJuicio){
                                    def queryJuicioMateria = Juicio.findByIdAndMateria(idJuicio.id, materia)
                                    if(queryJuicioMateria){
                                        def queryJuicioExpediente = Juicio.findByIdAndExpediente(idJuicio.id, expediente.expediente)
                                        if(queryJuicioExpediente){
                                            def queryJuicioExpedienteInterno = Juicio.findByIdAndExpedienteInterno(idJuicio.id, expedienteInterno.expedienteInterno)
                                            if(queryJuicioExpedienteInterno){
                                                Juicio.executeUpdate("update Juicio j set j.despacho =:despachoDestino, j.delegacion =:delegacionDestino where j.id =:idJuicio", 
                                                    [despachoDestino:despachoDestino, delegacionDestino:delegacionDestino, idJuicio:idJuicio.id])
                                                log.info "* REGISTRO CON EL ID " + idJuicio.id + " HA SIDO ACTUALIZADO *"
                                                bandera = true
                                            }
                                            else{
                                                log.info "NO ENCONTRO EL EXPEDIENTE INTERNO"
                                            }
                                        }
                                        else{
                                            log.info "NO ENCONTRO EL EXPEDIENTE"
                                        }
                                    }
                                    else{
                                        log.info "NO ENCONTRO LA MATERIA"
                                    }
                                }
                                else{
                                    log.info "NO ENCONTRO EL ESTADO DEL JUICIO"
                                }
                            }
                            else{
                                log.info "NO ES UN ESTADO DE JUICIO VALIDO"
                            }
                        }
                        else{
                            log.info "NO ENCONTRO LA DELEGACION EN EL JUICIO"
                        }
                    }
                    else{
                        log.info "NO CORRESPONDEN LAS DELEGACIONES"
                    }
                    break
                case 3:     // Delegación a Delegación SIN DESPACHO (Reasignar los juicios que no tengan un despacho asignado de una delegación a otra)         
                    if(delegacionOrigen.id != delegacionDestino.id){
                        if(despacho.id <= -2){
                            if (delegacion.id == delegacionOrigen.id){
                                def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(idJuicio.id, delegacion)
                                if(queryJuicioDelegacion){
                                    if(estadoDeJuicio.id >=1 && estadoDeJuicio.id <= 5){
                                        def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(idJuicio.id, estadoDeJuicio)
                                        if(queryJuicioEstadoDeJuicio){
                                            def queryJuicioMateria = Juicio.findByIdAndMateria(idJuicio.id, materia)
                                            if(queryJuicioMateria){
                                                def queryJuicioExpediente = Juicio.findByIdAndExpediente(idJuicio.id, expediente.expediente)
                                                if(queryJuicioExpediente){
                                                    def queryJuicioExpedienteInterno = Juicio.findByIdAndExpedienteInterno(idJuicio.id, expedienteInterno.expedienteInterno)
                                                    if(queryJuicioExpedienteInterno){
                                                        Juicio.executeUpdate("update Juicio j set j.delegacion =:delegacionDestino where j.id =:idJuicio", 
                                                            [delegacionDestino:delegacionDestino, idJuicio:idJuicio.id])
                                                        log.info "* REGISTRO CON EL ID " + idJuicio.id + " HA SIDO ACTUALIZADO *"
                                                        bandera = true
                                                    }
                                                    else{
                                                        log.info "NO ENCONTRO EL EXPEDIENTE INTERNO"
                                                    }
                                                }
                                                else{
                                                    log.info "NO ENCONTRO EL EXPDIENTE"
                                                }
                                            }
                                            else{
                                                log.info "NO ENCONTRO LA MATERIA"
                                            }
                                        }
                                        else{
                                            log.info "NO ENCONTRO EL ESTADO DEL JUICIO"
                                        }
                                    }
                                    else{
                                        log.info "NO CORRESPONDE EL ESTADO DEL JUICIO"
                                    }
                                }
                                else{
                                    log.info "NO ENCONTRO LA DELEGACION"
                                }
                            }
                            else{
                                log.info "NO CORRESPONDEN LAS DELEGACIONES"
                            }
                        }
                        else{
                            log.info "NO CORRESPONDE A UN JUICIO SIN DESPACHO"
                        }
                    }
                    else{
                        log.info "NO CORRESPONDEN LAS DELEGACIONES"
                    }
                    break
                case 4:     // Delegación a Despacho (Reasignar los juicios que no tienen un despacho asignado, al despacho seleccionado)
                    if(despacho.id <= -2){
                        def queryJuicioDespacho = Juicio.findByIdAndDespacho(idJuicio.id, despacho)
                        if (delegacion.id == delegacionOrigen.id){
                            def queryJuicioDelegacion = Juicio.findByIdAndDelegacion(idJuicio.id, delegacion)
                            if(queryJuicioDelegacion){
                                if(estadoDeJuicio.id >=1 && estadoDeJuicio.id <= 5){
                                    def queryJuicioEstadoDeJuicio = Juicio.findByIdAndEstadoDeJuicio(idJuicio.id, estadoDeJuicio)
                                    if(queryJuicioEstadoDeJuicio){
                                        def queryJuicioMateria = Juicio.findByIdAndMateria(idJuicio.id, materia)
                                        if(queryJuicioMateria){
                                            def queryJuicioExpediente = Juicio.findByIdAndExpediente(idJuicio.id, expediente.expediente)
                                            if(queryJuicioExpediente){
                                                def queryJuicioExpedienteInterno = Juicio.findByIdAndExpedienteInterno(idJuicio.id, expedienteInterno.expedienteInterno)
                                                if(queryJuicioExpedienteInterno){
                                                    Juicio.executeUpdate("update Juicio j set j.despacho =:despachoDestino, j.delegacion =:delegacionDestino where j.id =:idJuicio", 
                                                        [despachoDestino:despachoDestino, delegacionDestino:delegacionDestino, idJuicio:idJuicio.id])
                                                    log.info "* REGISTRO CON EL ID " + idJuicio.id + " HA SIDO ACTUALIZADO *"
                                                    bandera = true
                                                }
                                                else{
                                                    log.info "NO ENCONTRO EL EXPEDIENTE INTERNO"
                                                }
                                            }
                                            else{
                                                log.info "NO ENCONTRO EL EXPEDIENTE"
                                            }
                                        }
                                        else{
                                            log.info "NO ENCONTRO LA MATERIA"
                                        }
                                    }
                                    else{
                                        log.info "NO ENCONTRO EL ESTADO DE JUICIO"
                                    }
                                }
                                else{
                                    log.info "NO CORRESPONDE EL ESTADO DE JUICIO"
                                }
                            }
                            else{
                                log.info "NO ENCONTRO LA DELEGACION"
                            }
                        }
                        else{
                            log.info "NO CORRESPONDEN LAS DELEGACIONES"
                        }  
                    }
                    else{
                        log.info "NO CORRESPONDE A UN JUICIO SIN DESPACHO"
                    }
                    break
                default:    // Ninguna opción indicada
                    break
                }
            }
            x++
            if (bandera == false){ 
                reporte << it
            }
        }
        log.info "ESTE ES EL REPORTE -> " + reporte
        return reporte
    }*/
    
    def verificarNombre(def listaDePersonas){
        def lista = []
        def x = 0;
        def nssVacio = false
        listaDePersonas.each {
            if(x > 0) {
                def resultado = [:]
                resultado.tieneJuicio = 'false'
                log.info it
                def tipoDeParte = TipoDeParte.get(5)
                def nombre = it[0]?.trim()
                nombre = nombre?.replaceAll("\\s+", " ")
                def apellidoPaterno = it[1]?.trim()
                apellidoPaterno = apellidoPaterno?.replaceAll("\\s+", " ")
                def apellidoMaterno = it[2]?.trim()
                apellidoMaterno = apellidoMaterno?.replaceAll("\\s+", " ")
                def persona = Persona.findWhere(nombre:nombre, apellidoPaterno:apellidoPaterno, apellidoMaterno:apellidoMaterno)
                if(persona){
                    def actor = ActorJuicio.findAllWhere(persona: persona, tipoDeParte: tipoDeParte)//ActorJuicio.executeQuery("from ActorJuicio aj where (aj.persona.nombre||''||aj.persona.apellidoPaterno||''||aj.persona.apellidoMaterno) = '"+nombreCompleto+"' order by aj.persona.nombre")
                    resultado.persona = persona
                    resultado.tipoDeParte = tipoDeParte
                    resultado.exito = 'true'
                    if(actor){
                        resultado.tieneJuicio = 'true'
                        resultado.mensaje = generarInfoJuicio(actor*.juicio)
                    } else {
                        resultado.tieneJuicio = 'false'   
                    }
                } else {
                    def nss = it[3]?.trim()
                    def rfc = it[4]?.trim()
                    def cantidadDemandada = (it[5]?.trim() ?: 0)
                    if(nss) {
                        def existeNss = Persona.findWhere(numeroSeguroSocial: nss)
                        if(existeNss){
                            resultado.persona = existeNss
                            resultado.nssYaRegistrado = 'true'
                            resultado.cantidadDemandada = cantidadDemandada
                            resultado.mensaje = "El NSS <strong>" + nss + "</strong> ya está registrado con otro actor. (Ver línea <strong>" + (x+1) + "</strong> del archivo)"
                        } else {
                            log.info "RFC -> " + rfc
                            if(rfc.empty){
                                log.info "RFC VACIO"
                                def nuevaPersona =  new Persona()
                                nuevaPersona.nombre = nombre?.toUpperCase()
                                nuevaPersona.apellidoPaterno = apellidoPaterno?.toUpperCase()
                                nuevaPersona.apellidoMaterno = apellidoMaterno?.toUpperCase()
                                nuevaPersona.numeroSeguroSocial = nss
                                nuevaPersona.rfc = rfc
                                nuevaPersona.tipoDePersona = TipoDePersona.get(1)
                                resultado.persona = nuevaPersona
                                resultado.tipoDeParte = tipoDeParte
                                resultado.tieneJuicio = 'false'
                                resultado.cantidadDemandada = cantidadDemandada
                                if(nuevaPersona.save(flush:true)){
                                    log.info "GUARDO A LA PERSONA"
                                    resultado.registrada = 'true'
                                } else{
                                    log.info "NO GUARDO A LA PERSONA"
                                    resultado.registrada = 'false'
                                    resultado.mensaje = "El actor <strong>" + nuevaPersona.nombre + " " + nuevaPersona.apellidoPaterno + " " + nuevaPersona.apellidoMaterno + "</strong> no se registró correctamente. (Ver línea <strong>" + (x+1) + "</strong> del archivo)"
                                }
                            } else {
                                log.info "RFC NO VACIO"
                                def existeRfc = Persona.findWhere(rfc: rfc)
                                if(existeRfc){
                                    log.info "RFC EXISTENTE"
                                    resultado.persona = existeRfc
                                    resultado.rfcYaRegistrado = 'true'
                                    resultado.cantidadDemandada = cantidadDemandada
                                    resultado.mensaje = "El RFC <strong>" + rfc + "</strong> ya está registrado con otro actor. (Ver línea <strong>" + (x+1) + "</strong> del archivo)"
                                } else {
                                    def nuevaPersona =  new Persona()
                                    nuevaPersona.nombre = nombre?.toUpperCase()
                                    nuevaPersona.apellidoPaterno = apellidoPaterno?.toUpperCase()
                                    nuevaPersona.apellidoMaterno = apellidoMaterno?.toUpperCase()
                                    nuevaPersona.numeroSeguroSocial = nss
                                    nuevaPersona.rfc = rfc
                                    nuevaPersona.tipoDePersona = TipoDePersona.get(1)
                                    resultado.persona = nuevaPersona
                                    resultado.tipoDeParte = tipoDeParte
                                    resultado.tieneJuicio = 'false'
                                    resultado.cantidadDemandada = cantidadDemandada
                                    if(nuevaPersona.save(flush:true)){
                                        log.info "GUARDO A LA PERSONA"
                                        resultado.registrada = 'true'
                                    } else{
                                        log.info "NO GUARDO A LA PERSONA"
                                        resultado.registrada = 'false'
                                        resultado.mensaje = "El actor <strong>" + nuevaPersona.nombre + " " + nuevaPersona.apellidoPaterno + " " + nuevaPersona.apellidoMaterno + "</strong> no se registró correctamente. (Ver línea <strong>" + (x+1) + "</strong> del archivo)"
                                    }
                                }
                            }
                        }
                    } else {
                        resultado.nssVacio = 'true'
                        resultado.mensaje = "El NSS es un dato obligatorio. (Ver línea <strong>" + (x+1) + "</strong> del archivo)"
                    }
                }
                lista << resultado
            }
            x++
        }
        return lista
    }
    
    def validarActor(def idPersona, def tipoDeParte){
        def resultado = [:]
        def persona = Persona.get(idPersona as long)
        resultado.persona = persona
        resultado.tipoDeParte = tipoDeParte
        resultado.cantidadDemandada = 0
        if(tipoDeParte.id == 5){
            def actor = ActorJuicio.findAllWhere(persona: persona, tipoDeParte: tipoDeParte)//Buscar en Juicios que estén activos, es decir, que no estén en Archivo Definitivo o Histórico
            if(actor){
                resultado.tieneJuicio = 'true'
                resultado.mensaje = generarInfoJuicio(actor.juicio)
            } else {
                resultado.tieneJuicio = 'false'
            }
        } else {
            resultado.tieneJuicio = 'false'
        }
        return resultado
    }
    
    def generarInfoJuicio(def juicios){
        def info = ""
        juicios.each { juicio ->
            info += "<strong>Exp. Int.</strong> " + juicio.expedienteInterno + " ; <strong>Exp</strong> " + juicio.expediente + "; <strong>Estatus:</strong> " + juicio.estadoDeJuicio + "; <strong>Despacho:</strong> " + juicio.despacho + "; "
            info += "<strong>Delegación:</strong> " + juicio.delegacion + "; <strong>Tipo de Juicio:</strong> " + juicio.tipoDeProcedimiento + "; "
            if(juicio.materia.id == 1 || juicio.materia.id == 2){
                def tiposAsociados = TipoAsociadoJuicio.findAllWhere(juicio: juicio)
                if(tiposAsociados){
                    info += "<strong>Prestación Reclamada:</strong> " + ((tiposAsociados*.tipoAsociado)*.prestacionReclamada as Set)?.getAt(0) + ", "
                    info += "<strong>Tipos Asociados:</strong> "
                    tiposAsociados?.each {
                        info += "" + it.tipoAsociado.nombre + ", "
                    }
                }
            } else if (juicio.materia.id == 3){
                def delitos = DelitoJuicio.findAllWhere(juicio: juicio)
                if(delitos){
                    info += "<strong>Tipo de Asignación:</strong> " + ((delitos*.delito)*.tipoDeAsignacion as Set)?.getAt(0) + ", "
                    info += "<strong>Delitos:</strong> "
                    delitos?.each {
                        info += "" + it.delito.nombre + ", "
                    }
                }
            }
            info += "<br/><br/>"
        }
        return info
    }
    
    def generarNotificacionJuicio (def juicios){
        def info = ""
        def respuesta = []
        juicios.each { juicio ->
            info += "Exp. Interno: " + juicio.expedienteInterno + " ; Expediente: " + juicio.expediente + "; Estatus: " + juicio.estadoDeJuicio + "; Despacho: " + juicio.despacho + "; "
            info += "Delegación: " + juicio.delegacion + "; Tipo de Juicio: " + juicio.tipoDeProcedimiento + "; "
            if(juicio.materia.id == 1 || juicio.materia.id == 2){
                def tiposAsociados = TipoAsociadoJuicio.findAllWhere(juicio: juicio)
                if(tiposAsociados){
                    info += "Prestación Reclamada: " + ((tiposAsociados*.tipoAsociado)*.prestacionReclamada as Set)?.getAt(0) + ", "
                    info += "Tipos Asociados: "
                    tiposAsociados?.each {
                        info += "" + it.tipoAsociado.nombre + " "
                    }
                }
            } else if (juicio.materia.id == 3){
                def delitos = DelitoJuicio.findAllWhere(juicio: juicio)
                if(delitos){
                    info += "Tipo de Asignación: " + ((delitos*.delito)*.tipoDeAsignacion as Set)?.getAt(0) + ", "
                    info += "Delitos: "
                    delitos?.each {
                        info += "" + it.delito.nombre + ", "
                    }
                }
            }
            respuesta << info
        }
        log.info "RESPUESTA: " + respuesta
        return respuesta
    }
    
    def revisarLista(def lista, def idPersona){
        log.info "En Revisar Lista: " + lista + " - id: " + idPersona
        def existe = lista.find { p -> p.id == (idPersona as long) }
        if(existe){
            return true
        } else{
            return false
        }
    }
    
    def subirArchivo(def listaDeArchivos, def juicioId){
        def archivoGuardado = false
        def respuesta = [:]
        def juicio = Juicio.get(juicioId as int)
        def usuario = springSecurityService.currentUser
        def plataforma = System.properties['os.name'].toLowerCase()
        listaDeArchivos.each { archivo ->
            def archivoJuicio = new ArchivoJuicio()
            archivoJuicio.subidoPor = usuario
            archivoJuicio.juicio = juicio
            archivoJuicio.observaciones = ""
            if(plataforma.contains('windows')){
                archivoJuicio.rutaArchivo = "C:/var/uploads/sicj/documentos/" + juicio.materia.nombreCarpeta + "/" + juicio.delegacion.nombreCarpeta + "/" + juicio.expedienteInterno
            } else {
                archivoJuicio.rutaArchivo = "/var/uploads/sicj/documentos/" + juicio.materia.nombreCarpeta + "/" + juicio.delegacion.nombreCarpeta + "/" + juicio.expedienteInterno
            }
            archivoJuicio.nombreArchivo = archivo.nombreDelArchivo
            if(archivoJuicio.save(flush:true)){
                def subdir = new File(archivoJuicio.rutaArchivo)
                subdir.mkdir()
                log.info (archivoJuicio.rutaArchivo+"/"+archivo.nombreDelArchivo)
                File file = new File(archivoJuicio.rutaArchivo, archivo.nombreDelArchivo)
                if (file.exists() || file.createNewFile()) {
                    file.withOutputStream{fos->
                        fos << archivo.archivo
                    }
                }
                juicio.ultimaModificacion = new Date()
                juicio.personaQueModifico = springSecurityService.currentUser
                juicio.save(flash:true)
                respuesta.idArchivo = archivoJuicio.id
                respuesta.exito = true
                respuesta.mensaje = "El archivo se ha registrado exitosamente."
            } else {
                respuesta.nombreArchivo = archivoJuicio.nombreArchivo
                respuesta.exito = false
                respuesta.mensaje = "Ocurrio un error al registrar la credencial. Intentelo nuevamente."
            }
        }
        return respuesta 
    }
    
    def eliminarArchivo(def idArchivo){
        def archivoEliminado = [:]
        try {
            def archivo = ArchivoJuicio.get(idArchivo as long);
            if(archivo) {
                def procesoAlterno = ProcesoAlternoJuicio.countByArchivo(archivo)
                def acuerdoJuicio = AcuerdoJuicio.findAllWhere(juicio: archivo.juicio, rutaArchivo: ("" + archivo.id))
                def promocionJuicio = PromocionJuicio.findAllWhere(juicio: archivo.juicio, rutaArchivo: ("" + archivo.id))
                if(procesoAlterno > 0) {
                    archivoEliminado.error = true
                    archivoEliminado.message = "El documento está relacionado a un Proceso Alterno y no puede ser eliminado"
                } else if(acuerdoJuicio) {
                    archivoEliminado.error = true
                    archivoEliminado.message = "El documento está relacionado a un Acuerdo y no puede ser eliminado"
                } else if(promocionJuicio) {
                    archivoEliminado.error = true
                    archivoEliminado.message = "El documento está relacionado a una Promoción y no puede ser eliminado"
                } else {
                    def rutaArchivo = new String(archivo.rutaArchivo+"/"+archivo.nombreArchivo)
                    log.info rutaArchivo
                    log.info "_________________________________"
                    log.info "Si lo borro"
                    log.info "_________________________________"
                    File file = new File(rutaArchivo)
                    file.delete()
                    archivo.delete()
                    archivoEliminado.exito = true
                    archivoEliminado.message = "El archivo se ha eliminado correctamente"
                }
            } else {
                archivoEliminado.error = true
                archivoEliminado.message = "Error: El archivo indicado no existe"
            }
        } catch (NumberFormatException ne){
            log.info "Viene algo que no es número: " + ne.getMessage()
            archivoEliminado.error = true
            archivoEliminado.message = "Ha ocurrido un error al eliminar el archivo"
        } catch (Exception e){
            log.info "Se murio por otra cosa: " + e.getMessage()
            archivoEliminado.error = true
            archivoEliminado.message = "Ha ocurrido un error al eliminar el archivo"
        } finally {
            return archivoEliminado
        }
    }
    
    def obtenerListaDeDelitos(def max, def offset){
        def resultados = []
        def query = "SELECT d from Delito d ORDER BY d.nombre ASC"
        resultados = Delito.executeQuery(query, [max: max, offset: offset])
        log.info ("---- resultados " + resultados.size())
        return resultados
    }
    
    def obtenerListaDePerfiles(def max, def offset){
        def resultados = []
        def query = "SELECT p from Perfil p ORDER BY p.name ASC"
        resultados = Perfil.executeQuery(query, [max: max, offset: offset])
        log.info ("---- resultados " + resultados.size())
        return resultados
    }
    
    def obtenerListaDeAutoridadesIndex(def max, def offset){
        def resultados = []
        def resultadosReales = []
        def query = "SELECT a,m from Autoridad a, AutoridadMunicipio m WHERE a.id = m.autoridad.id"
        query += " ORDER BY a.materia.id, a.tipoDeAutoridad.nombre, a.nombre ASC"
        resultados = Autoridad.executeQuery(query, [max: max, offset: offset])
        resultadosReales = Autoridad.executeQuery(query)
        log.info ("---- resultados " + resultados.size() + " | resultados reales " + resultadosReales.size())
        return resultados
    }
    
    def obtenerListaDeAutoridades(def estadoId, def tipoDeAutoridadId, def max, def offset){
        def resultados = []
        def resultadosReales = []
        def query = "SELECT a,m from Autoridad a, AutoridadMunicipio m WHERE a.id = m.autoridad.id"
        query += " AND m.municipio.estado.id = :estadoId AND a.tipoDeAutoridad.id = :tipoDeAutoridadId"
        query += " ORDER BY a.materia.id, a.tipoDeAutoridad.nombre, a.nombre ASC"
        resultados = Autoridad.executeQuery(query, [estadoId: estadoId as long, tipoDeAutoridadId: tipoDeAutoridadId as long], [max: max, offset: offset])
        resultadosReales = Autoridad.executeQuery(query, [estadoId: estadoId as long, tipoDeAutoridadId: tipoDeAutoridadId as long])
        log.info ("---- resultados " + resultados.size() + " | resultados reales " + resultadosReales.size())
        return resultados
    }
    
    def eliminarPreguntasAnteriores(def ultimaPregunta, def juicio){
        def borrarDesde
        def flujoJuicio = FlujoJuicio.findAllWhere(preguntaAtendida: ultimaPregunta, juicio: juicio)
        flujoJuicio = flujoJuicio?.sort { it.fechaDeRespuesta }
        flujoJuicio = flujoJuicio.reverse()
        borrarDesde = flujoJuicio?.getAt(0)
        def preguntas = FlujoJuicio.executeQuery("SELECT fj FROM FlujoJuicio fj WHERE fj.fechaDeRespuesta >= :fecha and fj.juicio.id = :juicio", [fecha:borrarDesde.fechaDeRespuesta, juicio: juicio.id])
        def tmpPreguntas = new ArrayList(preguntas)
        def cantidadDeFilas = 0
        for (Iterator<HashMap> iter = (tmpPreguntas).iterator(); iter.hasNext();) {
            def it = iter.next();
            log.info "Eliminando pregunta con id : " + it.id
            if(it.preguntaAtendida.tipoDePregunta.elementoDeEntrada == "ARCHIVO" || it.preguntaAtendida.requiereSubirArchivo){
                log.info "La pregunta es de tipo de archivo : " + it.id + ""
                if(it.preguntaAtendida.requiereSubirArchivo && it.datoAuxiliar){
                    log.info "Eliminando archivos anexos de la pregunta con id : " + it.id
                    eliminarArchivo(it.datoAuxiliar) 
                } else if (!it.preguntaAtendida.requiereSubirArchivo && it.valorRespuesta) {
                    log.info "Eliminando archivos con valor respuesta"
                    eliminarArchivo(it.valorRespuesta)
                }
            }
            iter.remove()
            it.delete()
            cantidadDeFilas++
        }
        log.info "Cantidad de líneas eliminadas: " + cantidadDeFilas
        return cantidadDeFilas
    }
    
    def autoridades
    
    def exportarSeguimiento(def juicio){
        def seguimiento = FlujoJuicio.findAllWhere(juicio: juicio)
        if(seguimiento) {
            def sw = new StringWriter()
            def b
            b = new CSVWriter(sw, {
                    col1: "idAsunto" { it.val1 }
                    col2: "Materia" { it.val2 }
                    col3: "Delegacion" { it.val3 }
                    col4: "Num. Exp. Interno" { it.val4 }
                    col5: "Exp. Juicio" { it.val5 }
                    col6: "Tipo de Juicio" { it.val6 }
                    col7: "Etapa Procesal" { it.val7 }
                    col8: "Pregunta" { it.val8 }
                    col9: "Respuesta" { it.val9 }
                    col10: "Observaciones" { it.val10 }
                    col11: "Usuario" { it.val11 }
                    col12: "Fecha" { it.val12 }
                })
            seguimiento.each { fila ->
                def valores = [:]
                valores.val1 = fila.juicio.id
                valores.val2 = fila.juicio.materia
                valores.val3 = fila.juicio.delegacion.nombre
                valores.val4 = fila.juicio.expedienteInterno
                valores.val5 = fila.juicio.expediente
                valores.val6 = fila.juicio.tipoDeProcedimiento
                valores.val7 = fila.preguntaAtendida.etapaProcesal
                valores.val8 = fila.preguntaAtendida.textoPregunta
                valores.val9 = (fila.valorRespuesta ?: fila.respuesta)
                valores.val10 = (fila.observaciones ?: "")
                valores.val11 = fila.usuarioQueResponde
                valores.val12 = fila.fechaDeRespuesta.format('dd/MM/yyyy HH:mm') 
                b << valores
            }
            log.info b
            log.info b?.writer?.toString()
            def archivoReporte = new File("reporteGenerado.csv")
            archivoReporte.withWriter('UTF-8') { writer ->
                writer.write(b?.writer?.toString())
            }
            return archivoReporte
        } else {
            return null
        }
    }
}
