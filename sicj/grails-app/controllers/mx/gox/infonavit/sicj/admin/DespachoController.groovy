package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import groovy.sql.Sql
import mx.gox.infonavit.sicj.juicios.Juicio
import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.admin.Delegacion
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class DespachoController {

    private static final Logger log = LogManager.getLogger(DespachoController)
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        log.info params
        if(params.busquedaDespacho){
            max = (params.max ? (params.max as int) : 10)
            def respuesta = [:]
            def offset = (params.offset ? (params.offset as int) : 0)
            def resultados = Despacho.executeQuery("Select d from Despacho d Where d.nombre like '%" + params.busquedaDespacho?.toUpperCase() + "%' order by d.nombre, d.delegacion", [], [max: max, offset: offset])
            respuesta.lista = resultados
            respuesta.total = (Despacho.executeQuery("Select d from Despacho d Where d.nombre like '%" + params.busquedaDespacho?.toUpperCase() + "%'"))?.size()
            [despachoList: respuesta.lista, despachoCount: respuesta.total, busquedaDespacho: params.busquedaDespacho]
        } else {
            params.max = Math.min(max ?: 10, 100)
            params.sort = "nombre"
            respond Despacho.list(params), model:[despachoCount: Despacho.count()]
        }
    }

    def show(Despacho despacho) {
        def usuariosDespachoList = getUsuariosDespacho(despacho)
        def responsableDelDespacho = getResponsableDelDespacho(despacho)
        respond despacho, model: [usuariosDespachoList: usuariosDespachoList, responsableDelDespacho: responsableDelDespacho]
    }

    def create() {
        respond new Despacho(params)
    }

    @Transactional
    def save(Despacho despacho) {
        if (despacho == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (despacho.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond despacho.errors, view:'create'
            return
        }

        despacho.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'despacho.label', default: 'Despacho'), despacho.id])
                redirect despacho
            }
            '*' { respond despacho, [status: CREATED] }
        }
    }

    def edit(Despacho despacho) {
        respond despacho
    }

    @Transactional
    def update(Despacho despacho, Delegacion delegacion) {
        if (despacho == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (despacho.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond despacho.errors, view:'edit'
            return
        }
        def usuarios = [] 
        usuarios = Usuario.findAllByDespacho(despacho)
        log.info("USUARIOS -> " + usuarios + "\nCANTIDAD DE USUARIOS -> " + usuarios.size())
        for(int x = 0; x < usuarios.size(); x++){
            Usuario.executeUpdate("update Usuario u set u.delegacion=:delegacion where u.id=:usuario", [delegacion:delegacion, usuario:usuarios.id[x]])
            log.info("CAMBIANDO AL USUARIO -> " + usuarios[x])
        }

        despacho.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'despacho.label', default: 'Despacho'), despacho.id])
                redirect despacho
            }
            '*'{ respond despacho, [status: OK] }
        }
    }

    @Transactional
    def delete(Despacho despacho) {

        if (despacho == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        
        def cantidad = Juicio.withCriteria {
            estadoDeJuicio {
                'in'('id', (long[])([1,2,3,4,5]))
            }
            eq('despacho',despacho)
            projections {
                count()
            }
        }
        
        if(cantidad[0] > 0) {
            flash.error = "El despacho no puede darse de baja, ya que aún cuenta con " + cantidad[0] + " juicio(s) en proceso."
            redirect despacho
        } else {
            def usuarios = getUsuariosDespacho(despacho)
            despacho.activo = false
            despacho.save(flush:true)
            usuarios.each{ usuario ->
                usuario.accountLocked = true
                usuario.fechaDeBloqueo = new Date()
                usuario.enabled = false
                if(usuario.save(flush:true)){
                }
            }
        }
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'despacho.label', default: 'Despacho'), despacho.id])
                redirect despacho
            }
            '*'{ render status: NO_CONTENT }
        }
    }


    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'despacho.label', default: 'Despacho'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def obtenerDespachos = {
        def despachos = []
        if(params.delegacion){
            def delegacion = Delegacion.get(params.delegacion as long)
            despachos = Despacho.findAllWhere(delegacion: delegacion, activo: true)
            despachos = despachos.sort { it.nombre }
            render despachos as JSON
        } else {
            render despachos as JSON
        }
    }
    
    def obtenerUsuariosDespacho = {
        log.info params
        def despacho = Despacho.get(params.despacho)
        def usuarios = getUsuariosDespacho(despacho)
        usuarios = usuarios.sort { it.nombre }
        render usuarios as JSON
    }
    
    def obtenerUsuariosActivosDelDespacho = {
        log.info params
        def usuarios
        if(params.despacho) {
            def despacho = Despacho.get(params.despacho)
            usuarios = Usuario.findAllWhere(despacho: despacho, tipoDeUsuario: 'EXTERNO', enabled: true, accountLocked: false)
            usuarios = usuarios.sort { it.nombre }
        } else {
            usuarios = [:]
        }
        render usuarios as JSON
    }
    
    def getResponsableDelDespacho(Despacho despacho){
        return Usuario.findWhere(despacho: despacho, responsableDelDespacho: true, enabled: true)
    }
    
    def getUsuariosDespacho(Despacho despacho){
        return Usuario.findAllWhere(despacho: despacho, tipoDeUsuario: 'EXTERNO')
    }
    
    def getDatosDespachoSeleccionado = {
        log.info params
        def mapa = [:]
        if(params.despacho) {
            def despacho = Despacho.get(params.despacho)
            def responsableDelDespacho = (getResponsableDelDespacho(despacho))
            mapa.responsableDelDespacho = (responsableDelDespacho.nombre + " " + responsableDelDespacho.apellidoPaterno + " " + responsableDelDespacho.apellidoMaterno)
        } else {
            mapa.responsableDelDespacho = "El Responsable de este Despacho no ha sido especificado"
        }
        render mapa as JSON
    }
}
