package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import mx.gox.infonavit.sicj.juicios.TipoAsociadoJuicio
import grails.converters.JSON
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class TipoAsociadoController {

    private static final Logger log = LogManager.getLogger(TipoAsociadoController)
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def tipoAsociadoList = TipoAsociado.list(params)
        tipoAsociadoList = tipoAsociadoList.sort{ it.nombre }
        respond tipoAsociadoList, model:[tipoAsociadoCount: TipoAsociado.count()]
    }

    def show(TipoAsociado tipoAsociado) {
        respond tipoAsociado
    }

    def create() {
        respond new TipoAsociado(params)
    }

    @Transactional
    def save(TipoAsociado tipoAsociado) {
        if (tipoAsociado == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoAsociado.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoAsociado.errors, view:'create'
            return
        }

        tipoAsociado.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'tipoAsociado.label', default: 'TipoAsociado'), tipoAsociado.id])
                redirect tipoAsociado
            }
            '*' { respond tipoAsociado, [status: CREATED] }
        }
    }

    def edit(TipoAsociado tipoAsociado) {
        def prestacionReclamadaList = PrestacionReclamada.findAll("from PrestacionReclamada pr where pr.materia.id = :idMateria and pr.id > 0 order by pr.nombre", [idMateria: tipoAsociado.prestacionReclamada.materia.id])
        respond tipoAsociado, model: [prestacionReclamadaList: prestacionReclamadaList]
    }

    @Transactional
    def update(TipoAsociado tipoAsociado) {
        if (tipoAsociado == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoAsociado.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoAsociado.errors, view:'edit'
            return
        }

        tipoAsociado.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'tipoAsociado.label', default: 'TipoAsociado'), tipoAsociado.id])
                redirect tipoAsociado
            }
            '*'{ respond tipoAsociado, [status: OK] }
        }
    }

    @Transactional
    def delete(TipoAsociado tipoAsociado) {

        if (tipoAsociado == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def juicio = TipoAsociadoJuicio.countByTipoAsociado(tipoAsociado)
        if(juicio > 0){
            flash.error = "El Tipo Asociado no puede eliminarse ya que está ligado a uno o más Juicios"
            redirect action: "show", id: tipoAsociado.id
        } else {
            tipoAsociado.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'tipoAsociado.label', default: 'TipoAsociado'), tipoAsociado.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tipoAsociado.label', default: 'TipoAsociado'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def obtenerPrestacionesReclamadas(){
        log.info params
        def respuesta = [:]
        if(params.materiaId){
            respuesta = PrestacionReclamada.findAll("from PrestacionReclamada pr where pr.materia.id = :idMateria and pr.id > 0 order by pr.nombre", [idMateria: (params.materiaId as long)])
        }
        render respuesta as JSON
    }
}
