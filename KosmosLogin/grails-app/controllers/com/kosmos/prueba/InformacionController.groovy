package com.kosmos.prueba



import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class InformacionController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Informacion.list(params), model:[informacionInstanceCount: Informacion.count()]
    }

    def show(Informacion informacionInstance) {
        respond informacionInstance
    }

    def create() {
        respond new Informacion(params)
    }
    
    def test(){
        println "ESTOS SON LOS PARAMETROS -> " + params
    }
    

    @Transactional
    def save(Informacion informacionInstance) {
        if (informacionInstance == null) {
            notFound()
            return
        }

        if (informacionInstance.hasErrors()) {
            respond informacionInstance.errors, view:'create'
            return
        }

        informacionInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'informacion.label', default: 'Informacion'), informacionInstance.id])
                redirect informacionInstance
            }
            '*' { respond informacionInstance, [status: CREATED] }
        }
    }

    def edit(Informacion informacionInstance) {
        respond informacionInstance
    }

    @Transactional
    def update(Informacion informacionInstance) {
        if (informacionInstance == null) {
            notFound()
            return
        }

        if (informacionInstance.hasErrors()) {
            respond informacionInstance.errors, view:'edit'
            return
        }

        informacionInstance.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'Informacion.label', default: 'Informacion'), informacionInstance.id])
                redirect informacionInstance
            }
            '*'{ respond informacionInstance, [status: OK] }
        }
    }

    @Transactional
    def delete(Informacion informacionInstance) {

        if (informacionInstance == null) {
            notFound()
            return
        }

        informacionInstance.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'Informacion.label', default: 'Informacion'), informacionInstance.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'informacion.label', default: 'Informacion'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
