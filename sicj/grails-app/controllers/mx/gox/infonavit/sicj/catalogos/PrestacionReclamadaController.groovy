package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class PrestacionReclamadaController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def prestacionReclamadaList = PrestacionReclamada.list(params)
        prestacionReclamadaList = prestacionReclamadaList.sort{ it.nombre }
        respond prestacionReclamadaList, model:[prestacionReclamadaCount: PrestacionReclamada.count()]
    }

    def show(PrestacionReclamada prestacionReclamada) {
        respond prestacionReclamada
    }

    def create() {
        respond new PrestacionReclamada(params)
    }

    @Transactional
    def save(PrestacionReclamada prestacionReclamada) {
        if (prestacionReclamada == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (prestacionReclamada.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond prestacionReclamada.errors, view:'create'
            return
        }

        prestacionReclamada.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'prestacionReclamada.label', default: 'PrestacionReclamada'), prestacionReclamada.id])
                redirect prestacionReclamada
            }
            '*' { respond prestacionReclamada, [status: CREATED] }
        }
    }

    def edit(PrestacionReclamada prestacionReclamada) {
        respond prestacionReclamada
    }

    @Transactional
    def update(PrestacionReclamada prestacionReclamada) {
        if (prestacionReclamada == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (prestacionReclamada.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond prestacionReclamada.errors, view:'edit'
            return
        }

        prestacionReclamada.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'prestacionReclamada.label', default: 'PrestacionReclamada'), prestacionReclamada.id])
                redirect prestacionReclamada
            }
            '*'{ respond prestacionReclamada, [status: OK] }
        }
    }

    @Transactional
    def delete(PrestacionReclamada prestacionReclamada) {

        if (prestacionReclamada == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def juicio = TipoAsociado.countByPrestacionReclamada(prestacionReclamada)
        if(juicio > 0){
            flash.error = "La Prestación Reclamada no puede eliminarse ya que está ligado a uno o más Tipos Asociados"
            redirect action: "show", id: prestacionReclamada.id
        } else {
            prestacionReclamada.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'prestacionReclamada.label', default: 'PrestacionReclamada'), prestacionReclamada.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'prestacionReclamada.label', default: 'PrestacionReclamada'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
