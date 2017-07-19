package mx.gox.infonavit.sicj.admin

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.converters.JSON
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class RegionController {

    private static final Logger log = LogManager.getLogger(RegionController)
    
    def index() { }
    
    @Transactional
    def save(){
        log.info params
        def region = new Region(params)
        def map = [:] 
        map.respuesta = "INCOMPLETE"
        
        if (region.hasErrors()) {
            transactionStatus.setRollbackOnly()
            render region.errors as JSON
        }
        
        if(region.save(flush:true)){
            map.respuesta = "COMPLETE"
            map.id = region.id
            map.nombre = region.nombre
        } else{
            map.respuesta = "ERROR DESCONOCIDO"
            map.error = true
        }
        
        render map as JSON
    }
    
    def obtenerRegiones = {
        log.info params
        def regiones = Region.list()
        regiones = regiones.sort { it.nombre }
        render regiones as JSON
    }
}
