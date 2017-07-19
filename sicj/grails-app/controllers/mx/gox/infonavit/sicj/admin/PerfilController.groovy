package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import mx.gox.infonavit.sicj.admin.PerfilRol
import groovy.sql.Sql
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

@Transactional(readOnly = true)
class PerfilController {
    
    private static final Logger log = LogManager.getLogger(PerfilController)
    def juicioService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        
        def listaDePerfiles = juicioService.obtenerListaDePerfiles((params.max ? (params.max as int) : 10),(params.offset ? (params.offset as int) : 0))
        def resultadosReales = []
        def query = "SELECT p from Perfil p ORDER BY p.name ASC"
        resultadosReales = Perfil.executeQuery(query)
        def cantidadTotalPerfiles = resultadosReales.size()
        log.info("- - - - - - - - - LISTA DE PERFILES -> " + resultadosReales + " | PERFILES SIZE " + cantidadTotalPerfiles)
        [perfilList:listaDePerfiles, perfilCount: cantidadTotalPerfiles]
        
//        params.max = Math.min(max ?: 10, 100)
//        def perfilList = Perfil.list(params)
//        perfilList = perfilList.sort{it.name}
//        respond perfilList, model:[perfilCount: Perfil.count()]
    }

    def show(Perfil perfil) {
        def rol = [:]
        def rolesMap = []
        def rolesAsociados = perfil.getAuthorities()
        rolesAsociados.each{
            rol = [:]
            rol.id = it.id
            rol.authority = it.authority
            rol.descripcion = it.descripcion
            rolesMap << rol
        }
        respond perfil, model:[rolesMap: rolesMap]
    }

    def create() {
        respond new Perfil(params)
    }

    @Transactional
    def save(Perfil perfil) {
        if (perfil == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (perfil.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond perfil.errors, view:'create'
            return
        }

        perfil.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'perfil.label', default: 'Perfil'), perfil.id])
                redirect perfil
            }
            '*' { respond perfil, [status: CREATED] }
        }
    }

    def edit(Perfil perfil) {
        def rol = [:]
        def rolesMap = []
        def listaDeRoles = Rol.list()
        def rolesAsociados = perfil.getAuthorities()
        listaDeRoles.each{
            rol = [:]
            rol.id = it.id
            rol.authority = it.authority
            rol.descripcion = it.descripcion
            if(rolesAsociados.contains(it)){
                rol.asociado = true
            } else{
                rol.asociado = false
            }
            rolesMap << rol
        }
        respond perfil, model:[rolesMap: rolesMap]
    }

    @Transactional
    def update(Perfil perfil) {
        log.info params
        if (perfil == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (perfil.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond perfil.errors, view:'edit'
            return
        }

        perfil.save flush:true
        
        def rolesAsociados = []
        
        params.each{ key, value ->
            if(key.startsWith("ROLE_")){
                rolesAsociados << Rol.get(value as long)
            }
        }
        log.info (rolesAsociados)
        if(rolesAsociados){
            PerfilRol.executeUpdate("delete PerfilRol pr where pr.perfil = :perfil", [perfil:perfil])
            rolesAsociados.each{
                def nuevoRol = new PerfilRol(perfil, it)
                nuevoRol.save flush:true
            }
        }
        
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'perfil.label', default: 'Perfil'), perfil.id])
                redirect perfil
            }
            '*'{ respond perfil, [status: OK] }
        }
    }

    @Transactional
    def delete(Perfil perfil) {
        log.info ("Perfil -> " + perfil )
        if (perfil == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }
        def usuarios = UsuarioPerfil.countByPerfil(perfil)
        def roles = PerfilRol.countByPerfil(perfil)
        
        log.info ("USUARIOS -> " + usuarios + " / ROLES -> " + roles)
        if(usuarios > 0){
            request.withFormat {
                form multipartForm {
                    flash.message = "El perfil no puede ser eliminado ya que está asignado actualmente a algunos usuarios/roles."
                    redirect perfil
                }
            '*'{ respond perfil, [status: OK] }
            }
        } else {
            PerfilRol.executeUpdate("delete from PerfilRol pr where pr.perfil =:perfil", [perfil:perfil])
            perfil.delete flush:true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'perfil.label', default: 'Perfil'), perfil.id])
                    redirect action:"index", method:"GET"
                }
            '*'{ render status: NO_CONTENT }
            }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'perfil.label', default: 'Perfil'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    
    def obtenerRolesDelPerfil = {
        def perfil = Perfil.get(params.perfil)
        def roles = perfil.getAuthorities()
        roles = roles.sort { it.authority }
        render new JSON(roles:roles, perfil:perfil)
    }
}
