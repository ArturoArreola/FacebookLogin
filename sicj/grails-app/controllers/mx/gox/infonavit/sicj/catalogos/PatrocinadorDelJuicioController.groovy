package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import mx.gox.infonavit.sicj.juicios.Juicio

@Transactional(readOnly = true)
class PatrocinadorDelJuicioController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def patrocinadorDelJuicioList = PatrocinadorDelJuicio.list(params)
        patrocinadorDelJuicioList = patrocinadorDelJuicioList.sort{ it. nombre }
        respond patrocinadorDelJuicioList, model:[patrocinadorDelJuicioCount: PatrocinadorDelJuicio.count()]
    }

    def show(PatrocinadorDelJuicio patrocinadorDelJuicio) {
        respond patrocinadorDelJuicio
    }

    def create() {
        respond new PatrocinadorDelJuicio(params)
    }

    @Transactional
    def save(PatrocinadorDelJuicio patrocinadorDelJuicio) {
        if (patrocinadorDelJuicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (patrocinadorDelJuicio.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond patrocinadorDelJuicio.errors, view:'create'
            return
        }

        patrocinadorDelJuicio.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'patrocinadorDelJuicio.label', default: 'PatrocinadorDelJuicio'), patrocinadorDelJuicio.id])
                redirect patrocinadorDelJuicio
            }
            '*' { respond patrocinadorDelJuicio, [status: CREATED] }
        }
    }

    def edit(PatrocinadorDelJuicio patrocinadorDelJuicio) {
        respond patrocinadorDelJuicio
    }

    @Transactional
    def update(PatrocinadorDelJuicio patrocinadorDelJuicio) {
        if (patrocinadorDelJuicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (patrocinadorDelJuicio.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond patrocinadorDelJuicio.errors, view:'edit'
            return
        }

        patrocinadorDelJuicio.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'patrocinadorDelJuicio.label', default: 'PatrocinadorDelJuicio'), patrocinadorDelJuicio.id])
                redirect patrocinadorDelJuicio
            }
            '*'{ respond patrocinadorDelJuicio, [status: OK] }
        }
    }

    @Transactional
    def delete(PatrocinadorDelJuicio patrocinadorDelJuicio) {

        if (patrocinadorDelJuicio == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def juicio = Juicio.countByPatrocinadoDelJuicio(patrocinadorDelJuicio)
        if(juicio > 0){
            flash.error = "El Patrocinador del Juicio no puede eliminarse ya que está ligado a uno o más Juicios"
            redirect action: "show", id: patrocinadorDelJuicio.id
        } else {
            patrocinadorDelJuicio.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'patrocinadorDelJuicio.label', default: 'PatrocinadorDelJuicio'), patrocinadorDelJuicio.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'patrocinadorDelJuicio.label', default: 'PatrocinadorDelJuicio'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
