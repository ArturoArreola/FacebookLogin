/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package mx.gob.infonavit.sicj.jobs

/**
 *
 * @author miklex
 */
import mx.gox.infonavit.sicj.admin.Aviso
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext

class CaducaAvisosJob {

    private static final Logger log = LogManager.getLogger(CaducaAvisosJob)
    
    def concurrent = false
    def quartzScheduler
    
    static triggers = {
        cron name:'cronExpiracionDePasswords', startDelay:10000, cronExpression: '0 22 0 * * ?'
    }

    def execute() {
        log.info "*** PROCESO AUTOMÁTICO DE EXPIRACION DE AVISOS"
        def avisos = Aviso.findAllByFechaLimiteLessThan(new Date())
        avisos.each { aviso ->
            log.info "Aviso -> " + aviso.tituloAviso
            aviso.activo = false
            if (aviso.save(flush:true)) {
                log.info "Aviso ${aviso.tituloAviso} Expirado."
            }
        }
        log.info "*** FIN DEL PROCESO AUTOMÁTICO DE EXPIRACION DE AVISOS"
    }
}

