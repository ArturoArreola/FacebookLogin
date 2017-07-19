package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import mx.gox.infonavit.sicj.admin.Delegacion
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class UserController extends grails.plugin.springsecurity.ui.UserController {
    
    private static final Logger log = LogManager.getLogger(UserController)
    
    def userService
    
    @Transactional
    def saveUser(Usuario user) {
        
        log.info params
        def mensaje = ""
        
        if (user == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (user.hasErrors()) {
            transactionStatus.setRollbackOnly()
            render view:'create', model: [user: user]
            return
        }
        
        if(user.gerenteJuridico){
            def gerenteJuridico = Usuario.findWhere(delegacion: user.delegacion, gerenteJuridico: true, enabled: true)
            if(gerenteJuridico){
                mensaje = "El usuario " + gerenteJuridico + " es actualmente Gerente Jurídico en "+ user.delegacion + "; el puesto le ha sido removido. "
                flash.message = mensaje
                gerenteJuridico.gerenteJuridico = false
                gerenteJuridico.enabled = false
                gerenteJuridico.accountLocked = true
                gerenteJuridico.save(flush:true)
            }
        }
        
        if(user.responsableDelDespacho){
            def responsableDelDespacho = Usuario.findWhere(despacho: user.despacho, responsableDelDespacho: true, enabled: true)
            if(responsableDelDespacho){
                mensaje = "El usuario " + responsableDelDespacho + " es actualmente Responsable del Despacho "+ user.despacho + "; el puesto le ha sido removido. "
                flash.message = mensaje
                responsableDelDespacho.responsableDelDespacho = false
                responsableDelDespacho.save(flush:true)
            }
        }
        
        if(user.proveedorResponsable){
            def responsable = Usuario.findWhere(despacho: user.despacho, proveedorResponsable: true, enabled: true)
            if(responsable){
                mensaje = "El usuario " + responsable + " es actualmente Responsable del Proveedor "+ user.proveedor + "; el puesto le ha sido removido. "
                flash.message = mensaje
                responsable.proveedorResponsable = false
                responsable.save(flush:true)
            }
        }
        
        def paramsPerfiles = params.findAll{it.key.startsWith("PROFILE_")}
        def paramsRoles = params.findAll{it.key.startsWith("ROLE_")}
        
        def perfiles = []
        def roles = []
        paramsPerfiles.each{ key, value ->
            if(value.equals('on')){
                perfiles << Perfil.get((key.minus('PROFILE_')) as long)
            }
        }
        
        paramsRoles.each{ key, value ->
            if(value.equals('on')){
                roles << Rol.findByAuthority(key)
            }
        }        

        user.save flush:true
        
        if(saveUserProfilesRoles(user, perfiles, roles)){
            request.withFormat {
                form multipartForm {
                    mensaje += "El usuario "+ user.username + " ha sido creado correctamente."
                    flash.message = mensaje
                    redirect action: 'editUser', id: user.id
                }
            '*' { respond user.errors, view:'editUser' }
            }            
        } else {
            flash.message = "Debe especificar al menos un perfil para el usuario "+ user
            redirect action: 'editUser', id: user.id
            return
        }
    }
    
    def editUser(Usuario user) {
        def todosLosPerfiles = Perfil.list()
        def todosLosRoles = Rol.list()
        def grantedPerfilesList = (UsuarioPerfil.findAllWhere(usuario: user))*.perfil
        def grantedRolesList = (UsuarioRol.findAllWhere(usuario: user))*.rol
        def nonGrantedPerfilesList = []
        def nonGrantedRolesList = []
        
        todosLosPerfiles?.each{
            if(!grantedPerfilesList?.contains(it)){
                nonGrantedPerfilesList << it
            }
        }
        
        todosLosRoles?.each{
            if(!grantedRolesList?.contains(it)){
                nonGrantedRolesList << it
            }
        }
        
        grantedPerfilesList = grantedPerfilesList?.sort { it.name }
        nonGrantedPerfilesList = nonGrantedPerfilesList?.sort { it.name }
        grantedRolesList = grantedRolesList?.sort { it.authority }
        nonGrantedRolesList = nonGrantedRolesList?.sort { it.authority }
        
        [user: user, grantedPerfilesList: grantedPerfilesList, nonGrantedPerfilesList:nonGrantedPerfilesList, grantedRolesList: grantedRolesList, nonGrantedRolesList: nonGrantedRolesList]
    }
    
    @Transactional
    def updateUser(Usuario user) {
        
        def mensaje = ""
        log.info "Params de Update user: " + params
                
        if (user == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (user.hasErrors()) {
            transactionStatus.setRollbackOnly()
            log.info ("se esta muriendo aca, tiene errores")
            user.errors.each {
                log.info it
            }
            //respond user.errors, view:'editUser'
            //return
            render view:'editUser', model: [user: user]
            return
        }

        if(user.gerenteJuridico){
            def gerenteJuridico = Usuario.findWhere(delegacion: user.delegacion, gerenteJuridico: true, enabled: true)
            if(gerenteJuridico && (gerenteJuridico.id != user.id)){
                mensaje = "El usuario " + gerenteJuridico + " es actualmente Gerente Jurídico en "+ user.delegacion + "; el puesto le ha sido removido. "
                flash.message = mensaje
                gerenteJuridico.gerenteJuridico = false
                gerenteJuridico.save(flush:true)
            }
        }
        
        if(user.responsableDelDespacho){
            def responsableDelDespacho = Usuario.findWhere(despacho: user.despacho, responsableDelDespacho: true, enabled: true)
            if(responsableDelDespacho && (responsableDelDespacho.id != user.id)){
                mensaje = "El usuario " + responsableDelDespacho + " es actualmente Responsable del Despacho "+ user.despacho + "; el puesto le ha sido removido. "
                flash.message = mensaje
                responsableDelDespacho.responsableDelDespacho = false
                responsableDelDespacho.save(flush:true)
            }
        }
        
        if(user.proveedorResponsable){
            def responsable = Usuario.findWhere(despacho: user.despacho, proveedorResponsable: true, enabled: true)
            if(responsable){
                mensaje = "El usuario " + responsable + " es actualmente Responsable del Proveedor "+ user.proveedor + "; el puesto le ha sido removido. "
                flash.message = mensaje
                responsable.proveedorResponsable = false
                responsable.save(flush:true)
            }
        }
        
        def paramsPerfiles = params.findAll{it.key.startsWith("PROFILE_")}
        def paramsRoles = params.findAll{it.key.startsWith("ROLE_")}
        
        def perfiles = []
        def roles = []
        paramsPerfiles.each{ key, value ->
            if(value.equals('on')){
                perfiles << Perfil.get((key.minus('PROFILE_')) as long)
            }
        }
        
        paramsRoles.each{ key, value ->
            if(value.equals('on')){
                roles << Rol.findByAuthority(key)
            }
        } 
        
        if(user.accountLocked && !user.fechaDeBloqueo){
            user.fechaDeBloqueo = new Date()
            user.enabled = false
        }
        
        if(user.enabled){
            user.accountLocked = false
        } else {
            user.accountLocked = true
        }
        
        user.save flush:true

        if(user.accountLocked || saveUserProfilesRoles(user, perfiles, roles)){
            request.withFormat {
                form multipartForm {
                    mensaje += "El usuario "+ user.username + " ha sido actualizado correctamente."
                    flash.message = mensaje
                    redirect action: 'editUser', id: user.id
                }
            '*'{ respond user, [status: OK] }
            }   
        } else{
            mensaje += "Debe especificar al menos un perfil."+ user
            flash.message = mensaje
            transactionStatus.setRollbackOnly()
            render view:'editUser', model: [user: user]
            return
        }
    }
    
    @Transactional
    def saveUserProfilesRoles(def usuario, def perfiles, def roles){
        log.info ("USUARIO -> " + usuario)
        log.info ("PERFILES -> " + perfiles)
        log.info ("ROLES -> " + roles)
        log.info ("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
        if(perfiles || roles){
            UsuarioPerfil.removeAll(usuario, true)
            UsuarioRol.removeAll(usuario, true)
            
            def respuestaUsuarioPerfil = UsuarioPerfil.findAllByUsuario(usuario)
            log.info ("ESTO TRAE USUARIO-PERFIL -> " + respuestaUsuarioPerfil)
            def respuestaUsuarioRol = UsuarioRol.findAllByUsuario(usuario)
            log.info ("ESTO TRAE USUARIO-ROL -> " + respuestaUsuarioRol + "\n")
            
            def listaRoles 
            def rolesPerfiles = []
            
            if(perfiles){
                perfiles.each{
                    UsuarioPerfil.create(usuario, it, true)
                    log.info("    PERFIL -> " + it)
                    roles.addAll(it.getAuthorities())
                    listaRoles = PerfilRol.findAll("from PerfilRol pr where pr.perfil=:perfiles", [perfiles:it])
                    log.info("    ROLES ASOCIADOS AL PERFIL -> " + listaRoles)
                    rolesPerfiles << listaRoles
                    //log.info("ESTO TRAE ROLES-PERFILES -> " + rolesPerfiles)
                }
            }
            log.info("\n    ESTO TRAE ROLES-PERFILES -> " + rolesPerfiles + "\n    LONGITUD: " + rolesPerfiles.size())
            
            if(rolesPerfiles){
                //rolesPerfiles = rolesPerfiles as Set
                for(int x = 0; x < rolesPerfiles.size(); x++){
                    rolesPerfiles[x].rol.each(){
                        log.info("    AGREGANDO ROL -> " + it)
                        UsuarioRol.create(usuario,it,true)
                    }
                }
            }
            return true
        } else {
            return false
        }
    }
    
    def searchByNombre(){
        log.info ("parametros -> " + params)
        def usuarios = []
        if(params.query){
            //def resultado = Usuario.executeQuery("from Usuario p where ((p.nombre||' '||p.apellidoPaterno||' '||p.apellidoMaterno) like '%"+params.query.toUpperCase()+"%') or (p.nombre like '%"+params.query.toUpperCase()+"%') order by p.nombre")
            def resultado = Usuario.executeQuery("from Usuario p where ((p.nombre + ' ' + p.apellidoPaterno + ' ' + p.apellidoMaterno) like '%"+params.query.toUpperCase()+"%') or (p.nombre like '%"+params.query.toUpperCase()+"%') order by p.nombre")
            log.info ("RESULTADO -> " + resultado)
            def map
            resultado.each{
                map = [:]
                map.value = "[" + it.id + "] - " + (it.nombre + ((it.apellidoPaterno) ? (" " +it.apellidoPaterno) : "") + ((it.apellidoMaterno) ? (" " + it.apellidoMaterno) : ""))
                map.id = it.id
                map.tokens = [it.nombre.toString(), it.apellidoPaterno.toString(),it.apellidoMaterno.toString()]
                usuarios << map
                map = null
            }
            log.info (usuarios)
            log.info ("USUARIOS -> " + usuarios)
        }
        render usuarios as JSON
    }
    
    def obtenerUsuario(){
        log.info params
        def usuario = Usuario.get(params.id as long)
        render(template: "/templates/resultadoUsuarios", model: [searched: true, user: usuario])
    }
    
    def bloquearUsuario(Usuario usuario){
        log.info params
        def identificador
        def controlador
        if(usuario){
            usuario.accountLocked = true
            usuario.fechaDeBloqueo = new Date()
            usuario.enabled = false
            if(usuario.save(flush:true)){
                flash.message = "El usuario " + usuario + " ha sido bloqueado correctamente."
            } else {
                flash.error = "El usuario " + usuario + " no fue bloqueado, intente realizarlo desde el módulo de gestión de usuarios."
            }
        } else {
            flash.mensaje = "El usuario indicado no existe, verifique e intente nuevamente."
        }
        if(params.delegacion){
            controlador = "delegacion"
            identificador = params.delegacion
        } else if(params.despacho){
            controlador = "despacho"
            identificador = params.despacho
        }
        redirect controller: controlador, action: 'show', id: identificador
    }
    
    def reporteGeneral(){
        def respuesta = userService.obtenerPerfilesPorUsuario()
        respuesta
    }
    
    def generarReporteGeneral(){
        def file = userService.generarReporteGeneral()
        if (file){
            response.setContentType("application/octet-stream") // or or image/JPEG or text/xml or whatever type the file is
            response.setHeader("Content-disposition", "attachment;filename=\"reporteGeneralDeUsuarios.csv\"")
            response.outputStream << file.bytes
        } else {
            render "Error!"
        }
    }
    
    def reporteDeActividad(){}
    
    def obtenerReporteDeAccesos(){
        log.info params
        def reporte = []
        if(params.idUsuario && (params.fechaInicial && params.fechaFinal)){
            def mapa = [:]
            def usuario = Usuario.get(params.idUsuario as long)
            mapa.usuario = usuario
            mapa.resultado = userService.obtenerUltimosMovimientosPorUsuario(usuario, params.fechaInicial, params.fechaFinal)
            reporte << mapa
        } else if(params.delegacion?.id && (params.delegacion?.id as int) != 0 && (!params.despacho || (params.despacho?.id as int) == 0) && (params.fechaInicial && params.fechaFinal)){
            def usuariosPorDelegacion = Usuario.findAllWhere(enabled: true, delegacion: Delegacion.get(params.delegacion?.id as long), tipoDeUsuario: "INTERNO")
            usuariosPorDelegacion.each { usuario ->
                def mapa = [:]
                mapa.usuario = usuario
                mapa.resultado = userService.obtenerUltimosMovimientosPorUsuario(usuario, params.fechaInicial, params.fechaFinal)
                reporte << mapa
            }
        } else if(params.despacho?.id && (params.despacho?.id as int) != 0 && (params.fechaInicial && params.fechaFinal)){
            def usuariosPorDespacho = Usuario.findAllWhere(enabled: true, despacho: Despacho.get(params.despacho?.id as long), tipoDeUsuario: "EXTERNO")
            usuariosPorDespacho.each { usuario ->
                def mapa = [:]
                mapa.usuario = usuario
                mapa.resultado = userService.obtenerUltimosMovimientosPorUsuario(usuario, params.fechaInicial, params.fechaFinal)
                reporte << mapa
            }
        }
        log.info reporte
        render(template: "/templates/resultadoReporteDeAccesos", model: [reporte: reporte])
    }
    
    def obtenerUsuariosDelegacion = {
        log.info ("ESTOS SON LOS PARAMETROS -> " + params)
        def delegacion = Delegacion.get(params.delegacion as long)
        log.info ("DELEGACION -> " + delegacion)
    }
    
    
//    def obtenerTiposDeProcedimiento = {
//        log.info params
//        def ambito = Ambito.get(params.ambito as long)
//        def tiposDeProcedimiento = (TipoDeProcedimientoAmbito.findAllByAmbito(ambito))*.tipoDeProcedimiento
//        def tmp = []
//        tiposDeProcedimiento.each{
//            if(it.materia.id == (params.materia as long)){
//                tmp << it
//            }
//        }
//        tiposDeProcedimiento = null
//        tiposDeProcedimiento = tmp
//        tiposDeProcedimiento = tiposDeProcedimiento.sort { it.nombre }
//        log.info tiposDeProcedimiento
//        render tiposDeProcedimiento as JSON
//    }
    
}
