package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class AvisoController {

    private static final Logger log = LogManager.getLogger(AvisoController)
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def springSecurityService

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Aviso.list(params), model:[avisoCount: Aviso.count()]
    }

    def show(Aviso aviso) {
        respond aviso
    }

    def create() {
        respond new Aviso(params)
    }

    @Transactional
    def save(Aviso aviso) {
        log.info params
        if (aviso == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        aviso.usuarioQueRegistro = springSecurityService.currentUser
        aviso.fechaLimite = new Date().parse('dd/MM/yyyy',params.fechaDeCaducidad)
        log.info aviso.fechaLimite

        if(aviso.save(flush:true)){
            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.created.message', args: [message(code: 'aviso.label', default: 'Aviso'), aviso.id])
                    redirect aviso
                }
            '*' { respond aviso, [status: CREATED] }
            }
        } else{
            if (aviso.hasErrors()) {
                log.info aviso.errors
                transactionStatus.setRollbackOnly()
                respond aviso.errors, view:'create'
                return
            }
        }
    }

    def edit(Aviso aviso) {
        respond aviso
    }

    @Transactional
    def update(Aviso aviso) {
        if (aviso == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (aviso.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond aviso.errors, view:'edit'
            return
        }

        aviso.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'aviso.label', default: 'Aviso'), aviso.id])
                redirect aviso
            }
            '*'{ respond aviso, [status: OK] }
        }
    }

    @Transactional
    def delete(Aviso aviso) {

        if (aviso == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        aviso.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'aviso.label', default: 'Aviso'), aviso.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'aviso.label', default: 'Aviso'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
