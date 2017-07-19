package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class TipoDeAsignacionController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def tipoDeAsignacionList = TipoDeAsignacion.list(params)
        tipoDeAsignacionList = tipoDeAsignacionList.sort{ it.nombre }
        respond tipoDeAsignacionList, model:[tipoDeAsignacionCount: TipoDeAsignacion.count()]
    }

    def show(TipoDeAsignacion tipoDeAsignacion) {
        respond tipoDeAsignacion
    }

    def create() {
        respond new TipoDeAsignacion(params)
    }

    @Transactional
    def save(TipoDeAsignacion tipoDeAsignacion) {
        if (tipoDeAsignacion == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoDeAsignacion.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoDeAsignacion.errors, view:'create'
            return
        }

        tipoDeAsignacion.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'tipoDeAsignacion.label', default: 'TipoDeAsignacion'), tipoDeAsignacion.id])
                redirect tipoDeAsignacion
            }
            '*' { respond tipoDeAsignacion, [status: CREATED] }
        }
    }

    def edit(TipoDeAsignacion tipoDeAsignacion) {
        respond tipoDeAsignacion
    }

    @Transactional
    def update(TipoDeAsignacion tipoDeAsignacion) {
        if (tipoDeAsignacion == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (tipoDeAsignacion.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond tipoDeAsignacion.errors, view:'edit'
            return
        }

        tipoDeAsignacion.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'tipoDeAsignacion.label', default: 'TipoDeAsignacion'), tipoDeAsignacion.id])
                redirect tipoDeAsignacion
            }
            '*'{ respond tipoDeAsignacion, [status: OK] }
        }
    }

    @Transactional
    def delete(TipoDeAsignacion tipoDeAsignacion) {
        if (tipoDeAsignacion == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def delito = Delito.findWhere(tipoDeAsignacion: tipoDeAsignacion)
        if(delito){
            flash.error = "El Tipo de Asignación no puede eliminarse ya que está asociada a uno o más Delitos."
            redirect action: "show", id: tipoDeAsignacion.id
        } else {
            tipoDeAsignacion.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'tipoDeAsignacion.label', default: 'TipoDeAsignacion'), tipoDeAsignacion.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tipoDeAsignacion.label', default: 'TipoDeAsignacion'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
