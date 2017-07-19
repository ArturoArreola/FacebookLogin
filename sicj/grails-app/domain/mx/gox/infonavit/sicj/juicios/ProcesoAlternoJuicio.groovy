package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.Autoridad
import mx.gox.infonavit.sicj.catalogos.EstadoDeProcesoAlterno
import mx.gox.infonavit.sicj.catalogos.TipoDeParte
import mx.gox.infonavit.sicj.catalogos.TipoDeProcesoAlterno

class ProcesoAlternoJuicio implements Serializable {

    Juicio juicio
    TipoDeProcesoAlterno tipoDeProcesoAlterno
    EstadoDeProcesoAlterno estadoDeProceso
    Autoridad autoridadJudicial
    String expediente
    String observaciones
    Date fechaDeRegistro = new Date()
    Usuario usuarioQueRegistro
    Date fechaDeTermino
    Usuario usuarioQueTermino
    String notasFinales
    ArchivoJuicio archivo

    static constraints = {
        juicio (nullable:false)
        tipoDeProcesoAlterno (nullable:false)
        estadoDeProceso (nullable:false)
        autoridadJudicial (nullable:false)
        expediente (nullable:false)
        observaciones (nullable:true)
        fechaDeRegistro (nullable:false)
        usuarioQueRegistro (nullable:false)
        fechaDeTermino (nullable:true)
        usuarioQueTermino (nullable:true)
        notasFinales (nullable:true)
        archivo (nullable:true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_proceso_alterno_juicio', params:[sequence:'proceso_alterno_juicio_id_seq']
    }
}
