package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import mx.gox.infonavit.sicj.juicios.DelitoJuicio
import mx.gox.infonavit.sicj.catalogos.Delito
import groovy.sql.Sql

@Transactional(readOnly = true)
class DelitoController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]
    def juicioService
    
    def index(Integer max) {
        log.info ("PARAMETROS -> " + params)
        
        def listaDeDelitos = juicioService.obtenerListaDeDelitos((params.max ? (params.max as int) : 10),(params.offset ? (params.offset as int) : 0))
        def resultadosReales = []
        def query = "SELECT d from Delito d ORDER BY d.nombre ASC"
        resultadosReales = Delito.executeQuery(query)
        def cantidadTotalDelitos = resultadosReales.size()
        log.info("- - - - - - - - - LISTA DE DELITOS -> " + resultadosReales + " | DELITOS SIZE " + cantidadTotalDelitos)
        [delitosList:listaDeDelitos, delitoCount: cantidadTotalDelitos]
            
//        params.max = Math.min(max ?: 10, 100)
//        def delitoList = Delito.list(params)
//        def delitosList = []
//        def query = "SELECT d from Delito d ORDER BY d.nombre ASC"
//        delitosList = Delito.executeQuery(query, [max: 10, offset: 0])
//        
//        delitoList = delitoList.sort{it.nombre}
//        log.info("\n- - - - - - - - - LISTA DE DELITOS -> " + delitoList)
//        log.info("- - - - - - - - - LISTA DE DELITOS -> " + delitosList)
        
//        respond delitoList, model:[delitoCount: Delito.count()]
    }

    def show(Delito delito) {
        respond delito
    }

    def create() {
        respond new Delito(params)
    }

    @Transactional
    def save(Delito delito) {
        if (delito == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (delito.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond delito.errors, view:'create'
            return
        }

        delito.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'delito.label', default: 'Delito'), delito.id])
                redirect delito
            }
            '*' { respond delito, [status: CREATED] }
        }
    }

    def edit(Delito delito) {
        respond delito
    }

    @Transactional
    def update(Delito delito) {
        if (delito == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (delito.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond delito.errors, view:'edit'
            return
        }

        delito.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'delito.label', default: 'Delito'), delito.id])
                redirect delito
            }
            '*'{ respond delito, [status: OK] }
        }
    }

    @Transactional
    def delete(Delito delito) {

        if (delito == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def delitoJuicio = DelitoJuicio.countByDelito(delito)
        if(delitoJuicio > 0){
            flash.error = "El delito no puede eliminarse ya que está ligado a uno o más Juicios"
            redirect action: "show", id: delito.id
        } else {
            delito.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'delito.label', default: 'Delito'), delito.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'delito.label', default: 'Delito'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
