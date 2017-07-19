package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import mx.gox.infonavit.sicj.juicios.Juicio
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class ProveedorController {

    private static final Logger log = LogManager.getLogger(ProveedorController)
    
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        log.info params
        if(params.busquedaProveedor){
            max = (params.max ? (params.max as int) : 10)
            def respuesta = [:]
            def offset = (params.offset ? (params.offset as int) : 0)
            def resultados = Proveedor.executeQuery("Select p from Proveedor p Where p.nombre like '%" + params.busquedaProveedor?.toUpperCase() + "%' order by p.nombre, p.delegacion", [], [max: max, offset: offset])
            respuesta.lista = resultados
            respuesta.total = (Proveedor.executeQuery("Select p from Proveedor p Where p.nombre like '%" + params.busquedaProveedor?.toUpperCase() + "%'"))?.size()
            [proveedorList: respuesta.lista, proveedorCount: respuesta.total, busquedaProveedor: params.busquedaProveedor]
        } else {
            params.max = Math.min(max ?: 10, 100)
            params.sort = "nombre"
            respond Proveedor.list(params), model:[proveedorCount: Proveedor.count()]
        }
    }

    def show(Proveedor proveedor) {
        def usuariosProveedorList = getUsuariosProveedor(proveedor)
        def responsable = getResponsable(proveedor)
        respond proveedor, model: [usuariosProveedorList: usuariosProveedorList, responsable: responsable]
    }

    def create() {
        respond new Proveedor(params)
    }

    @Transactional
    def save(Proveedor proveedor) {
        if (proveedor == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (proveedor.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond proveedor.errors, view:'create'
            return
        }

        proveedor.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'proveedor.label', default: 'Proveedor'), proveedor.id])
                redirect proveedor
            }
            '*' { respond proveedor, [status: CREATED] }
        }
    }

    def edit(Proveedor proveedor) {
        respond proveedor
    }

    @Transactional
    def update(Proveedor proveedor) {
        if (proveedor == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (proveedor.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond proveedor.errors, view:'edit'
            return
        }

        proveedor.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'proveedor.label', default: 'Proveedor'), proveedor.id])
                redirect proveedor
            }
            '*'{ respond proveedor, [status: OK] }
        }
    }

    @Transactional
    def delete(Proveedor proveedor) {

        if (proveedor == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        
        def cantidad = Juicio.withCriteria {
            estadoDeJuicio {
                'in'('id', (long[])([1,2,3,4,5]))
            }
            eq('proveedor',proveedor)
            projections {
                count()
            }
        }
        
        if(cantidad[0] > 0) {
            flash.error = "El proveedor no puede darse de baja, ya que aún cuenta con " + cantidad[0] + " juicio(s) en proceso."
            redirect proveedor
        } else {
            def usuarios = getUsuariosProveedor(proveedor)
            proveedor.activo = false
            proveedor.save(flush:true)
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
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'proveedor.label', default: 'Proveedor'), proveedor.id])
                redirect proveedor
            }
            '*'{ render status: NO_CONTENT }
        }
    }


    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'proveedor.label', default: 'Proveedor'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def obtenerProveedores = {
        def proveedores = []
        if(params.delegacion){
            def delegacion = Delegacion.get(params.delegacion as long)
            proveedores = Proveedor.findAllWhere( delegacion: delegacion, activo: true)
            proveedores = proveedores.sort { it.nombre }
            render proveedores as JSON
        } else {
            render proveedores as JSON
        }
    }
    
    def obtenerUsuariosProveedor = {
        log.info params
        def proveedor = Proveedor.get(params.proveedor)
        def usuarios = getUsuariosProveedor(proveedor)
        usuarios = usuarios.sort { it.nombre }
        render usuarios as JSON
    }
    
    def obtenerUsuariosActivosDelProveedor = {
        log.info params
        def usuarios
        if(params.proveedor) {
            def proveedor = Proveedor.get(params.proveedor)
            usuarios = Usuario.findAllWhere(proveedor: proveedor, tipoDeUsuario: 'EXTERNO', enabled: true, accountLocked: false)
            usuarios = usuarios.sort { it.nombre }
        } else {
            usuarios = [:]
        }
        render usuarios as JSON
    }
    
    def getResponsable(Proveedor proveedor){
        return Usuario.findWhere(proveedor: proveedor, proveedorResponsable: true, enabled: true)
    }
    
    def getUsuariosProveedor(Proveedor proveedor){
        return Usuario.findAllWhere(proveedor: proveedor, tipoDeUsuario: 'EXTERNO')
    }
    
    def getDatosProveedorSeleccionado = {
        log.info params
        def mapa = [:]
        if(params.proveedor) {
            def proveedor = Proveedor.get(params.proveedor)
            def responsableDelProveedor = (getResponsable(proveedor))
            mapa.responsableDelProveedor = (responsableDelProveedor.nombre + " " + responsableDelProveedor.apellidoPaterno + " " + responsableDelProveedor.apellidoMaterno)
        } else {
            mapa.responsableDelProveedor = "El Responsable de este Proveedor no ha sido especificado"
        }
        render mapa as JSON
    }
}
