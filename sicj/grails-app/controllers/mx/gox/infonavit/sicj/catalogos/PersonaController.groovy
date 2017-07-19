package mx.gox.infonavit.sicj.catalogos

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON  
import mx.gox.infonavit.sicj.juicios.ActorJuicio
import mx.gox.infonavit.sicj.catalogos.TipoDePersona
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class PersonaController {
      
    private static final Logger log = LogManager.getLogger(PersonaController)
    
    def index() { }
    
    def edit(){}
    
    def obtenerPersona(){
        log.info params
        if(params.idActor){
            def persona = Persona.get(params.idActor as long)
            if(persona){
                render(template: "/templates/editarActor", model: [persona: persona])
            } else {
                def respuesta = [:]
                respuesta.mensaje = "<center><div class='alert alert-info'>La persona solicita no está registrada.</div></center>"
                respuesta.notFound = true
                render respuesta as JSON
            }
        } else{
            def respuesta = [:]
            respuesta.mensaje = "<center><div class='alert alert-info'>Asegúrese de buscar primero al actor que desea editar.</div></center>"
            respuesta.notFound = true
            render respuesta as JSON
        }
    }
    
    @Transactional
    def save(){
        log.info params
        def nss = 0
        def rfc = 0
        def tipoDePersona = 0
        def nombre
        def apellidoPaterno
        def apellidoMaterno
        def map = [:]
        if(params.numeroSeguroSocial){
            nss =  Persona.countByNumeroSeguroSocial(params.numeroSeguroSocial)
        }
        if(params.rfc){
            rfc =  Persona.countByRfc(params.rfc)
        }
        if(nss > 0){
            map.error = "El Número de Seguridad Social proporcionado ya está registrado con otra persona."
            render map as JSON
        } else if(rfc > 0){
            map.error = "El R.F.C. proporcionado ya está registrado con otra persona."
            render map as JSON
        } else {
            def persona
            
            tipoDePersona = TipoDePersona.get(params.tipoDePersona.id)
            log.info("TIPO DE PERSONA -> " + tipoDePersona)
            
            if(tipoDePersona.id == 1){
                log.info ("PERSONA FISICA")
                nombre = params.nombre?.trim()
                if(nombre?.length() > 0){
                    nombre = nombre?.replaceAll("\\s+", " ")
                } else {
                    nombre = null;
                }
                apellidoPaterno = params.apellidoPaterno?.trim()
                if(apellidoPaterno?.length() > 0){
                    apellidoPaterno = apellidoPaterno?.replaceAll("\\s+", " ")
                } else {
                    apellidoPaterno = null;
                }
                apellidoMaterno = params.apellidoMaterno?.trim()
                if(apellidoMaterno?.length() > 0){
                    apellidoMaterno = apellidoMaterno?.replaceAll("\\s+", " ")
                } else {
                    apellidoMaterno = null;
                }

                log.info "------------------------------------------------------------------------------------------------------"
                log.info "NOMBRE | " + nombre + " APELLIDO PATERNO | " + apellidoPaterno + " APELLIDO MATERNO " + apellidoMaterno 

                nombre = nombre.replaceAll("Á", "A")
                nombre = nombre.replaceAll("É", "E")
                nombre = nombre.replaceAll("Í", "I")
                nombre = nombre.replaceAll("Ó", "O")
                nombre = nombre.replaceAll("Ú", "U")

                apellidoPaterno = apellidoPaterno.replaceAll("Á", "A")
                apellidoPaterno = apellidoPaterno.replaceAll("É", "E")
                apellidoPaterno = apellidoPaterno.replaceAll("Í", "I")
                apellidoPaterno = apellidoPaterno.replaceAll("Ó", "O")
                apellidoPaterno = apellidoPaterno.replaceAll("Ú", "U")

                if(apellidoMaterno != null){
                    log.info ("SI TRAE APELLIDO MATERNO")
                    apellidoMaterno = apellidoMaterno.replaceAll("Á", "A")
                    apellidoMaterno = apellidoMaterno.replaceAll("É", "E")
                    apellidoMaterno = apellidoMaterno.replaceAll("Í", "I")
                    apellidoMaterno = apellidoMaterno.replaceAll("Ó", "O")
                    apellidoMaterno = apellidoMaterno.replaceAll("Ú", "U")
                } else {
                    log.info ("NO TRAE APELLIDO MATERNO")
                }
                
            } else {
                log.info ("PERSONA MORAL")
                nombre = params.nombre?.trim()
                if(nombre?.length() > 0){
                    nombre = nombre?.replaceAll("\\s+", " ")
                } else {
                    nombre = null;
                }
                apellidoPaterno = params.apellidoPaterno?.trim()
                if(apellidoPaterno?.length() > 0){
                    apellidoPaterno = apellidoPaterno?.replaceAll("\\s+", " ")
                } else {
                    apellidoPaterno = null;
                }
                apellidoMaterno = params.apellidoMaterno?.trim()
                if(apellidoMaterno?.length() > 0){
                    apellidoMaterno = apellidoMaterno?.replaceAll("\\s+", " ")
                } else {
                    apellidoMaterno = null;
                }
                
                nombre = nombre.replaceAll("Á", "A")
                nombre = nombre.replaceAll("É", "E")
                nombre = nombre.replaceAll("Í", "I")
                nombre = nombre.replaceAll("Ó", "O")
                nombre = nombre.replaceAll("Ú", "U")
            }
            
            log.info "------------------------------------------------------------------------------------------------------"
            log.info "NOMBRE | " + nombre + " APELLIDO PATERNO | " + apellidoPaterno + " APELLIDO MATERNO " + apellidoMaterno
            
            log.info ("Buscando: " + nombre + " " + apellidoPaterno + " " + apellidoMaterno)
            persona = Persona.findWhere(nombre: nombre, apellidoPaterno: apellidoPaterno, apellidoMaterno: apellidoMaterno)
            if(persona){
                map.respuesta = "COMPLETE"
                map.persona = "[" + persona.id + "] - " + persona.toString()
                render map as JSON
            } else {
                persona = new Persona()
                persona.tipoDePersona = TipoDePersona.get(params.tipoDePersona.id as long)
                persona.nombre = nombre
                persona.apellidoPaterno = apellidoPaterno
                persona.apellidoMaterno = apellidoMaterno
                persona.rfc = params.rfc
                persona.numeroSeguroSocial = params.numeroSeguroSocial
                map.respuesta = "INCOMPLETE"
        
                if (persona.validate()) {
                    if(persona.save(flush:true)){
                        map.respuesta = "COMPLETE"
                        map.persona = "[" + persona.id + "] - " + persona.toString()
                    } else{
                        map = persona.errors
                    }
            
                    render map as JSON
                } else {
                    transactionStatus.setRollbackOnly()
                    render persona.errors as JSON 
                }
            }
        }
    }
    
    @Transactional    
    def update(Persona persona){
        if (persona == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (persona.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond persona.errors, view:'edit'
            return
        }

        persona.save flush:true
        redirect action: "edit", params: [message: "El actor " + persona + " se ha actualizado correctamente." ]
    }
    
    def buscarActores() {
        log.info ("PARAMETROS -> " + params)
        def actores = []
        if(params.query){
            def resultado = []
            //def resultado = Persona.executeQuery("from Persona p where (p.nombre||' '||p.apellidoPaterno||' '||p.apellidoMaterno) like '%"+params.query.toUpperCase()+"%' order by p.nombre")
            resultado = Persona.executeQuery("from Persona p where ((p.nombre + ' ' + p.apellidoPaterno + ' ' + p.apellidoMaterno) = '"+params.query.toUpperCase()+"') or (p.nombre like '"+params.query.toUpperCase()+"') order by p.nombre")
            log.info ("RESULTADO -> " + resultado)
            resultado.addAll(Persona.executeQuery("from Persona p where ((p.nombre + ' ' + p.apellidoPaterno + ' ' + p.apellidoMaterno) like '%"+params.query.toUpperCase()+"%') or (p.nombre like '%"+params.query.toUpperCase()+"%') order by p.nombre"))
            resultado = resultado as Set
            def map
            resultado.each{
                map = [:]
                map.value = "[" + it.id + "] - " + (it.nombre + ((it.apellidoPaterno) ? (" " +it.apellidoPaterno) : "") + ((it.apellidoMaterno) ? (" " + it.apellidoMaterno) : ""))
                map.id = it.id
                map.tokens = [it.nombre.toString(), it.apellidoPaterno.toString(),it.apellidoMaterno.toString()]
                actores << map
                map = null
            }
            log.info (actores)
        }
        render actores as JSON
    }
    
    def obtenerJuiciosDelActor(){
        log.info params
        if(params.idActor){
            def persona = Persona.get(params.idActor as long)
            if(persona){
                def juiciosDelActor = ActorJuicio.findAllWhere(persona: persona)
                render(template: "/templates/juiciosDelActor", model: [juiciosDelActor: juiciosDelActor])
            } else {
                def respuesta = [:]
                respuesta.mensaje = "<center><div class='alert alert-info'>La persona solicita no está registrada.</div></center>"
                respuesta.notFound = true
                render respuesta as JSON
            }
        } else{
            def respuesta = [:]
            respuesta.mensaje = "<center><div class='alert alert-info'>Asegúrese de buscar primero al actor que desea editar.</div></center>"
            respuesta.notFound = true
            render respuesta as JSON
        }
    }
}
