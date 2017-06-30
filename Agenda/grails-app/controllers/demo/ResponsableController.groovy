package demo

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class ResponsableController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Responsable.list(params), model:[responsableCount: Responsable.count()]
    }

    def show(Responsable responsable) {
        respond responsable
    }

    def create() {
        respond new Responsable(params)
    }

    @Transactional
    def save(Responsable responsable) {
        if (responsable == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (responsable.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond responsable.errors, view:'create'
            return
        }

        responsable.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'responsable.label', default: 'Responsable'), responsable.id])
                redirect responsable
            }
            '*' { respond responsable, [status: CREATED] }
        }
    }

    def edit(Responsable responsable) {
        respond responsable
    }

    @Transactional
    def update(Responsable responsable) {
        if (responsable == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (responsable.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond responsable.errors, view:'edit'
            return
        }

        responsable.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'responsable.label', default: 'Responsable'), responsable.id])
                redirect responsable
            }
            '*'{ respond responsable, [status: OK] }
        }
    }

    @Transactional
    def delete(Responsable responsable) {

        if (responsable == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        responsable.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'responsable.label', default: 'Responsable'), responsable.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'responsable.label', default: 'Responsable'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
