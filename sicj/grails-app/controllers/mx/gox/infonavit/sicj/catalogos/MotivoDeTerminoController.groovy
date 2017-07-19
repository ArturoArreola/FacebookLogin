package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import mx.gox.infonavit.sicj.juicios.Juicio
import mx.gox.infonavit.sicj.catalogos.Materia
import mx.gox.infonavit.sicj.catalogos.MotivoDeTerminoMateria
import mx.gox.infonavit.sicj.catalogos.MotivoDeTermino

@Transactional(readOnly = true)
class MotivoDeTerminoController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        def motivoDeTerminoList = MotivoDeTermino.list(params)
        motivoDeTerminoList = motivoDeTerminoList.sort{ it.nombre }
        respond motivoDeTerminoList, model:[motivoDeTerminoCount: MotivoDeTermino.count()]
    }

    def show(MotivoDeTermino motivoDeTermino) {
        respond motivoDeTermino
    }

    def create() {
        respond new MotivoDeTermino(params)
    }

    @Transactional
    def save(MotivoDeTermino motivoDeTermino) {
        def motivoDeTeminoMateria = new MotivoDeTerminoMateria()
        if (motivoDeTermino == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        if (motivoDeTermino.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond motivoDeTermino.errors, view:'create'
            return
        }
        if(motivoDeTermino.save(flush:true)){
            motivoDeTeminoMateria.materia = Materia.get(params.materia as long)
            motivoDeTeminoMateria.motivo = motivoDeTermino
            if(motivoDeTeminoMateria.save(flush:true)){
                log.info "motivo de termino materia SI REGISTRO"
            } else{
                log.info "motivo de termino materia NO REGISTRO"
            }
        }
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'motivoDeTermino.label', default: 'MotivoDeTermino'), motivoDeTermino.id])
                redirect motivoDeTermino
            }
            '*' { respond motivoDeTermino, [status: CREATED] }
        }
    }

    def edit(MotivoDeTermino motivoDeTermino) {
        respond motivoDeTermino
    }

    @Transactional
    def update(MotivoDeTermino motivoDeTermino) {
        if (motivoDeTermino == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (motivoDeTermino.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond motivoDeTermino.errors, view:'edit'
            return
        }

        motivoDeTermino.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'motivoDeTermino.label', default: 'MotivoDeTermino'), motivoDeTermino.id])
                redirect motivoDeTermino
            }
            '*'{ respond motivoDeTermino, [status: OK] }
        }
    }

    @Transactional
    def delete(MotivoDeTermino motivoDeTermino) {

        if (motivoDeTermino == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def juicio = Juicio.countByMotivoDeTermino(motivoDeTermino)
        if(juicio > 0){
            flash.error = "El Motivo de Término no puede eliminarse ya que está ligado a uno o más Juicios"
            redirect action: "show", id: motivoDeTermino.id
        } else {
            motivoDeTermino.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'motivoDeTermino.label', default: 'MotivoDeTermino'), motivoDeTermino.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'motivoDeTermino.label', default: 'MotivoDeTermino'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
