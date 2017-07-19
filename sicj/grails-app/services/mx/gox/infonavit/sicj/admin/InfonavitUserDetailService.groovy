package mx.gox.infonavit.sicj.admin

import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.userdetails.GrailsUserDetailsService
import grails.plugin.springsecurity.userdetails.NoStackUsernameNotFoundException
import grails.transaction.Transactional
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UsernameNotFoundException
import mx.gox.infonavit.sicj.auditoria.BitacoraDeAcceso
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext
import org.hibernate.Session

class InfonavitUserDetailsService implements GrailsUserDetailsService {
        
    private static final Logger log = LogManager.getLogger(InfonavitUserDetailsService)
    
    static final List NO_ROLES = [new SimpleGrantedAuthority(SpringSecurityUtils.NO_ROLE)]
    UserDetails loadUserByUsername(String username, boolean loadRoles) throws UsernameNotFoundException {
        return loadUserByUsername(username)
        println "############  Metodo 1 ############ "
    }

    @Transactional(readOnly=true, noRollbackFor=[IllegalArgumentException, UsernameNotFoundException])
    UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {         
        println "------------------------- " + username + " -------------------------"
        //Usuario user2 = Usuario.findByUsername(username)
        //Usuario user = Usuario.findByUsername(username)

        //Usuario user = Usuario.executeQuery("from Usuario where username = '"+username+"'")
        
        def user = null      
        def authorities = null
        Usuario.withNewSession { session ->            
            println "session: " + session
            user = Usuario.findByUsername(username)
       
            println " USUARIO -> "+ user
            println "pass: " + user.password                     
            if (!user) throw new NoStackUsernameNotFoundException()
            def roles = user.authorities.collect { it.authorities }.flatten().unique()
            println "roles1: " + roles
            roles.addAll(user.roles)
            println "user.roles: " + user.roles
            roles = roles as Set
            println "roles2: " + roles
            log.info "Perfiles: " + roles
            authorities = roles.collect {
                log.info "Revisando: " + it.authority
                new SimpleGrantedAuthority(it.authority)
            }
            
            println "authorities1: " +  authorities
            log.info "Roles: " + authorities
            def bitacoraDeAcceso = new BitacoraDeAcceso()        
            bitacoraDeAcceso.username = username
            bitacoraDeAcceso.fechaDeEvento = new Date()
            bitacoraDeAcceso.tipoDeEvento = "Login"
            bitacoraDeAcceso.estado = "Exitosa"
            bitacoraDeAcceso.save(flush: true)
            println "bitacoraDeAcceso: " + bitacoraDeAcceso
        }
                         
         
        return new InfonavitUserDetails(user.username, user.password, user.enabled,
            !user.accountExpired, !user.passwordExpired,
            !user.accountLocked, authorities ?: NO_ROLES, user.id,
            user.nombre + " " + user.apellidoPaterno + " " + user.apellidoMaterno)
                                   
    }
}