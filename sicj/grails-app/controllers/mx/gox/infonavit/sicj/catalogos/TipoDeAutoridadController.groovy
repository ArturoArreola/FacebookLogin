package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class TipoDeAutoridadController {

    private static final Logger log = LogManager.getLogger(TipoDeAutoridadController)
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond TipoDeAutoridad.list(params), model:[tipoDeAutoridadCount: TipoDeAutoridad.count()]
    }

    def show(TipoDeAutoridad tipoDeAutoridad) {
        respond tipoDeAutoridad
    }

    def create() {
        respond new TipoDeAutoridad(params)
    }

    @Transactional
    def save(TipoDeAutoridad tipoDeAutoridad) {
        if (tipoDeAutoridad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoDeAutoridad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoDeAutoridad.errors, view:'create'
            return
        }

        tipoDeAutoridad.save flush:true
        
        if(params.origen == "modal"){
            def respuesta = [:]
            respuesta.id = tipoDeAutoridad.id
            render respuesta as JSON
        } else {
            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.created.message', args: [message(code: 'tipoDeAutoridad.label', default: 'TipoDeAutoridad'), tipoDeAutoridad.id])
                    redirect tipoDeAutoridad
                }
            '*' { respond tipoDeAutoridad, [status: CREATED] }
            }
        }
    }

    def edit(TipoDeAutoridad tipoDeAutoridad) {
        respond tipoDeAutoridad
    }

    @Transactional
    def update(TipoDeAutoridad tipoDeAutoridad) {
        if (tipoDeAutoridad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoDeAutoridad.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoDeAutoridad.errors, view:'edit'
            return
        }

        tipoDeAutoridad.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'tipoDeAutoridad.label', default: 'TipoDeAutoridad'), tipoDeAutoridad.id])
                redirect tipoDeAutoridad
            }
            '*'{ respond tipoDeAutoridad, [status: OK] }
        }
    }

    @Transactional
    def delete(TipoDeAutoridad tipoDeAutoridad) {

        if (tipoDeAutoridad == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        tipoDeAutoridad.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'tipoDeAutoridad.label', default: 'TipoDeAutoridad'), tipoDeAutoridad.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tipoDeAutoridad.label', default: 'TipoDeAutoridad'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def obtenerTiposDeAutoridad = {
        log.info params
        def tiposDeAutoridad = TipoDeAutoridad.list()
        tiposDeAutoridad = tiposDeAutoridad.sort { it.nombre }
        render tiposDeAutoridad as JSON
    }
}
