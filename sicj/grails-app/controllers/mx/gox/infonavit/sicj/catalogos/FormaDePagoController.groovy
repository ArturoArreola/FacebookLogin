package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import mx.gox.infonavit.sicj.juicios.Juicio

@Transactional(readOnly = true)
class FormaDePagoController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def formaDePagoList = FormaDePago.list(params)
        formaDePagoList = formaDePagoList.sort{ it.nombre }
        respond formaDePagoList, model:[formaDePagoCount: FormaDePago.count()]
    }

    def show(FormaDePago formaDePago) {
        respond formaDePago
    }

    def create() {
        respond new FormaDePago(params)
    }

    @Transactional
    def save(FormaDePago formaDePago) {
        if (formaDePago == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (formaDePago.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond formaDePago.errors, view:'create'
            return
        }
        formaDePago.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'formaDePago.label', default: 'FormaDePago'), formaDePago.id])
                redirect formaDePago
            }
            '*' { respond formaDePago, [status: CREATED] }
        }
    }

    def edit(FormaDePago formaDePago) {
        respond formaDePago
    }

    @Transactional
    def update(FormaDePago formaDePago) {
        if (formaDePago == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (formaDePago.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond formaDePago.errors, view:'edit'
            return
        }

        formaDePago.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'formaDePago.label', default: 'FormaDePago'), formaDePago.id])
                redirect formaDePago
            }
            '*'{ respond formaDePago, [status: OK] }
        }
    }

    @Transactional
    def delete(FormaDePago formaDePago) {

        if (formaDePago == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def juicio = Juicio.countByFormaDePago(formaDePago)
        if(juicio > 0){
            flash.error = "La forma de pago no puede eliminarse ya que está ligado a uno o más Juicios"
            redirect action: "show", id: formaDePago.id
        } else {
            formaDePago.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'formaDePago.label', default: 'FormaDePago'), formaDePago.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'formaDePago.label', default: 'FormaDePago'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
