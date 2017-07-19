package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import mx.gox.infonavit.sicj.juicios.AudienciaJuicio

@Transactional(readOnly = true)
class TipoDeAudienciaController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def tipoDeAudienciaList = TipoDeAudiencia.list(params)
        tipoDeAudienciaList = tipoDeAudienciaList.sort{ it.nombre }
        respond tipoDeAudienciaList, model:[tipoDeAudienciaCount: TipoDeAudiencia.count()]
    }

    def show(TipoDeAudiencia tipoDeAudiencia) {
        respond tipoDeAudiencia
    }

    def create() {
        respond new TipoDeAudiencia(params)
    }

    @Transactional
    def save(TipoDeAudiencia tipoDeAudiencia) {
        if (tipoDeAudiencia == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoDeAudiencia.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoDeAudiencia.errors, view:'create'
            return
        }

        tipoDeAudiencia.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'tipoDeAudiencia.label', default: 'TipoDeAudiencia'), tipoDeAudiencia.id])
                redirect tipoDeAudiencia
            }
            '*' { respond tipoDeAudiencia, [status: CREATED] }
        }
    }

    def edit(TipoDeAudiencia tipoDeAudiencia) {
        respond tipoDeAudiencia
    }

    @Transactional
    def update(TipoDeAudiencia tipoDeAudiencia) {
        if (tipoDeAudiencia == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoDeAudiencia.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoDeAudiencia.errors, view:'edit'
            return
        }

        tipoDeAudiencia.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'tipoDeAudiencia.label', default: 'TipoDeAudiencia'), tipoDeAudiencia.id])
                redirect tipoDeAudiencia
            }
            '*'{ respond tipoDeAudiencia, [status: OK] }
        }
    }

    @Transactional
    def delete(TipoDeAudiencia tipoDeAudiencia) {

        if (tipoDeAudiencia == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def juicio = AudienciaJuicio.countByTipoDeAudiencia(tipoDeAudiencia)
        if(juicio > 0){
            flash.error = "El Tipo de Audiencia no puede eliminarse ya que está asociada a uno o más juicios."
            redirect action: "show", id: tipoDeAudiencia.id
        } else {
            tipoDeAudiencia.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'tipoDeAudiencia.label', default: 'TipoDeAudiencia'), tipoDeAudiencia.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tipoDeAudiencia.label', default: 'TipoDeAudiencia'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
