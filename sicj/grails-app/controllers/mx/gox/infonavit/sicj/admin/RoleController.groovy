package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class RoleController extends grails.plugin.springsecurity.ui.RoleController {
    
    private static final Logger log = LogManager.getLogger(RoleController)
    
    def index(){
        respond Rol.list()
    }
    
    @Override
    def edit() {
        log.info "Edit params: " + params
        def role
        if(params.id){
            role = Rol.get(params.id as long)
        } else if (params.authority && params.authority.startsWith('ROLE')){
            role = Rol.findByAuthority(params.authority)
        } else if (params.name && params.name.startsWith('ROLE')){
            role = Rol.findByAuthority(params.name)
        }
        if(role){
            def todosLosPerfiles = Perfil.list()
            def grantedPerfilesList = (PerfilRol.findAllWhere(rol: role))*.perfil
            def nonGrantedPerfilesList = []
        
            todosLosPerfiles?.each{
                if(!grantedPerfilesList?.contains(it)){
                    nonGrantedPerfilesList << it
                }
            }
        
            grantedPerfilesList = grantedPerfilesList?.sort { it.name }
            nonGrantedPerfilesList = nonGrantedPerfilesList?.sort { it.name }
            [role: role, grantedPerfilesList: grantedPerfilesList, nonGrantedPerfilesList: nonGrantedPerfilesList] 
        } else {
            flash.message = "No se encontraron coincidencias con el nombre indicado."
            redirect action: 'search'
        }
    }
    
    @Override
    def update() {
        if(params.id){
            def role = Rol.get(params.id as long)
            def paramsPerfiles = params.findAll{it.key.startsWith("PROFILE_")}
            def perfiles = []
            
            paramsPerfiles.each{ key, value ->
                if(value.equals('on')){
                    perfiles << Perfil.get((key.minus('PROFILE_')) as long)
                }
            }
            
            if(saveProfilesRoles(role, perfiles)){
                log.info "Se asociaron correctamente el rol " + role + " a los perfiles " + perfiles
            }
            flash.message = "El Rol "+ role.authority + " ha sido actualizado correctamente."
            redirect action: 'edit', id: role.id
            
        } else{
            redirect action: 'search'
        }
    }
    
    @Transactional
    def saveProfilesRoles(def rol, def perfiles){
        if(perfiles){
            PerfilRol.removeAll(rol, true)
            perfiles.each{
                PerfilRol.create(it, rol, true)
            }
            return true
        } else {
            return false
        }
    }
}
