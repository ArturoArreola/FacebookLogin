package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class DivisionController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def divisionList = Division.list(params)
        divisionList = divisionList.sort{ it.nombre }
        respond divisionList, model:[divisionCount: Division.count()]
    }

    def show(Division division) {
        respond division
    }

    def create() {
        respond new Division(params)
    }

    @Transactional
    def save(Division division) {
        if (division == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (division.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond division.errors, view:'create'
            return
        }

        division.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'division.label', default: 'Division'), division.id])
                redirect division
            }
            '*' { respond division, [status: CREATED] }
        }
    }

    def edit(Division division) {
        respond division
    }

    @Transactional
    def update(Division division) {
        if (division == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (division.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond division.errors, view:'edit'
            return
        }

        division.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'division.label', default: 'Division'), division.id])
                redirect division
            }
            '*'{ respond division, [status: OK] }
        }
    }

    @Transactional
    def delete(Division division) {

        if (division == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def delegacion = Delegacion.findWhere(division: division)
        if(delegacion){
            flash.error = "La zona no puede eliminarse ya que está asociada a una o más Delegaciones."
            redirect action: "show", id: division.id
        } else {
            division.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'division.label', default: 'Division'), division.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'division.label', default: 'Division'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
