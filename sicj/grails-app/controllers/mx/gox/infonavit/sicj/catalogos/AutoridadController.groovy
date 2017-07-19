package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.converters.JSON
import grails.transaction.Transactional
import mx.gox.infonavit.sicj.admin.Delegacion
import groovy.sql.Sql
import mx.gox.infonavit.sicj.catalogos.Autoridad
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class AutoridadController {

    private static final Logger log = LogManager.getLogger(AutoridadController)
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def juicioService

    def index(Integer max) {
        if(params.estadoId && params.tipoDeAutoridadId){
            log.info("SI VIENEN PARAMETROS DE ESTADO Y DE AUTORIDAD")
            def listaDeAutoridades = juicioService.obtenerListaDeAutoridades((params.estadoId ? (params.estadoId as long) : 0), (params.tipoDeAutoridadId ? (params.tipoDeAutoridadId as long) : 0),(params.max ? (params.max as int) : 10),(params.offset ? (params.offset as int) : 0))
            def cantidad = AutoridadMunicipio.withCriteria {
                municipio {
                    eq('estado.id', (params.estadoId ? (params.estadoId as long) : 0))
                }
                autoridad{
                    eq('tipoDeAutoridad.id', (params.tipoDeAutoridadId ? (params.tipoDeAutoridadId as long) : 0))
                }
                projections {
                    count()
                }
            }
            [autoridadList: listaDeAutoridades, autoridadCount: cantidad[0], estadoId: params.estadoId, tipoDeAutoridadId: params.tipoDeAutoridadId]
            
        } else {
            def listaDeAutoridades = juicioService.obtenerListaDeAutoridadesIndex((params.max ? (params.max as int) : 10),(params.offset ? (params.offset as int) : 0))
            def resultadosReales = []
            def query = "SELECT a,m from Autoridad a, AutoridadMunicipio m WHERE a.id = m.autoridad.id"
            query += " ORDER BY a.materia.id, a.tipoDeAutoridad.nombre, a.nombre ASC"
            resultadosReales = Autoridad.executeQuery(query)
            log.info (" | CANTIDAD " + resultadosReales.size())
            def cantidad = resultadosReales.size()
            [autoridadList: listaDeAutoridades, autoridadCount: cantidad, estadoId: params.estadoId, tipoDeAutoridadId: params.tipoDeAutoridadId]
        }
        
//        def listaDeAutoridades = juicioService.obtenerListaDeAutoridadesIndex((params.max ? (params.max as int) : 10),(params.offset ? (params.offset as int) : 0))
//        def resultadosReales = []
//        def query = "SELECT a,m from Autoridad a, AutoridadMunicipio m WHERE a.id = m.autoridad.id"
//        query += " ORDER BY a.materia.id, a.tipoDeAutoridad.nombre, a.nombre ASC"
//        resultadosReales = Autoridad.executeQuery(query)
//        log.info (" | CANTIDAD " + resultadosReales.size())
//        def cantidad = resultadosReales.size()
        
    }

    def show(Autoridad autoridad) {
        def autoridadMunicipio = AutoridadMunicipio.findByAutoridad(autoridad)
        respond autoridad, model: [autoridadMunicipio: autoridadMunicipio]
    }

    def create() {
        respond new Autoridad(params)
    }

    @Transactional
    def save(Autoridad autoridad) {
        if (autoridad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (autoridad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond autoridad.errors, view:'create'
            return
        }

        if(autoridad.save(flush:true)) {
            def municipio = Municipio.get(params.municipio.id)
            def autoridadMunicipio = new AutoridadMunicipio()
            autoridadMunicipio.municipio = municipio
            autoridadMunicipio.autoridad = autoridad
            if(!autoridadMunicipio.save(flush:true)) {
                transactionStatus.setRollbackOnly()
                respond autoridad.errors, view:'create'
                return
            }
        } else {
            transactionStatus.setRollbackOnly()
            respond autoridad.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'autoridad.label', default: 'Autoridad'), autoridad.id])
                redirect autoridad
            }
            '*' { respond autoridad, [status: CREATED] }
        }
    }

    def edit(Autoridad autoridad) {
        def autoridadMunicipio = AutoridadMunicipio.findByAutoridad(autoridad)
        def municipios = Municipio.findAllWhere(estado: autoridadMunicipio.municipio.estado)
        municipios = municipios.sort { it.nombre }
        respond autoridad, model: [listaMunicipios: municipios, autoridadMunicipio: autoridadMunicipio]
    }

    @Transactional
    def update(Autoridad autoridad) {
        if (autoridad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (autoridad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond autoridad.errors, view:'edit'
            return
        }
        
        autoridad.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'autoridad.label', default: 'Autoridad'), autoridad.id])
                redirect autoridad
            }
            '*'{ 
                respond autoridad, [status: OK] 
            }
        }
    }

    @Transactional
    def delete(Autoridad autoridad) {

        if (autoridad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        autoridad.activo = false
        autoridad.save(flush:true)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'autoridad.label', default: 'Autoridad'), autoridad.id])
                redirect autoridad
            }
            '*'{ render status: [status: OK] }
        }
    }
    
    def doSearch(){
        if(params.delegacion.id){
            def delegacion = Delegacion.get(params.delegacion.id as long)
            def tipoDeAutoridad = TipoDeAutoridad.get(params.autoridad.id as long)
            def resultados = juicioService.obtenerListaDeAutoridades(delegacion.estado.id, (tipoDeAutoridad?.id ?: 0), 10, 0)
            def cantidad = AutoridadMunicipio.withCriteria {
                municipio {
                    eq('estado.id',delegacion.estado.id)
                }
                if(tipoDeAutoridad){
                    autoridad {
                        eq('tipoDeAutoridad.id',tipoDeAutoridad.id) 
                    }
                }
                projections {
                    count()
                }
            }
            render(template: "/templates/listaDeAutoridades", model: [autoridadList: resultados, autoridadCount: cantidad[0], estadoId: delegacion.estado.id , tipoDeAutoridadId: tipoDeAutoridad.id])
        } else {
            render(text: "<center><div class='alert alert-danger'>Seleccione la delegación para poder ejecutar la consulta</div></center>", contentType: "text/html", encoding: "UTF-8")
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'autoridad.label', default: 'Autoridad'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def obtenerMunicipios(){
        def estado = Estado.get(params.estado as long)//TODO cambiar busqueda
        def municipios = Municipio.findAllByEstado(estado)
        municipios = municipios.sort { it.nombre }
        render municipios as JSON
    }
    
    def obtenerTiposDeAutoridad(){
        log.info params
        def delegacion = Delegacion.get(params.delegacion)
        def listaDeTiposDeAutoridad = AutoridadMunicipio.executeQuery("Select am.autoridad From AutoridadMunicipio am Where am.municipio.estado.id = :estadoId",[estadoId: delegacion.estado.id])
        listaDeTiposDeAutoridad = (listaDeTiposDeAutoridad*.tipoDeAutoridad as Set)
        listaDeTiposDeAutoridad = listaDeTiposDeAutoridad.sort { it.nombre }
        render listaDeTiposDeAutoridad as JSON
    }
}
