package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class DelegacionController {

    private static final Logger log = LogManager.getLogger(DelegacionController)
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 40, 400)
        params.sort = 'nombre'
        respond Delegacion.list(params), model:[delegacionCount: Delegacion.count()]
    }

    def show(Delegacion delegacion) {
        def usuariosDelegacionList = getUsuariosDelegacion(delegacion)
        def gerenteJuridico = getGerenteJuridico(delegacion)
        def despachosDelegacion = Despacho.findAllWhere(delegacion:delegacion, activo:true)
        respond delegacion, model: [usuariosDelegacionList: usuariosDelegacionList, gerenteJuridico: gerenteJuridico, despachosDelegacion:despachosDelegacion]
    }

    def create() {
        respond new Delegacion(params)
    }

    @Transactional
    def save(Delegacion delegacion) {
        if (delegacion == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (delegacion.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond delegacion.errors, view:'create'
            return
        }

        delegacion.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'delegacion.label', default: 'Delegacion'), delegacion.id])
                redirect delegacion
            }
            '*' { respond delegacion, [status: CREATED] }
        }
    }

    def edit(Delegacion delegacion) {
        respond delegacion
    }

    @Transactional
    def update(Delegacion delegacion) {
        if (delegacion == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (delegacion.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond delegacion.errors, view:'edit'
            return
        }

        delegacion.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'delegacion.label', default: 'Delegacion'), delegacion.id])
                redirect delegacion
            }
            '*'{ respond delegacion, [status: OK] }
        }
    }

    @Transactional
    def delete(Delegacion delegacion) {

        if (delegacion == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        delegacion.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'delegacion.label', default: 'Delegacion'), delegacion.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'delegacion.label', default: 'Delegacion'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def getGerenteJuridico(Delegacion delegacion){
        return Usuario.findWhere(delegacion: delegacion, gerenteJuridico: true, enabled: true)
    }
    
    def getUsuariosDelegacion(Delegacion delegacion){
        def usuarios = Usuario.findAllWhere(delegacion: delegacion, tipoDeUsuario: 'INTERNO')
        usuarios = usuarios.sort{it.nombre}
        return usuarios
    }
    
    def getDatosDelegacionSeleccionada = {
        log.info params
        def delegacion = Delegacion.get(params.delegacion)
        def mapa = [:]
        def gerenteJuridico = (getGerenteJuridico(delegacion))
        mapa.gerenteJuridico = (gerenteJuridico != null) ? (gerenteJuridico?.nombre + " " + gerenteJuridico?.apellidoPaterno + " " + gerenteJuridico?.apellidoMaterno) : ""
        mapa.zona = delegacion.division.nombre
        render mapa as JSON
    }
}
